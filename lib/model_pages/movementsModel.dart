


class movementsModel {
  int? id;
  int catagoryid;
  double amount;
  String note;
  String create;
  String type;
  movementsModel({this.id, required this.catagoryid, required this.amount,required this.create,required this.note,required this.type});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catagoryid': catagoryid,
      'amount': amount,
      'create': create,
      'type': type,
      'note': note
    };
  }
}