import 'package:emp_report/view/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../Providers/TeamWorkProvider.dart';
import '../model/TeamWork_model.dart';

class DepartmentWork  extends ConsumerStatefulWidget {
  const DepartmentWork ({Key? key, }) : super(key: key);
  @override
  _DepartmentWorkState createState() => _DepartmentWorkState();
}

class _DepartmentWorkState extends ConsumerState<DepartmentWork> {

  String description = "Remarks"; int emp_id=0;
  int FilterStatus=0;
  TextEditingController controller = TextEditingController();
  bool showEmpty = false, filterOnOff = false, isPageLoad = false;
  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
  int startLimit = 0, endLimit = 10;
  TextEditingController searchController = TextEditingController();
  TextEditingController remark = TextEditingController();
  ScrollController pageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(teamworkListDataProvider);
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title:const Text("DEPARTMENT WORK LIST",style: TextStyle(fontFamily: 'Alice',fontSize: 20),),
            leading: IconButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
              },
              icon:const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/filterdeptwork', (r) => false);
                }, icon:const Icon(Icons.filter_alt_sharp,color: Colors.orange,))
            ],
            backgroundColor: Colors.green[800],
          ),
          body:RefreshIndicator(
            onRefresh: () async=> await ref.refresh(teamworkListDataProvider),
            child: _data.when(
                data: (_data){
                  List<TeamWorkClass> _teamwrklst = _data.map((e) => e).toList();

                  if(_teamwrklst.isEmpty)
                  {
                    return Center(
                      child: Container(
                        child:const Text("NO RECORD FOUND"),
                      ),
                    );
                  }
                  else{
                    return ListView.builder(
                        itemCount: _teamwrklst.length,
                        itemBuilder: (_, index)
                        {
                          return Card(
                            color: Colors.orange.shade50,
                            child: ListTile(
                              title: Column(
                                children: [
                                  const  SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text("SERIAL NO.: ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${index+1}",
                                          style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                              fontSize: 15),
                                          //overflow: TextOverflow.ellipsis,
                                          //maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("EMPLOYEE NAME: ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${_teamwrklst[index].empName}",
                                          style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                              fontSize: 15),
                                          //overflow: TextOverflow.ellipsis,
                                          //maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("DESIGNATION: ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${_teamwrklst[index].desgName}",
                                          style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                              fontSize: 15),
                                          //overflow: TextOverflow.ellipsis,
                                          //maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("DATE : ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Text(" ${_teamwrklst[index].reportDate.day}/${_teamwrklst[index].reportDate.month}/${_teamwrklst[index].reportDate.year}",
                                        style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                          fontSize: 15,),),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("WORK DETAIL: ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${_teamwrklst[index].workDetail.replaceAll(exp, '').replaceAll('&nbsp;', '')}",
                                          style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("COMMENT: ",
                                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${_teamwrklst[index].message.replaceAll(exp, '').replaceAll('&nbsp;', '')==null?"":_teamwrklst[index].message.replaceAll(exp, '').replaceAll('&nbsp;', '').toString()}",
                                          style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Column(
                                    children: [
                                      if (_teamwrklst[index].message.isEmpty) ...[
                                        Row(
                                          children: [
                                            const  Text("ADD COMMENT: ",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            const  SizedBox(width: 10,),
                                            IconButton(onPressed: (){
                                              Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                  (context) => Comment(_teamwrklst[index].empId,_teamwrklst[index].workDetail,_teamwrklst[index].reportDate,FilterStatus,
                                                  _teamwrklst[index].workReportId)), (route) => false);
                                            }, icon: Icon(Icons.comment)),
                                          ],
                                        ),
                                      ]  else ...[

                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
        Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
        return Future.value(true);
      },
    );
  }
}

