abstract class BaseImage {
  String id;
  String name;
  String url;
  String base64String;
  String altText;

  BaseImage(this.id, this.name, this.url, this.base64String,this.altText);

  BaseImage.fromJson(Map<String, dynamic> jsonObject) {
    
  }
  
}
