import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/post_model.dart';

class FeedService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<PostModel>> fetchPosts({
    required int from,
    required int to,
  }) async {
    final response = await supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false)
        .range(from, to);

    return response
        .map<PostModel>((json) => PostModel.fromJson(json))
        .toList();
  }
}