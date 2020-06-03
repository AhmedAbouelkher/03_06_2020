import 'package:haftaa/Tag/BaseTag.dart';

class TagController {
  BaseTag tag;
  TagController(this.tag);

  static List<BaseTag> toTags(List<Map<String, dynamic>> jsonObjects) {}
}
