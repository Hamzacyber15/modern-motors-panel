// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/model/sales_model/sale_model.dart';
import 'package:modern_motors_panel/model/services_model/services_model.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsDialog extends StatelessWidget {
  final SaleModel saleDetails;
  final VoidCallback? onClose;

  const ProductDetailsDialog({
    super.key,
    required this.saleDetails,
    this.onClose,
  });

  static void show(BuildContext context, SaleModel saleDetails) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsDialog(saleDetails: saleDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            _buildSaleInfo(),
            const SizedBox(height: 20),
            _buildProductsTitle(),
            const SizedBox(height: 12),
            Flexible(child: _buildProductsList(context)),
            const SizedBox(height: 20),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Sale Products",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => Navigator.of(context).pop(),
          color: const Color(0xFF718096),
        ),
      ],
    );
  }

  Widget _buildSaleInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        "MM: ${saleDetails.invoice}",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildProductsTitle() {
    return Text(
      "Items:",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
        letterSpacing: 0.5,
      ),
    );
  }

  // Widget _buildProductsList(BuildContext context) {
  //   return Consumer<MmResourceProvider>(
  //     builder: (context, provider, child) {
  //       return SingleChildScrollView(
  //         child: Column(
  //           children: saleDetails.items.asMap().entries.map((entry) {
  //             final index = entry.key;
  //             final saleItem = entry.value;
  //             final product = provider.getProductByID(saleItem.productId);
  //             final service = provider.getServiceById(saleItem.productId);
  //             return saleItem.type == "product"
  //                 ? _buildProductCard(
  //                     context,
  //                     saleItem,
  //                     index,
  //                     product,
  //                   )
  //                 : _builServiceCard(context, saleItem, index, service);
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildProductsList(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, provider, child) {
        // Comprehensive null checking
        if (saleDetails.items == null || saleDetails.items!.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        return SingleChildScrollView(
          child: Column(
            children: saleDetails.items!.asMap().entries.map((entry) {
              final index = entry.key;
              final saleItem = entry.value;

              // Skip null items or items without productId/type
              if (saleItem.productId.isEmpty) {
                return const SizedBox.shrink();
              }

              // FIX: Only call the appropriate method based on item type
              if (saleItem.type == "product") {
                final product = provider.getProductByID(saleItem.productId);
                return _buildProductCard(
                  context,
                  saleItem,
                  index,
                  product, // Could be null
                );
              } else if (saleItem.type == "service") {
                final service = provider.getServiceById(saleItem.productId);
                return _builServiceCard(
                  context,
                  saleItem,
                  index,
                  service, // Could be null
                );
              } else {
                // Handle unknown types
                return _buildUnknownItemCard(context, saleItem, index);
              }
            }).toList(),
          ),
        );
      },
    );
  }

  // Fallback for unknown item types
  Widget _buildUnknownItemCard(
    BuildContext context,
    SaleItem saleItem,
    int index,
  ) {
    return Card(
      child: ListTile(
        title: Text('Unknown Item Type: ${saleItem.type}'),
        subtitle: Text('ID: ${saleItem.productId}'),
      ),
    );
  }

  Widget _builServiceCard(
    BuildContext context,
    SaleItem saleItem,
    int index,
    ServiceTypeModel service,
  ) {
    if (saleItem.productId.isEmpty) {
      return _buildLoadingCard();
    }
    String image = "";
    final hasDiscount = saleItem.discount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          SizedBox(width: 60, child: _buildProductImage("")),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  saleItem.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Quantity
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 14,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${saleItem.quantity}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // Additional indicators
                if (hasDiscount) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_offer_outlined,
                        size: 14,
                        color: Color(0xFF718096),
                      ),
                      const SizedBox(width: 4),
                      if (hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Discount ${saleItem.discount.toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Price Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Total Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(saleItem.totalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "OMR",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Unit Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(saleItem.sellingPrice),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Text(
                    "/service",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    SaleItem saleItem,
    int index,
    ProductModel? product,
  ) {
    if (saleItem.productId.isEmpty) {
      return _buildLoadingCard();
    }
    // ProductCategoryModel category = context
    //     .read<MmResourceProvider>()
    //     .getProductCategoryByID(product!.categoryId!);
    // ProductSubCatorymodel subCategory = context
    //     .read<MmResourceProvider>()
    //     .getProductSubCategoryByID(product.subCategoryId!);
    final hasDiscount = saleItem.discount > 0;
    final hasMargin = saleItem.margin > 0;
    if (saleItem.type == "product") {}
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          SizedBox(width: 60, child: _buildProductImage(product!.image!)),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  saleItem.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Product Code
                Row(
                  children: [
                    const Icon(
                      Icons.qr_code_2_outlined,
                      size: 14,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Code: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      "P-${product.code ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Quantity
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 14,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${saleItem.quantity}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // Additional indicators
                if (hasDiscount) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_offer_outlined,
                        size: 14,
                        color: Color(0xFF718096),
                      ),
                      const SizedBox(width: 4),
                      // if (hasMargin) ...[
                      //   Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 6,
                      //       vertical: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.green,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Text(
                      //       "Margin ${saleItem.margin.toStringAsFixed(1)}%",
                      //       style: const TextStyle(
                      //         fontSize: 10,
                      //         fontWeight: FontWeight.w600,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      //   if (hasDiscount) const SizedBox(width: 4),
                      // ],
                      if (hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Discount ${saleItem.discount.toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Price Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Total Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(saleItem.totalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "OMR",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Unit Price
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPrice(saleItem.sellingPrice),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Text(
                    "/unit",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),

              if (product.categoryId != null || product.brandId != null) ...[
                const SizedBox(height: 8),
                if (product.categoryId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      product.categoryId!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ),
                if (product.brandId != null && product.brandId != null)
                  const SizedBox(height: 4),
                // if (product.brandId != null)
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFF0FFF4),
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(color: const Color(0xFFC6F6D5)),
                //     ),
                //     child: Text(
                //       product.bra!,
                //       style: const TextStyle(
                //         fontSize: 10,
                //         fontWeight: FontWeight.w600,
                //         color: Color(0xFF22543D),
                //       ),
                //     ),
                //   ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String image) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image.isNotEmpty
            ? Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderImage(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoader();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 24,
          color: Color(0xFF718096),
        ),
      ),
    );
  }

  Widget _buildImageLoader() {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF718096)),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final totalAmount = saleDetails.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final totalItems = saleDetails.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sale Summary",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$totalItems items • ${_formatPrice(totalAmount)} OMR",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double? price) {
    if (price == null) return "0.00";
    return price.toStringAsFixed(2);
  }
}

// Usage extension for easy access
extension ProductDetailsDialogExtension on SaleModel {
  void showProductDetails(BuildContext context) {
    ProductDetailsDialog.show(context, this);
  }
}
