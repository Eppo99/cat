import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cats/data/cat_cubit.dart';
import 'package:cats/data/cat_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var box = Hive.box('text');
  deleteHive(){
    box.clear();
    Hive.box('id').clear();
    getCat();
  }
  getCat() async {
    await BlocProvider.of<CatCubit>(context).fetchCat();
  }

  @override void initState() {
    super.initState();
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextButton(onPressed: deleteHive, child: Text('Удалить')),
                              TextButton(onPressed: (){
                                 Navigator.pop(context);
                              },
                                  child: Text('Назад')),
                            ],
                          ),
                          if(Hive.box('id').get('id')!=0 || Hive.box('id').get('id') != null)
                          for(int i=0;i<=Hive.box('id').get('id');i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\n$i.${box.get(i)}"),
                                Text("created: ${box.get('d$i')}", style: TextStyle(color: Colors.indigoAccent)),
                              ],
                            )
                          else Text('Нет данных')
                        ],
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



