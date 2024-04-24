import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../Providers/OfficerReplyProvīder.dart';
import '../model/OfficerComment_model.dart';

class CommentReplyClass extends ConsumerWidget {
  CommentReplyClass({Key? key}) : super(key: key);



  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);

  @override
  Widget build(BuildContext context,WidgetRef  ref) {
    final _data = ref.watch(officerreplyDataProvider);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title:  const Text("OFFICER'S REPLY"),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          },),
        ),
        body: RefreshIndicator(
          onRefresh: () async=> await ref.refresh(officerreplyDataProvider),
          child: _data.when(
              data: (_data){
                List<OfficerReply> commList = _data.map((e) => e).toList();

                if(commList.isEmpty)
                  {
                    return Center(
                      child: Container(
                        child: const Text("NO RECORD FOUND"),
                      ),
                    );
                  }
                else
                  {
                    return ListView.builder(
                        itemCount: commList.length, itemBuilder: (_, index) {
                      return Card(
                        child: Container(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            title: Column(
                              children: [
                                const SizedBox(height: 5,),
                                Container(
                                  child:const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("S.NO ",
                                        style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                                      Text("DATE ",
                                        style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 14),),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("${index+1}",
                                      style:const TextStyle(fontWeight: FontWeight.w400,color: Colors.indigo,
                                          fontSize: 15),),
                                    Text("${commList[index].msDate.day}/${commList[index].msDate.month}/${commList[index].msDate.year}",
                                      style:const TextStyle(fontWeight: FontWeight.w400,color: Colors.indigo,
                                          fontSize: 15),),
                                  ],
                                ),
                                Divider(color: Colors.orange.shade900,),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text("MESSAGE ",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.orange.shade900,),),),

                                Row(
                                  children: [
                                    Text("${commList[index].message.replaceAll('&nbsp;', '').replaceAll(exp, '')}",
                                      style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo.shade800,
                                          fontSize: 18,fontFamily: 'DancingScript'),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }

              },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        bottomNavigationBar: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            var connectivityStatusProvider = ref.watch(connectivityStatusProviders);
            return connectivityStatusProvider == ConnectivityStatus.isConnected?Container(
              child:const Text(""),
            ) :Center(
              child: Container(
                child:const Image(image: AssetImage('images/offline.png'),),
              ),
            );
          },
        ),
      ),
      onWillPop: (){
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        return Future.value(true);
      },
    );
  }
}

