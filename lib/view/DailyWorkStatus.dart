import 'dart:async';
import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../Connectivity/ConnectivitystatusNotifier.dart';

class DailyWorkStatus extends StatefulWidget {
  const DailyWorkStatus({Key? key}) : super(key: key);
  @override
  State<DailyWorkStatus> createState() => _DailyWorkStatusState();
}

class _DailyWorkStatusState extends State<DailyWorkStatus> {

  TextEditingController dateInput = TextEditingController();
  String description = "";
  Timer? _timer;
  HtmlEditorController controllerEmp = HtmlEditorController();
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  int emp_id=0, _work_id=0;
  String work_detail='',add_date='',usertype='';
  final _formKey = GlobalKey<FormState>();

  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
  }

  _workStatus() async{
    try{
      String txtEmp = await controllerEmp.getText();
      if(txtEmp.isEmpty)
      {
        EasyLoading.showToast("Please fill details first",toastPosition:EasyLoadingToastPosition.bottom );
        EasyLoading.dismiss();
      }
      else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
        EasyLoading.show(status: 'saving...');
        var response = await http.post(Uri.parse("${AppConstant.BASE_URL}add_reporting.php"),
            body:{
              "emp_id":emp_id.toString(),
              "report_date":dateInput.text.toString(),
              "work_detail":txtEmp,
            });
        var message = jsonDecode(response.body);
        print(response);
        print(message);
        print(emp_id.toString());
        print(dateInput.text.toString());
        print(txtEmp);
        EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.bottom );
        EasyLoading.dismiss();
        print("$message");
        print("Employee Id "+emp_id.toString());
        print("Date "+dateInput.text.toString());
        print("Work Detail"+txtEmp);
        print("work id $_work_id");
      }

    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    dateInput.text= cdate;
    _checkOfficer();
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
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title:const Text("DAILY TASK REPORT",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed: (){
              if( usertype == "emp".toString())
              {
                print("Login as employee");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Home')),
                );
              }
              else
              {
                print("Login as reporting officer");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Home')),
                );
              }
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding:const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  SizedBox(height: 20,),
                  SizedBox(
                    width: 150,
                    child: Container(
                      child: TextField(
                        controller: dateInput,
                          style:const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        decoration:const InputDecoration(
                            icon: Icon(Icons.calendar_today,color: Colors.red,),
                            labelText: "Date",
                          labelStyle: TextStyle(color: Colors.green,
                              fontFamily: 'Alkalami')
                           ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:DateTime.now().subtract(const Duration(days: 7)),
                                lastDate: DateTime.now(),
                                );
                            if(pickedDate != null) {
                              print(
                                  pickedDate);
                              String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate);
                              setState(() {
                                dateInput.text = formattedDate;
                              });
                            } else {}
                          }
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("DESCRIBE YOUR TODAY'S WORK ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,
                  fontFamily: 'Alkalami'),),
                  Form(
                    //padding: const EdgeInsets.symmetric(vertical: 10),
                    key:_formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              HtmlEditor(
                                controller: controllerEmp, //required
                                htmlEditorOptions:const HtmlEditorOptions(
                                  spellCheck: true,
                                  darkMode: true,
                                  hint: "Your text here...",
                                  //initalText: "text content initial, if any",
                                ),
                                otherOptions:const OtherOptions(
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(onPressed: (){
                      final isValid = _formKey.currentState!
                          .validate();
                      if (!isValid) {
                        return;
                      }
                      else {
                        _workStatus();
                      }
                    }, child:const Text("SAVE WORK"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[800], // background
                      ),
                    ),
                  ),
                ],
              ),
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
            /*Container(
            color: Colors.red.shade500,
            child:const Text("Oops! you are offline :(",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black45),textAlign: TextAlign.center,),
          );*/
          },
        ),
      ),
      onWillPop: (){
        if( usertype == "emp".toString())
        {
          print("Login as employee");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Home')),
          );
        }
        else
        {
          print("Login as reporting officer");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Home')),
          );
        }
        return Future.value(false);
      },
    );
  }
}


