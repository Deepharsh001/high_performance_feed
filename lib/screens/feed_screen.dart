import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/feed_provider.dart';
import 'detail_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() =>
      _FeedScreenState();
}

class _FeedScreenState
    extends ConsumerState<FeedScreen> {

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {

      ref
          .read(feedProvider.notifier)
          .loadMorePosts();
    }
  }

  @override
  void dispose() {

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final feedState = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'High Performance Feed',
        ),
      ),

      body: feedState.when(

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) => Center(
          child: Text(error.toString()),
        ),

        data: (posts) {

          return RefreshIndicator(

            onRefresh: () async {

              await ref
                  .read(feedProvider.notifier)
                  .fetchInitialPosts();
            },

            child: ListView.builder(

              controller: _scrollController,

              itemCount: posts.length,

              itemBuilder: (context, index) {

                final post = posts[index];

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(post: post),
                      ),
                    );
                  },

                  child: RepaintBoundary(

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Hero(

                        tag: post.id,

                        child: Container(
                          height: 300,

                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(20),

                            color: Colors.grey.shade900,

                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.black.withOpacity(0.5),

                                blurRadius: 25,
                                spreadRadius: 5,

                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Stack(
                            children: [

                              // IMAGE

                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(20),

                                child: CachedNetworkImage(

                                  imageUrl: post.thumbUrl,

                                  fit: BoxFit.cover,

                                  width: double.infinity,
                                  height: double.infinity,

                                  memCacheWidth: 600,

                                  placeholder:
                                      (context, url) =>
                                  const Center(
                                    child:
                                    CircularProgressIndicator(),
                                  ),

                                  errorWidget:
                                      (context, url, error) =>
                                  const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),

                              // GRADIENT

                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),

                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,

                                      colors: [
                                        Colors.transparent,

                                        Colors.black.withOpacity(
                                          0.7,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // LIKE BUTTON

                              Positioned(
                                bottom: 20,
                                right: 20,

                                child: Row(
                                  children: [

                                    IconButton(

                                      onPressed: () {

                                        ref
                                            .read(feedProvider.notifier)
                                            .toggleLike(post.id);
                                      },

                                      icon: Icon(

                                        post.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,

                                        color: post.isLiked
                                            ? Colors.red
                                            : Colors.white,

                                        size: 32,
                                      ),
                                    ),

                                    Text(
                                      post.likeCount.toString(),

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}