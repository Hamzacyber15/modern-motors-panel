class DropDownMenuDataModel {
  String id;
  String title;
  String value;
  String? image;
  String? status;
  DropDownMenuDataModel(
    this.id,
    this.title,
    this.value, {
    this.image,
    this.status,
  });
}
