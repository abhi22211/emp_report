import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Emp_Login extends StatefulWidget{
  @override
  State<Emp_Login> createState() => _Emp_LoginState();
}

class _Emp_LoginState extends State<Emp_Login> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  var _myformkey = GlobalKey<FormState>();
  bool _passwordVisible =false;
  bool visible = false;
  Timer? _timer;
  String? _password,_user;
  String selectedText = "emp",reporting_officer="";

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("REPORTING OFFICER"),value: "rp"),
      const  DropdownMenuItem(child: Text("EMPLOYEE"),value: "emp"),
    ];
    return menuItems;
  }

  Future _empLogin() async{
    _password = passwordController.text;
    _user = userController.text;
    var url = '${AppConstant.BASE_URL}emp_login.php';
    var data = {'username': _user, 'password' : _password, 'usertype':selectedText};
    print('url ${url}');
    try{
      EasyLoading.show(status: 'loading...');
      var response = await http.post(Uri.parse(url), body: data);
      print("response ${response}");
      var message = jsonDecode(response.body);
      print("$message");
      EasyLoading.dismiss();
      if( message['error'] == 200.toString())
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('emp_id', int.parse(message['userdata']['emp_id']) );
        await prefs.setString('emp_name', message['userdata']['emp_name'].toString());
        await prefs.setString('emp_email', message['userdata']['emp_email'].toString());
        await prefs.setString('emp_code', message['userdata']['emp_code'].toString());
        await prefs.setString('doj', message['userdata']['doj'].toString());
        await prefs.setString('emp_phone', message['userdata']['emp_phone'].toString());
        await prefs.setString('emp_adress', message['userdata']['emp_adress'].toString());
        await prefs.setString('emp_pass', message['userdata']['emp_pass'].toString());
        await prefs.setString('uesr_type', message['userdata']['uesr_type'].toString());
        await prefs.setString('desg_name', message['userdata']['desg_name'].toString());
        await prefs.setString('dept_id', message['userdata']['dept_id'].toString());
        await prefs.setString('create_date', message['userdata']['create_date'].toString());
        await prefs.setString('rep_offer_id', message['userdata']['rep_offer_id'].toString());
        await prefs.setString('usertype', message['userdata']['usertype'].toString());
        await prefs.setString('depart_name', message['userdata']['depart_name'].toString());
        await prefs.setString('reporting_officer', message['userdata']['reporting_officer'].toString());
        await prefs.setString('workloaction', message['userdata']['workloaction'].toString());
        await prefs.setString('profileimg', message['userdata']['profileimg'].toString());
        if( selectedText == "emp".toString())
          {
            print("Login as employee");
            Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            print("This is reporting officer name $reporting_officer");
            /*ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );*/
          }
        else
          {
            print("Login as reporting officer");
            Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')),
            );
          }

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid employee code/ mobile number or password')),
        );
      }
    }
    on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Internet connection')),
      );
    }
    on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('connection timeout')),
      );
    }
    on Error catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("unknown ${e.toString()}")),
      );
    }
  }

  @override
  void initState()
  {
    _passwordVisible=false;
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Padding(padding:const EdgeInsets.only(top: 150)),
              Container(
                height: 100,
                width: 100,
                decoration:const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/rasaya.png'),
                  ),
                ),
              ),
               Container(
                child:const Text("RASAYA Employee Reporting System",style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 21,fontFamily: 'Alice'),),
              ),
              Padding(padding:const EdgeInsets.only(top: 10)),
              Container(
                alignment:Alignment.bottomCenter ,
                color: Colors.white,
                child: Column(
                  children: [
                   Form(
                     key:_myformkey,
                       child:Container(
                         color: Colors.yellow[400],
                         padding: EdgeInsets.all(10),
                         child: Column(
                           children: [
                             InputDecorator(
                               child: DropdownButtonFormField(
                                 hint:const Text("---select---"),
                                 items: dropdownItems,
                                 onChanged:(String? newValue){
                                 setState(() {
                                   selectedText = newValue!;
                                 });
                               },
                                 validator: (value) => value == null
                                     ? '*required' : null,
                               ),
                               decoration:const InputDecoration(
                                 border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(15))),
                                 contentPadding: EdgeInsets.all(10),
                               ),
                             ),
                             Padding(padding:const EdgeInsets.only(top: 20.0)),
                             TextFormField(
                               controller: userController,
                               decoration: InputDecoration(
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 filled: true,
                                 fillColor: Colors.black12,
                                 label:const Text('Employee Code/ Mobile Number'),
                                 labelStyle:const TextStyle(
                                    // color: AppColors.lightAccent,
                                     fontWeight: FontWeight.w500),
                                 suffixIcon:const Icon(
                                   Icons.person_outline_rounded,
                                 ),
                               ),
                               style:const TextStyle(fontWeight: FontWeight.w500),
                               validator: (String? value) {
                                 if (value!.isEmpty) {
                                   return "required";
                                 }
                                 return null;
                               },
                             ),
                             const  Padding(padding: EdgeInsets.only(top: 10)),
                             TextFormField(
                               obscureText: !_passwordVisible,
                               decoration: InputDecoration(
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30.0),
                                   borderSide:const BorderSide(
                                     width: 1.5,),
                                 ),
                                 label:const Text('Password'),
                                 labelStyle:const TextStyle(
                                     fontWeight: FontWeight.w500),
                                 suffixIcon: IconButton(
                                   icon: Icon(
                                     _passwordVisible
                                         ? Icons.visibility
                                         : Icons.visibility_off,
                                   ),
                                   onPressed: () {
                                     setState(() {
                                       _passwordVisible = !_passwordVisible;
                                     });
                                   },
                                 ),
                                 filled: true,
                                 fillColor: Colors.black12,
                               ),
                               controller: passwordController,
                               style:const TextStyle(fontWeight: FontWeight.w500),
                               validator: (String? value) {
                                 if (value!.isEmpty) {
                                   return "required";
                                 }
                                 return null;
                               },
                             ),
                             const  Padding(padding: EdgeInsets.only(top: 10)),
                             Container(
                               decoration:const BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular(30))
                               ),
                               height: 50.0,
                               width:double.infinity,
                               child: ElevatedButton(
                                 onPressed: (){
                                   final isValid = _myformkey.currentState!
                                       .validate();
                                   if (!isValid) {
                                     return;
                                   }
                                   else {
                                     _empLogin();
                                   }
                                },
                                   child:const Text("LOGIN"),
                                   style: ElevatedButton.styleFrom(
                                     shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(30.0)
                                     ),
                                     primary: Colors.green[800]
                                 ),
                               ),
                             ),
                           ],
                         ),
                       )
                   ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) , //

    );
    throw UnimplementedError();
  }
}