import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  void startTimer() {
    Timer(Duration(seconds: 4),()=>startNewPage());
  }

  startNewPage() async
  {
    final pref = await SharedPreferences.getInstance();
    int? emp_id = pref.getInt("emp_id");
    String? usertype = pref.getString("usertype");
    if(emp_id!=null)
    {
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

    }
    else
    {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[400],
      body:Column(
        children: [
          Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.35)),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/rasaya.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text("RASAYA Employee Reporting System",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,fontFamily: 'Alice'),),
                Text("आपका विकास हमारा प्रयास",style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
