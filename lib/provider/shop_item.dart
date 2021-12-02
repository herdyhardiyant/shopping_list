
class ShopItem {
  final String id;
  String name;
  bool isCheck;
  ShopItem({required this.id, required this.name, required this.isCheck});

  void setName(String newName){
    name = newName;
  }

  void setIsCheck(bool isChecked){
    isCheck = isChecked;
  }

}
