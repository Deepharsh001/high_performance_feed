import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post_model.dart';
import '../services/feed_service.dart';

final feedProvider =
StateNotifierProvider<FeedNotifier, AsyncValue<List<PostModel>>>(
      (ref) => FeedNotifier(),
);

class FeedNotifier
    extends StateNotifier<AsyncValue<List<PostModel>>> {

  FeedNotifier() : super(const AsyncLoading()) {
    fetchInitialPosts();
  }

  final FeedService _feedService = FeedService();

  final SupabaseClient _supabase =
      Supabase.instance.client;

  int _currentPage = 0;

  final int _pageSize = 10;

  List<PostModel> _posts = [];

  bool _isSyncingLike = false;

  // INITIAL FETCH

  Future<void> fetchInitialPosts() async {

    try {

      _currentPage = 0;

      final posts = await _feedService.fetchPosts(
        from: 0,
        to: _pageSize - 1,
      );

      _posts = posts;

      state = AsyncData([..._posts]);

    } catch (e, stack) {

      state = AsyncError(e, stack);
    }
  }

  // PAGINATION

  Future<void> loadMorePosts() async {

    try {

      _currentPage++;

      final from = _currentPage * _pageSize;

      final to = from + _pageSize - 1;

      final newPosts = await _feedService.fetchPosts(
        from: from,
        to: to,
      );

      _posts = [..._posts, ...newPosts];

      state = AsyncData([..._posts]);

    } catch (e, stack) {

      state = AsyncError(e, stack);
    }
  }

  // OPTIMISTIC LIKE

  Future<void> toggleLike(String postId) async {

    if (_isSyncingLike) return;

    _isSyncingLike = true;

    PostModel? targetPost;

    bool previousLikeState = false;

    int previousLikeCount = 0;

    // LOCAL UPDATE

    for (final post in _posts) {

      if (post.id == postId) {

        targetPost = post;

        previousLikeState = post.isLiked;

        previousLikeCount = post.likeCount;

        post.isLiked = !post.isLiked;

        if (post.isLiked) {
          post.likeCount++;
        } else {
          post.likeCount--;
        }

        break;
      }
    }

    state = AsyncData([..._posts]);

    try {

      // RPC CALL

      await _supabase.rpc(
        'toggle_like',
        params: {
          'p_post_id': postId,
          'p_user_id': 'user_123',
        },
      );

    } catch (e) {

      // OFFLINE REVERT

      if (targetPost != null) {

        targetPost.isLiked = previousLikeState;

        targetPost.likeCount = previousLikeCount;
      }

      state = AsyncData([..._posts]);
    }

    _isSyncingLike = false;
  }
}