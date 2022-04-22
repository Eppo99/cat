import 'package:bloc/bloc.dart';
import 'package:cats/data/cat_hive.dart';
import 'package:cats/data/cat_model.dart';
import 'package:cats/data/repository.dart';
import 'package:hive/hive.dart';
import 'cat_state.dart';
class CatCubit extends Cubit<CatState>{
  List<CatModel> cats = [];
  int current =0;
  final CatRepository catRepository;
  CatCubit({required this.catRepository}) : super(CatEmptyState());
  Future <void> fetchCat() async{
    try{
      emit(CatLoadingState());
        final _getCat = await catRepository.getFact();
        cats.add(_getCat);
      emit(CatLoadedState(loadedCat: _getCat));
    }
    catch(error){
      print(error);
      emit(CatErrorState());
    }
  }

}
