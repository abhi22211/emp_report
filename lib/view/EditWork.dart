import 'dart:async';
import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Connectivity/ConnectivitystatusNotifier.dart';

class EditWork extends ConsumerStatefulWidget {
  var _work_id;
  String work_detail,thispage;
  DateTime _reportDate;

  EditWork(this._work_id,this.work_detail,this._reportDate,this.thispage);

  @override
  _EditWorkState createState() => _EditWorkState();
}

class _EditWorkState extends ConsumerState<EditWork> {

  @override
  HtmlEditorController controllerEdit = HtmlEditorController();
  TextEditingController dateInput = TextEditingController();
  int emp_id=0,work_report_id=0;
  String txtEmp ="";
  String usertype='';
  Timer? _timer;

  //RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
  final _formKey = GlobalKey<FormState>();

  _workStatus() async{
    try{
      String txt = await controllerEdit.getText();
      if(txt.isEmpty)
      {
        EasyLoading.showToast("Please fill details first",toastPosition:EasyLoadingToastPosition.bottom );
        EasyLoading.dismiss();
      }
      else
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
          EasyLoading.show(status: 'saving...');
          var response = await http.post(Uri.parse("${AppConstant.BASE_URL}add_reporting.php"),
          body:{
                "emp_id":emp_id.toString(),
                "report_date":widget._reportDate.toString(),
                "work_detail":txt,
                "work_report_id":widget._work_id.toString(),
              });
          print("This is $work_report_id");
          var message = jsonDecode(response.body);
          EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.bottom );
          EasyLoading.dismiss();
          print(response.body);
          print("Employee Id "+emp_id.toString());
          print("Date "+widget._reportDate.toString(),);
          print("Work Detail"+txt);
          print("work_report_id"+ widget._work_id.toString());
          print(widget._reportDate);
        }
    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    widget._reportDate;
    txtEmp = widget.work_detail;
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
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title:const Text("EDIT WORK"),
          leading: IconButton(
            onPressed: (){

              if( widget.thispage == "worklist".toString())
              {
                print(widget.thispage);
                Navigator.pushNamedAndRemoveUntil(context, '/worklist', (r) => false);
              }
              else
              {
                print(widget.thispage);
                Navigator.pushNamedAndRemoveUntil(context, '/filter', (r) => false);
              }

            },
            icon:const Icon(
              Icons.arrow_back
            ),
          ),
          backgroundColor: Colors.green[800],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  SizedBox(
                    child: Container(
                      child: Text("${widget._reportDate.day}/${widget._reportDate.month}/${widget._reportDate.year}",
                      style:const TextStyle(fontSize: 20),),
                    ),
                  ),
                  const  SizedBox(height: 20,),
                  Form(
                    key: _formKey,
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
                                controller: controllerEdit, //required
                                htmlEditorOptions: HtmlEditorOptions(
                                  spellCheck: true,
                                  initialText: txtEmp,
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
                  const  SizedBox(height: 20,),
                  Container(
                    child: Column(
                      children: [
                        if( widget._reportDate.isAfter(DateTime.now().subtract(Duration(days: 7))) &&
                            widget._reportDate.isBefore(DateTime.now()))
                            SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(onPressed:(){
                              final isValid = _formKey.currentState!
                                  .validate();
                              if (!isValid) {
                                return;
                              }
                              else {
                                _workStatus();
                                /*if( widget.thispage == "worklist".toString())
                                {
                                  _workStatus();
                                  print(widget.thispage);
                                  Navigator.pushNamedAndRemoveUntil(context, '/worklist', (r) => false);
                                }
                                else
                                {
                                  _workStatus();
                                  print(widget.thispage);
                                  Navigator.pushNamedAndRemoveUntil(context, '/filter', (r) => false);
                                }*/
                              }
                            },child:const Text("SAVE CHANGES"),
                              style: ElevatedButton.styleFrom(
                              primary: Colors.green[800], // background
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(onPressed:()
                            { },
                              child:const Text("NOT EDITABLE"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red[800], // background
                              ),
                            ),
                          )
                      ],
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
          },
        ),
      ),
      onWillPop: (){
        if( widget.thispage == "worklist".toString())
        {
          print(widget.thispage);
          Navigator.pushNamedAndRemoveUntil(context, '/worklist', (r) => false);
        }
        else
        {
          print(widget.thispage);
          Navigator.pushNamedAndRemoveUntil(context, '/filter', (r) => false);
        }
        return Future.value(false);
      },
    );
  }
}
