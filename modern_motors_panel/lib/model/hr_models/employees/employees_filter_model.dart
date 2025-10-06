class EmployeeFilterModel {
  String? status;
  String? branchId;
  String? designationId;
  String? permission;

  EmployeeFilterModel({
    this.status,
    this.branchId,
    this.designationId,
    this.permission,
  });

  bool get hasActiveFilters =>
      status != null ||
      branchId != null ||
      designationId != null ||
      permission != null;

  void clear() {
    status = null;
    branchId = null;
    designationId = null;
    permission = null;
  }
}

class AssetFilterModel {
  String? status;
  String? categoryId;
  String? parentCategoryId;

  AssetFilterModel({this.status, this.categoryId, this.parentCategoryId});

  bool get hasActiveFilters =>
      status != null || categoryId != null || parentCategoryId != null;

  void clear() {
    status = null;
    categoryId = null;
    parentCategoryId = null;
  }
}
