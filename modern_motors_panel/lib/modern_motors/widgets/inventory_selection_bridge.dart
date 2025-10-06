import 'package:flutter/foundation.dart';
import 'package:modern_motors_panel/model/inventory_models/inventory_model.dart';
import 'package:modern_motors_panel/model/product_models/product_model.dart';
import 'package:modern_motors_panel/provider/estimation_provider.dart';
import 'package:modern_motors_panel/provider/maintenance_booking_provider.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';

class InventorySelectionBridge {
  /// Selected IDs for header checkbox state, etc.
  final Set<String> Function() selectedIds;

  /// Add/remove single item
  final void Function(InventoryModel, ProductModel) add;
  final void Function(InventoryModel, ProductModel) remove;

  /// Add many / clear all
  final void Function(List<InventoryModel>, List<ProductModel>) addAll;
  final VoidCallback clearAll;

  /// Toggle the “isItemsSelection” flag (to go back)
  final void Function(bool) setIsSelection;

  const InventorySelectionBridge({
    required this.selectedIds,
    required this.add,
    required this.remove,
    required this.addAll,
    required this.clearAll,
    required this.setIsSelection,
  });
}

InventorySelectionBridge bridgeFromMaintenance(MaintenanceBookingProvider p) {
  return InventorySelectionBridge(
    selectedIds: () => p.getSelectedInventoryIds,
    add: p.addInventory,
    remove: p.removeInventory,
    addAll: p.addAllInventory,
    clearAll: p.removeAllInventory,
    setIsSelection: p.setIsSelection, // make sure this exists in your provider
  );
}

InventorySelectionBridge bridgeFromEstimation(EstimationProvider p) {
  return InventorySelectionBridge(
    selectedIds: () => p.getSelectedInventoryIds,
    add: p.addInventory,
    remove: p.removeInventory,
    addAll: p.addAllInventory,
    clearAll: p.removeAllInventory,
    setIsSelection: p.setIsSelection,
  );
}

InventorySelectionBridge bridgeFromInvoice(SelectedInventoriesProvider p) {
  return InventorySelectionBridge(
    selectedIds: () => p.getSelectedInventoryIds,
    add: p.addInventory,
    remove: p.removeInventory,
    addAll: p.addAllInventory,
    clearAll: p.removeAllInventory,
    setIsSelection: p.setIsSelection,
  );
}
