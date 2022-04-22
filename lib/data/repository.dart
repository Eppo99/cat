import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'cat_model.dart';

class CatToRepository{
  Future putOnBox(CatModel fact) async{
    var box = Hive.box('text');
    var hiveId = Hive.box('id');
    late int current;
    if(hiveId.get('id') == null) {
      hiveId.put('id', 0);
      current = hiveId.get('id');
      box.put(current,fact.catFact);
      box.put('d${current}',DateFormat('yyyy-MM-dd – kk:mm').format(fact.createdDate));
    }
    else{
      current=hiveId.get('id');
      current++;
      hiveId.put('id', current);
      box.put(current,fact.catFact);
      box.put('d${current}',DateFormat('yyyy-MM-dd – kk:mm').format(fact.createdDate));
      print(box.get('d$current'));

    }
  }
  Future <CatModel> getFact() async{
    final response = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if(response.statusCode == 200){
      CatModel catFact = CatModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      putOnBox(catFact);

      print ("FROM API ${catFact.catFact}");
      return catFact;
    }else {
      log("erroorrr fact get catfact null");
      throw Exception('Error fetching facts');
    }

  }
}

class CatRepository{
  CatToRepository _catRepositories = CatToRepository();
  Future <CatModel> getFact()=> _catRepositories.getFact();
}