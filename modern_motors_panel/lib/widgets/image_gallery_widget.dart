// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class ImageGalleryWidget extends StatefulWidget {
//   final List<String> imageUrls;
//   final double thumbnailSize;
//   final double spacing;

//   const ImageGalleryWidget({
//     super.key,
//     required this.imageUrls,
//     this.thumbnailSize = 40.0,
//     this.spacing = 8.0,
//   });

//   @override
//   ImageGalleryWidgetState createState() => ImageGalleryWidgetState();
// }

// class ImageGalleryWidgetState extends State<ImageGalleryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.imageUrls.isEmpty) {
//       return const Text('No images');
//     }

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: widget.imageUrls.map((url) {
//           return Padding(
//             padding: EdgeInsets.only(right: widget.spacing),
//             child: GestureDetector(
//               onTap: () => _showFullImage(context, url),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(4.0),
//                 child: CachedNetworkImage(
//                   imageUrl: url,
//                   width: widget.thumbnailSize,
//                   height: widget.thumbnailSize,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     width: widget.thumbnailSize,
//                     height: widget.thumbnailSize,
//                     color: Colors.grey[200],
//                     child: const Center(child: CircularProgressIndicator()),
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     width: widget.thumbnailSize,
//                     height: widget.thumbnailSize,
//                     color: Colors.grey[200],
//                     child: const Icon(Icons.broken_image),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: CachedNetworkImage(
//             imageUrl: imageUrl,
//             fit: BoxFit.contain,
//             placeholder: (context, url) => Container(
//               color: Colors.grey[200],
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//             errorWidget: (context, url, error) => Container(
//               color: Colors.grey[200],
//               child: const Center(child: Icon(Icons.broken_image)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageGalleryWidget extends StatefulWidget {
  final List<String> imageUrls;
  final double thumbnailSize;
  final double spacing;
  final double hoverScale;

  const ImageGalleryWidget({
    super.key,
    required this.imageUrls,
    this.thumbnailSize = 60.0, // Slightly larger default size
    this.spacing = 8.0,
    this.hoverScale = 1.5,
  });

  @override
  State<ImageGalleryWidget> createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  String? _hoveredImageUrl;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const Text(
        'No images available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.imageUrls.map((url) {
          final isHovered = _hoveredImageUrl == url;
          final scale = isHovered ? widget.hoverScale : 1.0;
          final margin = isHovered
              ? EdgeInsets.zero
              : EdgeInsets.all(
                  widget.thumbnailSize * (widget.hoverScale - 1) / 2,
                );

          return Padding(
            padding: EdgeInsets.only(right: widget.spacing),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hoveredImageUrl = url),
              onExit: (_) => setState(() => _hoveredImageUrl = null),
              child: GestureDetector(
                onTap: () => _showFullImage(context, url),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(scale),
                  transformAlignment: Alignment.center,
                  margin: margin,
                  child: _buildThumbnail(url),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _hoveredImageUrl == url
                ? Colors.blue.shade300
                : Colors.grey.shade300,
            width: _hoveredImageUrl == url ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          width: widget.thumbnailSize,
          height: widget.thumbnailSize,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
