import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providers/workListProvider.dart';
import '../model/WorkList_model.dart';
import 'EditWork.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Work_List  extends ConsumerStatefulWidget {
 const Work_List ({Key? key,}) : super(key: key);
  @override
  _Work_ListState createState() => _Work_ListState();
}
class _Work_ListState extends ConsumerState<Work_List> {

  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
  String usertype='',thispage="worklist";

  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
    print(usertype);
  }

  @override
  void initState() {
    super.initState();
    _checkOfficer();
  }

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(workListDataProvider);
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[800],
            title:const Text('Work Record',style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
              if( usertype == "emp".toString())
              {
                print("Login as employee");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              }
              else
              {
                print("Login as reporting officer");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);

              }
            },),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/filter', (r) => false);
              }, icon: const Icon(Icons.filter_alt_sharp,color: Colors.orange,))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async=> await ref.refresh(workListDataProvider),
            child: _data.when(
              data: (_data){
                List<EmpWorkClass> workList = _data.map((e) => e).toList();
                if(workList.isEmpty)
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
                      itemCount: workList.length, itemBuilder: (_, index) {
                    return Card(
                      color: Colors.indigo.shade200,
                      child: ListTile(
                        title: Column(
                          children: [
                            const SizedBox(height: 10,),
                            TextFormField(
                              enabled: false,
                              initialValue: workList[index].workDetail.replaceAll('&nbsp;', '').replaceAll(exp, ''),style: TextStyle(fontFamily: 'DancingScript',fontSize: 20,color: Colors.black),
                              //controller: showMsg,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:const BorderSide(width: 1.5)
                                  ),
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                              maxLines: 5,
                            ),

                            Row(
                              children: [

                                const Text("Date:",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15),),

                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text(" ${workList[index].reportDate.day}/${workList[index].reportDate.month}/${workList[index].reportDate.year}",
                                  style:const TextStyle(fontWeight: FontWeight.w400,color: Colors.indigo,
                                  fontSize: 15,),),
                                ),

                                const SizedBox(width: 30,),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if( workList[index].reportDate.isAfter(DateTime.now().subtract(Duration(days: 7))) &&
                                          workList[index].reportDate.isBefore(DateTime.now()))
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                (context) => EditWork(workList[index].workReportId,
                                                workList[index].workDetail,workList[index].reportDate,thispage)), (route) => false);
                                          },
                                          child: Card(
                                            elevation: 5,
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              color: Colors.green,
                                              child: Row(
                                                children: [
                                                  const Padding(padding: EdgeInsets.only(left: 8.0),child: Text("Edit"),),
                                                 const Icon(Icons.edit,color: Colors.black,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => EditWork(workList[index].workReportId, workList[index].workDetail,workList[index].reportDate,thispage)), (route) => false);
                                          },
                                          child: Card(
                                            elevation: 5,
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              color: Colors.red,
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding:  EdgeInsets.only(left: 8.0),
                                                    child: Text("View"),
                                                  ),
                                                  Icon(Icons.not_interested,color: Colors.black,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    );

                  }
                );
                }
           },
                error: (err, s) => Text(""),
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
        if( usertype == "emp".toString())
        {
          print("Login as employee");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        }
        else
        {
          print("Login as reporting officer");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
        }
        return Future.value(true);
      },
    );
  }

}

