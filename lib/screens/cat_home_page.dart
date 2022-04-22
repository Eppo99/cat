
import 'dart:typed_data';

import 'package:cats/data/cat_model.dart';
import 'package:cats/screens/history.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cats/data/cat_cubit.dart';
import 'package:cats/data/cat_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class Cat extends StatefulWidget {
  const Cat({Key? key}) : super(key: key);

  @override
  State<Cat> createState() => _CatState();
}

class _CatState extends State<Cat> {
  var box = Hive.box('text');
  late Iterable hiveValues = box.values;
  String url =
      'https://cataas.com/cat';
  late Widget _pic;
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  Future<void> onRefresh() async {
    BlocProvider.of<CatCubit>(context).fetchCat();
    refreshController.refreshCompleted();
  }
  getCat() async {
    await BlocProvider.of<CatCubit>(context).fetchCat();
  }
  updateImg() async {
    setState(() {
      _pic = CircularProgressIndicator();
    });
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    setState(() {
      _pic = Image.memory(bytes);
    });
  }
  Future<void> onLoading() async {
    // log("refresh loaded");
    BlocProvider.of<CatCubit>(context).fetchCat();
    refreshController.loadComplete();
    setState(() {});
  }
  @override void initState() {
    // TODO: implement initState
    super.initState();
    getCat();
    _pic = Image.network(url);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CatCubit, CatState>(listener: (context, state) {
        if (state is CatLoadedState) {}
      }, builder: (context, state) {
        if (state is CatErrorState) {
          return const Center(
            child: Text(
              'Error lost internet connection!!!',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          );
        }
        if (state is CatLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CatLoadedState) {
          return  Scaffold(
              body: SafeArea(
                child: SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  onRefresh: () async {
                    onRefresh();
                  },
                  onLoading: () async {
                    onLoading();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        _pic,
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const History()),
                                          );
                                        }, child: Text('История')),
                                        TextButton(onPressed: (){
                                          updateImg();
                                          BlocProvider.of<CatCubit>(context).fetchCat();
                                          },
                                            child: Text('Обновить')),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("\n:${(box.get(Hive.box('id').get('id'))) }"),
                                        Text("created: ${box.get("d${Hive.box('id').get('id')}")}",style: TextStyle(color: Colors.indigoAccent),),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                ),
              ),

          );
        } else {
          // log("error");
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigoAccent,
            ),
          );
        } //Center(child: CircularProgressIndicator(),);
      }),
    );
  }
}



