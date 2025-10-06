import 'package:flutter/material.dart';

class TableImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  const TableImageWidget({super.key, required this.imageUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);

    // Empty imageUrl case
    if (imageUrl.isEmpty) {
      return _buildFallbackContainer(
        context,
        icon: Icons.point_of_sale,
        borderRadius: borderRadius,
      );
    }

    // Image with placeholder & error handling
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/icons/broken image.png',
          image: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 200),
          placeholderFit: BoxFit.contain,
          imageErrorBuilder: (context, error, stackTrace) {
            return _buildFallbackContainer(
              context,
              icon: Icons.broken_image,
              borderRadius: borderRadius,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallbackContainer(
    BuildContext context, {
    required IconData icon,
    required BorderRadius borderRadius,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: size * 0.5,
      ),
    );
  }
}
