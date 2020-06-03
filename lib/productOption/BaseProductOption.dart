abstract class AdModelOption {
  String name;
  String value;
  String meta;
  String price;

  AdModelOption(this.name, this.value, this.meta, this.price);

  AdModelOption.fromJson(Map<String,dynamic> jsonObject){
    this.name = jsonObject['name'];
    this.value = jsonObject['value'];
    this.meta = jsonObject['meta'];
    this.price = jsonObject['price'];
    
    
  }
}
