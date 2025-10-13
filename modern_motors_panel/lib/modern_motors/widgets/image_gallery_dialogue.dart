import 'package:flutter/material.dart';
import 'package:modern_motors_panel/widgets/image_gallery_widget.dart';

class ImageGalleryDialog extends StatelessWidget {
  final List<String> imageUrls;
  final double thumbnailSize;
  final double spacing;

  const ImageGalleryDialog({
    super.key,
    required this.imageUrls,
    this.thumbnailSize = 40.0,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Image Gallery'),
      content: SizedBox(
        width: 500,
        child: ImageGalleryWidget(
          imageUrls: imageUrls,
          thumbnailSize: thumbnailSize,
          spacing: spacing,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
