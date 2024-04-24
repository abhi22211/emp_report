import 'dart:async';
import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../CSV/OfficerSurveyListCSV.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../PDF/OfficerSurveyListPdf.dart';
import '../model/OfficersViewSL_model.dart';


class OfficersViewSL extends ConsumerStatefulWidget {
  var emp_id,emp_name;
  OfficersViewSL(this.emp_id,this.emp_name);

  @override
  _Filter_ListState createState() => _Filter_ListState();
}

class _Filter_ListState extends ConsumerState<OfficersViewSL> {
  Timer? _timer;
  late double _progress;

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

  @override
  bool _listVisible=true;
  List<OfficersviewSLclass> suvList=[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController from_date = TextEditingController();
  TextEditingController to_date = TextEditingController();
  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);

  _viewOfficerSurveyList() async{
    try{
      EasyLoading.show(status: 'loading...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}reportingoffsurveylist.php"),
          body:{
            "emp_id":widget.emp_id,
            "from_date":from_date.text.toString(),
            "to_date":to_date.text.toString(),
          });
      var mess = jsonDecode(response.body);
      var message = OfficersViewSurveyListResponse.fromJson(json.decode(response.body));
      EasyLoading.showToast("${mess['message']}",toastPosition:EasyLoadingToastPosition.bottom );
      EasyLoading.dismiss();
      setState(() {
        suvList = message.user;
      });
      print("Employee Id "+widget.emp_id);
      print("from_month "+from_date.text.toString());
      print("from_year"+to_date.text.toString());
      print("$mess");
    }
    catch(e)
    {
      print(e);
    }
  }


  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("SURVEY DATA",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/ourteam', (route) => false);
            },
          ),
        ),
        body:  SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  SizedBox(
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
                                controller: from_date,
                                style:const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration:const InputDecoration(
                                    icon: Icon(Icons.calendar_today,color: Colors.red,),
                                    labelText: "-select first date-",
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
                                      from_date.text = formattedDate;
                                    });
                                  } else {}
                                }
                            ),
                          ),
                          Container(
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Please pick last date";
                                },
                                controller: to_date,
                                style:const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration:const InputDecoration(
                                    icon: Icon(Icons.calendar_today,color: Colors.red,),
                                    labelText: "-select last date-",
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
                                      to_date.text = formattedDate;
                                    });
                                  } else {}
                                }
                            ),
                          ),
                          const  SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(onPressed: (){
                              if(_formKey.currentState!.validate())
                              {
                                _viewOfficerSurveyList();
                              }
                            }, child:const Text("GET LIST"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[800], // background
                              ),
                            ),
                          ),
                          const  SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _listVisible,
                    child: Container(
                      padding:const EdgeInsets.all(5),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: suvList.length,
                        itemBuilder: (context, index)
                        {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color: Colors.orange.shade50,
                                  child:  ListTile(
                                    title: Column(
                                      children: [
                                        Padding(padding:EdgeInsets.only(top: 10)),

                                        Row(
                                          children: [
                                            const  Text("Client Name : ",
                                            style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            Text(" ${suvList[index].clientName}",
                                            style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                            fontSize: 15, ),),
                                          ],
                                        ),
                                        const  Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            const  Text("Mobile No. : ",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            Text("${suvList[index].clientMobile}",
                                              style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                                fontSize: 15, ),
                                              //overflow: TextOverflow.ellipsis,
                                              //maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        const  Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            const  Text("Address : ",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            Expanded(
                                              child: Text("${suvList[index].wname},${suvList[index].pname},"
                                                  "${suvList[index].asname},${suvList[index].dname},${suvList[index].sname}",
                                                style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                                  fontSize: 15, ),
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
                                            const  Text("Know about Rasaya? ",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            if("${suvList[index].knowRasaya}"=="0")
                                              const  Text("NO",
                                                style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                                    fontSize: 15 ),
                                              )
                                            else
                                              const  Text("YES",
                                                style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                                    fontSize: 15 ),
                                              )
                                          ],
                                        ),
                                        const  Divider(
                                          color: Colors.black,
                                        ),
                                        Row(
                                          children: [
                                            const  Text("Rasaya App installed: ",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            if("${suvList[index].isApp}"=="0")
                                              const  Text("NO",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                              fontSize: 15, ),
                                              )
                                            else
                                              const  Text("YES",
                                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                              fontSize: 15, ),
                                              ),
                                          ],
                                        ),
                                        const  Divider(
                                          color: Colors.black,
                                        ),
                                            Row(
                                            children: [
                                              const  Text("Description : ",
                                            style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15),),
                                            Expanded(
                                            child: Text("${suvList[index].description}",
                                            style:const TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo,
                                            fontSize: 15, ),
                                                //overflow: TextOverflow.ellipsis,
                                                //maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const   Divider(color: Colors.black,),
                                        const  Padding(padding:EdgeInsets.only(top: 10)),
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
          children:[
            if(suvList.isNotEmpty)
          ...[
            FloatingActionButton(
              onPressed: () {
                //generateCsvFile(suvList,widget.emp_name,from_date.text,to_date.text);
                printSurveyListOff(suvList,widget.emp_name,from_date.text,to_date.text);
              },
              child: Text("PDF"),
              heroTag: Text("pdf"),
            ),
            SizedBox(height: 15,),
            FloatingActionButton(
              onPressed: () {
                generateCsvFile(suvList,widget.emp_name,from_date.text,to_date.text);
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
              child: Text("CSV"),
              heroTag: Text("csv"),
            )
          ]
            else
              ...[
                Text(""),
              ]
          ] ,
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
        Navigator.pushNamedAndRemoveUntil(context, '/ourteam', (route) => false);
        return Future.value(false);
      },
    );
  }
}

