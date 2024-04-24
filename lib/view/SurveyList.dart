import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../CSV/EmployeeSurveyListCSV.dart';
import '../PDF/surveylistPdf.dart';
import '../Providers/SurveyListProvider.dart';
import '../model/SurveyList_model.dart';
import 'package:http/http.dart' as http;
import '../utils/constant.dart';

class SurveyList extends ConsumerStatefulWidget {
  const SurveyList({Key? key}) : super(key: key);

  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends ConsumerState<SurveyList> {
   int emp_id=0;
   String emp_name="";
   Timer? _timer;
   late double _progress;
   List<SurveyClass>  _svl=[];
   _getworkList() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
     emp_name= prefs.getString('emp_name')==null ? "":prefs.getString('emp_name')!;
     try{
       var response = await http.post(Uri.parse("${AppConstant.BASE_URL}marketingserveylist.php"),
           body:{
             "emp_id":emp_id.toString(),
           });
       print(response.body);
       var data = SurveyListResponse.fromJson(json.decode(response.body));
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" ${data.message.toString()}",style: TextStyle(
           fontSize: 15,fontWeight: FontWeight.bold
       ),),),);
       print("emp_id $emp_id");
       setState(() {
         _svl = data.user!;
       });
     }
     catch(e)
     {
       print(e);
     }
   }

  _getname() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    emp_name= prefs.getString('emp_name')==null ? "":prefs.getString('emp_name')!;
  }

  @override
  void initState() {
    _getname();
    _getworkList();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(surveyListDataProvider);
    return WillPopScope(
      child: Scaffold(
        //backgroundColor: Colors.white70,
        appBar: AppBar(
          title:const Text("Survey List"),
          backgroundColor: Colors.green[800],
          leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed: (){
               Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async=> await ref.refresh(surveyListDataProvider),
          child: _data.when(
            data: (_data){
              List<SurveyClass> _slt = _data.map((e) => e).toList();
              if(_slt.isEmpty)
              {
                return Center(
                  child: Container(
                    child:const Text("NO RECORD FOUND"),
                  ),
                );
              }
              else
              {
                return ListView.builder(
                  itemCount: _slt.length,
                  itemBuilder: (_, index)
                  {
                    return Card(
                      color: Colors.orange.shade50,
                      child: ListTile(
                        title: Column(
                          children: [
                            const Padding(padding:EdgeInsets.only(top: 10)),
                            Row(
                              children: [
                               const Text("Client Name : ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                Text(" ${_slt[index].clientName}",
                                  style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                    fontSize: 15, ),),
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Mobile No. : ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                Text("${_slt[index].clientMobile}",
                                  style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                    fontSize: 15, ),
                                  //overflow: TextOverflow.ellipsis,
                                  //maxLines: 1,
                                ),
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Address : ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                Expanded(
                                  child: Text("${_slt[index].wname},${_slt[index].pname},"
                                      "${_slt[index].asname},${_slt[index].dname},${_slt[index].sname}",
                                    style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                      fontSize: 15, ),
                                    //overflow: TextOverflow.ellipsis,
                                    //maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Know about Rasaya? ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                if("${_slt[index].knowRasaya}"=="0")
                                  const Text("NO",
                                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                        fontSize: 15 ),
                                  )
                                else
                                  const Text("YES",
                                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                        fontSize: 15 ),
                                  )
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Rasaya App installed: ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                if("${_slt[index].isApp}"=="0")
                                  const Text("NO",
                                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                      fontSize: 15, ),
                                  )
                                else
                                  const Text("YES",
                                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                      fontSize: 15, ),
                                  ),
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Description : ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                Expanded(
                                  child: Text("${_slt[index].description}",
                                    style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                      fontSize: 15, ),
                                    //overflow: TextOverflow.ellipsis,
                                    //maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.black,),
                            Row(
                              children: [
                                const Text("Visit Image : ",
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                Container(
                                    height: 100,
                                    width: 100,
                                    alignment: Alignment.center,
                                    child:ClipRRect(
                                      borderRadius:BorderRadius.circular(10),
                                      child: Image.network("https://reporting.rasayamultiwings.com/api/${_slt[index].image1}"),
                                    )
                                ),
                                IconButton(onPressed: ()async{
                                  await launch("https://reporting.rasayamultiwings.com/api/${_slt[index].image1}");
                                }, icon:const Icon(Icons.download))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 Text("Survey Date:${_svl[index].createdAt}",style:const TextStyle(color: Colors.grey,fontSize: 15),)
                              ],
                            ),
                            const Padding(padding:EdgeInsets.only(top: 10)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
            child: CircularProgressIndicator(),
            ),
          ),
        ),
        floatingActionButton:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(_svl.isNotEmpty)
              ...[
                FloatingActionButton(
                  onPressed: () {
                    printSurveyList(_svl,emp_name);
                    //printAllDoc(prodlist,_showInn);
                  },
                  child:const Text("PDF"),
                  heroTag:const Text("SPDF"),
                ),
                const SizedBox(height: 15,),
                FloatingActionButton(
                  onPressed: () {
                    generateEmpSurveyCsv(_svl,emp_name);
                    _progress = 0;
                    _timer?.cancel();
                    _timer = Timer.periodic(const Duration(milliseconds: 100),
                            (Timer timer) {
                          EasyLoading.showProgress(_progress,
                              status: '${(_progress * 100).toStringAsFixed(0)}%');
                          _progress += 0.03;
                          if (_progress >= 1) {
                            _timer?.cancel();
                            EasyLoading.showSuccess("Downloaded check your download");
                            EasyLoading.dismiss();
                          }
                        });
                  },
                  child:const Text("CSV"),
                  heroTag:const Text("SCSV"),
                ),
              ]
            else
              ...[const Text("")]
          ],
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
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return Future.value(false);
      },
    );
  }
}
