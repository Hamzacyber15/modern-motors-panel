class ValidationResult {
  final List<Map<String, dynamic>>? data;
  final List<String> errors;
  final bool isValid;

  ValidationResult({this.data, required this.errors})
    : isValid = errors.isEmpty;
}

ValidationResult buildProductsDataWithValidation(List<dynamic> productRows) {
  final errors = <String>[];

  // Check if productRows is empty
  if (productRows.isEmpty) {
    errors.add("Product list cannot be empty");
    return ValidationResult(errors: errors);
  }

  // Validate each row
  for (int i = 0; i < productRows.length; i++) {
    final row = productRows[i];
    final rowNumber = i + 1;

    if (row == null) {
      errors.add("Row $rowNumber is null");
      continue; // Continue checking other rows
    }

    // Check quantity
    if (row.quantity < 1) {
      errors.add("Quantity in row $rowNumber cannot be less than 1");
    }

    // Check selling price vs minimum price
    final minimumPrice = row.saleItem?.minimumPrice ?? 0;
    if (row.sellingPrice < minimumPrice) {
      errors.add(
        "Selling price in row $rowNumber (${row.sellingPrice}) cannot be less than minimum price ($minimumPrice) for product: ${row.saleItem?.productName ?? 'Unknown'}",
      );
    }

    // Check required fields
    if (row.saleItem?.productId == null || row.saleItem?.productId.isEmpty) {
      errors.add("Product ID is missing in row $rowNumber");
    }

    if (row.saleItem?.productName == null ||
        row.saleItem?.productName.isEmpty) {
      errors.add("Product name is missing in row $rowNumber");
    }
  }

  // If there are errors, return them
  if (errors.isNotEmpty) {
    return ValidationResult(errors: errors);
  }

  // If no errors, build and return data
  final data = productRows.map((row) {
    return {
      'type': row.saleItem?.type,
      'productId': row.saleItem?.productId,
      'productName': row.saleItem?.productName,
      'sellingPrice': row.sellingPrice,
      'quantity': row.quantity,
      'discount': row.discount,
      'applyVat': row.applyVat,
      'subtotal': row.subtotal,
      'vatAmount': row.vatAmount,
      'total': row.total,
      'profit': row.profit,
    };
  }).toList();

  return ValidationResult(data: data, errors: []);
}
