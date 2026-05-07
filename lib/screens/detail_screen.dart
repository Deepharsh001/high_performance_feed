import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';

class DetailScreen extends StatefulWidget {

  final PostModel post;

  const DetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {

  bool _showHighQuality = false;

  bool _downloadingRaw = false;

  @override
  void initState() {
    super.initState();

    _loadHighQualityImage();
  }

  Future<void> _loadHighQualityImage() async {

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (mounted) {

      setState(() {
        _showHighQuality = true;
      });
    }
  }

  Future<void> _downloadHighRes() async {

    setState(() {
      _downloadingRaw = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (mounted) {

      setState(() {
        _downloadingRaw = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          'High-resolution image fetched successfully',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(),

      body: Column(

        children: [

          Expanded(

            child: Center(

              child: Hero(

                tag: widget.post.id,

                child: Stack(

                  alignment: Alignment.center,

                  children: [

                    // THUMBNAIL

                    CachedNetworkImage(
                      imageUrl: widget.post.thumbUrl,
                      fit: BoxFit.cover,
                    ),

                    // HIGH QUALITY IMAGE

                    AnimatedOpacity(

                      duration:
                      const Duration(milliseconds: 500),

                      opacity:
                      _showHighQuality ? 1 : 0,

                      child: CachedNetworkImage(

                        imageUrl:
                        widget.post.mobileUrl,

                        fit: BoxFit.cover,

                        memCacheWidth: 1080,

                        placeholder:
                            (context, url) =>
                        const SizedBox(),

                        errorWidget:
                            (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed:
                _downloadingRaw
                    ? null
                    : _downloadHighRes,

                child:
                _downloadingRaw

                    ? const CircularProgressIndicator()

                    : const Text(
                  'Download High-Res',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}