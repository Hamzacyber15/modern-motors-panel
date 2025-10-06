class ExcelExporter {
  static Future<void> exportToExcel({
    required List<String> headers,
    required List<List<dynamic>> rows,
    String? fileNamePrefix,
  }) async {
    // final excel = Excel.createExcel();
    // excel.rename('Sheet1', 'ExportSheet');
    // final sheet = excel['ExportSheet'];

    // final boldStyle = CellStyle(
    //   bold: true,
    //   fontFamily: getFontFamily(FontFamily.Calibri),
    //   fontSize: 12,
    // );

    // final rowTextStyle = CellStyle(
    //   fontSize: 12, // Default is 10, increase as needed
    //   fontFamily: getFontFamily(FontFamily.Calibri),
    // );

    // for (int i = 0; i < headers.length; i++) {
    //   // sheet.getColumnAutoFit(i);
    //   // sheet
    //   //     .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
    //   //     .value = TextCellValue(headers[i]);
    //   final cell = sheet.cell(
    //     CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
    //   );
    //   cell.value = TextCellValue(headers[i]);
    //   cell.cellStyle = boldStyle;
    // }

    // for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
    //   for (int colIndex = 0; colIndex < headers.length; colIndex++) {
    //     final value = rows[rowIndex][colIndex];
    //     final cell = sheet.cell(
    //       CellIndex.indexByColumnRow(
    //         columnIndex: colIndex,
    //         rowIndex: rowIndex + 1,
    //       ),
    //     );

    //     if (value is num) {
    //       cell.value = DoubleCellValue(value.toDouble());
    //     } else {
    //       cell.value = TextCellValue(value.toString());
    //     }

    //     cell.cellStyle = rowTextStyle;
    //   }
    // }

    // for (int colIndex = 0; colIndex < headers.length; colIndex++) {
    //   int maxLength = headers[colIndex].length;

    //   for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
    //     final value = rows[rowIndex][colIndex].toString();
    //     if (value.length > maxLength) {
    //       maxLength = value.length;
    //     }
    //   }

    //   // Multiply by a scaling factor to get a reasonable column width
    //   // double width = (maxLength * 1.5).clamp(10, 50).toDouble();
    //   double width = (maxLength * 1.3).clamp(5, 80).toDouble();
    //   sheet.setColumnWidth(colIndex, width);
    // }

    // excel.save(
    //   fileName:
    //       '${fileNamePrefix ?? "export"}_${(DateTime.now()).formattedWithYMDHMS}.xlsx',
    // );
  }
}
