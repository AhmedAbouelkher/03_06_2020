abstract class BaseTag {
  String id;
  String name;
  BaseTag(this.id, this.name);

  BaseTag.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
  }
}
