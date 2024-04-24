import 'dart:async';
import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:emp_report/view/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../CSV/TeamWorkCSV.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../PDF/FilterTeamWorkPdf.dart';
import '../model/TeamWork_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FilterDepartmentWork extends StatefulWidget {
  const FilterDepartmentWork({Key? key}) : super(key: key);

  @override
  State<FilterDepartmentWork> createState() => _FilterDepartmentWorkState();
}

class _FilterDepartmentWorkState extends State<FilterDepartmentWork> {
  List<TeamWorkClass> _filterworkList = [];
  TextEditingController _dateInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int FilterStatus=1;
  Timer? _timer;
  late double _progress;
  @override
  bool ispageload= false,_listVisible=true;
  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
   int emp_id=0;

  _getOneDayList() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
      EasyLoading.show(status: 'loading...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}teamworklist.php"),
          body:{
            "emp_id":emp_id.toString(),
            "cdate":_dateInput.text.toString(),
          });
      var mess = jsonDecode(response.body);
      var message = TeamResponse.fromJson(json.decode(response.body));
      EasyLoading.showToast("${mess['message']}",toastPosition:EasyLoadingToastPosition.bottom );
      EasyLoading.dismiss();
      setState(() {
        _filterworkList = message.user;

      });
      print("Employee Id "+emp_id.toString());
      print("cdate "+_dateInput.text.toString());
      print("$mess");
    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("FILTERED DATA "),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/deptreport', (route) => false);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:const EdgeInsets.all(15),
                    child: Form(
                       key: _formKey,
                       child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Please pick a date";
                                },
                                controller: _dateInput,
                                style:const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration:const InputDecoration(
                                    icon: Icon(Icons.calendar_today,color: Colors.red,),
                                    labelText: "-select date-",
                                    labelStyle: TextStyle(color: Colors.green,
                                        fontFamily: 'Alkalami')
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate:DateTime(2022),
                                    lastDate: DateTime(2035),
                                  );
                                  if (pickedDate != null) {
                                    print(
                                        pickedDate);
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                    print(
                                        formattedDate);
                                    setState(() {
                                      _dateInput.text = formattedDate;
                                    });
                                  } else {}
                                }


                                ),
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(onPressed: (){
                              if(_formKey.currentState!.validate())
                              {
                                _getOneDayList();
                              }
                              setState(() {

                              });
                            }, child:const Text("GET LIST"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[800], // background
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _listVisible,
                    child: Container(
                      padding:const EdgeInsets.all(5),
                      child: ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _filterworkList.length,
                        itemBuilder: (context, index)
                        {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color: Colors.orange.shade50,
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const  Divider(
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
                                              child: Text("${_filterworkList[index].empName}",
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
                                              child: Text("${_filterworkList[index].desgName}",
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
                                            Text(" ${_filterworkList[index].reportDate.day}/${_filterworkList[index].reportDate.month}/${_filterworkList[index].reportDate.year}",
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
                                              child: Text("${_filterworkList[index].workDetail.replaceAll(exp, '').replaceAll('&nbsp;', '')}",
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
                                              child: Text("${_filterworkList[index].message.replaceAll(exp, '').replaceAll('&nbsp;', '')==null?"":_filterworkList[index].message.replaceAll(exp, '').replaceAll('&nbsp;', '').toString()}",
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
                                            if (_filterworkList[index].message.isEmpty) ...[
                                              Row(
                                                children: [
                                                  const  Text("ADD COMMENT: ",
                                                    style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                                  SizedBox(width: 10,),
                                                  IconButton(onPressed: (){
                                                    Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                        (context) => Comment(_filterworkList[index].empId,_filterworkList[index].workDetail,_filterworkList[index].reportDate,FilterStatus,
                                                        _filterworkList[index].workReportId)), (route) => false);
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
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(_filterworkList.isNotEmpty)
              ...[
                FloatingActionButton(
                  onPressed: () {
                    printTeamWork(_filterworkList,_dateInput.text );
                  },
                  child:const Text("PDF"),
                  heroTag:const Text("workpdf"),
                ),
                const SizedBox(height: 15,),
                FloatingActionButton(
                  onPressed: () {
                    teamWorkCsv(_filterworkList,_dateInput.text);
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
                  heroTag:const Text("workcsv"),
                ),
              ]
            else
              ...[
                const Text("")
              ]
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
            /*Container(
            color: Colors.red.shade500,
            child:const Text("Oops! you are offline :(",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black45),textAlign: TextAlign.center,),
          );*/
          },
        ),
      ),
      onWillPop: (){
        Navigator.pushNamedAndRemoveUntil(context, '/deptreport', (route) => false);
        return Future.value(false);
      },
    );
  }
}
