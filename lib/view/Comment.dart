import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Connectivity/ConnectivitystatusNotifier.dart';

class Comment extends StatefulWidget{
var wEmpI,work,time,FilterStatus,workReportId;
 Comment(this.wEmpI,this.work,this.time,this.FilterStatus,this.workReportId);
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  HtmlEditorController controllerEmp = HtmlEditorController();
  HtmlEditorController controllerRep = HtmlEditorController();
  final _formKey = GlobalKey<FormState>();
  int emp_id=0;
  String txtEmp ="",txtRep="";


  _displayCommentReport()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    txtRep = prefs.getString('txtRep')==null?"":prefs.getString('txtRep')!;
     print("Saved Comment"+txtRep);
  }
  _comment() async{
    try{
      txtRep = await controllerRep.getText();
      if(txtRep.isEmpty)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill details first')),
        );
      }
      else
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('txtRep', 'txtRep');
          emp_id= prefs.getInt('emp_id')==null ? 0 : prefs.getInt('emp_id')!;
          var response = await http.post(Uri.parse("${AppConstant.BASE_URL}reply_work.php"),
              body:{
                "ms_by_id":emp_id.toString(),
                "ms_to_id":widget.wEmpI,
                "message":txtRep,
                "work_id":widget.workReportId
              });
          var message = jsonDecode(response.body);
          print(response);
          print(message);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" ${message['message'].toString()}")),);
          print("$message");
          print("Employee Id "+emp_id.toString());
          print("ms_to_id "+widget.wEmpI);
          print("message"+txtRep);
          print("workid"+widget.workReportId);
        }

    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _displayCommentReport();
    txtEmp = widget.work;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title:const Text("Reply Work Report"),
          backgroundColor: Colors.green[800],
          leading: IconButton(onPressed: (){
            if(widget.FilterStatus==1)
              {
                Navigator.pushNamedAndRemoveUntil(context, '/filterdeptwork', (route) => false);

              }
            else
              {
                Navigator.pushNamedAndRemoveUntil(context, '/deptreport', (route) => false);

              }
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding:const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  SizedBox(
                    child: Container(
                      child: Text("${widget.time.day}/${widget.time.month}/${widget.time.year}",
                        style:const TextStyle(fontSize: 20),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Form(
                     key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const  Text("Employee Work Details"),
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              HtmlEditor(
                                controller: controllerEmp, //required
                                htmlEditorOptions: HtmlEditorOptions(
                                  initialText: txtEmp,
                                  disabled: true,
                                  darkMode: true,
                                  hint: "Your text here...",
                                  //initalText: "text content initial, if any",
                                ),
                                otherOptions: OtherOptions(
                                ),
                              )
                            ],
                          ),
                        ),
                        const  SizedBox( height: 20,),
                        const Text("Replying to Employee by Officer"),
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              HtmlEditor(
                                controller: controllerRep, //required
                                htmlEditorOptions: HtmlEditorOptions(
                                  initialText: txtRep,
                                  spellCheck: true,
                                  darkMode: true,
                                  //initalText: "text content initial, if any",
                                ),
                                otherOptions: OtherOptions(
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const  SizedBox( height: 20,),
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: (){
                        final isValid = _formKey.currentState!
                            .validate();
                        if (!isValid) {
                          return;
                        }
                        else {
                          _comment();
                        }
                      }, child:const Text("POST"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green[800],
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
        if(widget.FilterStatus==1)
        {
          Navigator.pushNamedAndRemoveUntil(context, '/filterdeptwork', (route) => false);

        }
        else
        {
          Navigator.pushNamedAndRemoveUntil(context, '/deptreport', (route) => false);

        }
        return Future.value(true);
      },
    );
  }
}
