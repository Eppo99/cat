import 'cat_model.dart';

abstract class CatState{}

class CatEmptyState extends CatState{}

class CatLoadingState extends CatState{}

class CatLoadedState extends CatState{
  CatModel loadedCat;
  CatLoadedState({required this.loadedCat}) : assert(loadedCat != null);

}

class CatErrorState extends CatState{}