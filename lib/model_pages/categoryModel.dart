

class categoryModel {
  int? id;
  String name;
  String image;
  String create;
  String lastpost;
  double maxbudget;
  double currentbudget;
  String type;
  categoryModel({required this.name, required this.image,required this.create,required this.maxbudget,required this.type,required this.currentbudget,this.id,required this.lastpost});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'create': create,
      'maxbudget': maxbudget,
      'type': type,
      'currentbudget': currentbudget,
      'lastpost': lastpost
    };
  }
}


