class CatModel{
  CatModel({String? catFact}){
    _catFact= catFact;
  }
  String? _catFact;
  DateTime createdDate =DateTime.now();
  CatModel.fromJson(dynamic json){
    _catFact = json['fact'] as String;
  }

  String? get catFact => _catFact;

  Map<String,dynamic> toJson(){
    final map = <String,dynamic>{};
    map['fact'] = _catFact;
    return map;
  }
}
