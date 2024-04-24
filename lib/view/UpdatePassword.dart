import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Connectivity/ConnectivitystatusNotifier.dart';

class UpdatePassword extends StatefulWidget {
  String emp_phone="";
  UpdatePassword(this.emp_phone);
  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  TextEditingController _mob = TextEditingController();
  bool _passwordVisible=false;
  bool _passwordVisible1=false;
  String usertype='';

  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
  }

  UpdatePassword() async{
    try{
      var response = await http.post(Uri.parse("https://reporting.rasayamultiwings.com/api/update_password.php"),
          body:{
            "mobileno":_mob.text.toString(),
            "new_password":pass1.text.toString(),
          });
      var message = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" ${message['message'].toString()}")),
      );
      print(response.body);
      print("mobileno "+_mob.text.toString());
      print("new_password "+pass1.text.toString(),);
      print("Confirmpassword"+pass2.text.toString());
    }
    catch(e)
    {
      print(e);
    }
  }
  @override
  void initState() {
    _checkOfficer();
    _mob.text =widget.emp_phone;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title:const Text("UPDATE PASSWORD"),
          leading: IconButton(icon:const Icon(Icons.arrow_back), onPressed: () {
            if( usertype == "emp".toString())
            {
              print("Login as employee");
              print(usertype);
              Navigator.pushNamedAndRemoveUntil(context, '/profile', (r) => false);
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home')),
              );
            }
            else
            {
              print("Login as reporting officer");
              print(usertype);
              Navigator.pushNamedAndRemoveUntil(context, '/profile', (r) => false);
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home')),
              );
            }          },),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child:const Text("Change your password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                  ),
                  Container(
                    padding:const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Text("Mobile",style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          TextFormField(
                            enabled: false,
                            controller: _mob,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '91+',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              suffixIcon:const Icon(
                                Icons.mobile_friendly,
                                color: Colors.green,
                              ),

                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          const Text("New Password",style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          TextFormField(
                            controller: pass1,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:const  BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10,),
                          const Text("Confirm Password",style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 5,),
                          TextFormField(
                            controller: pass2,
                            obscureText: !_passwordVisible1,
                            style:const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible1 = !_passwordVisible1;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '* required';
                              }
                              if(value != pass1.text)
                                {
                                  return 'New & Cofirm password does not match';
                                }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {

                                if (_formKey.currentState!.validate()) {
                                  UpdatePassword();
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child:const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'CHANGE PASSWORD',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
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
          },
        ),
      ),
      onWillPop: (){
        if( usertype == "emp".toString())
        {
          print("Login as employee");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/profile', (r) => false);
        }
        else
        {
          print("Login as reporting officer");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/profile', (r) => false);
        }        return Future.value(false);
      },
    );
  }
}
