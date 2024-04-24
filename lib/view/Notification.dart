import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Notiication extends StatefulWidget {
  const Notiication({Key? key}) : super(key: key);

  @override
  State<Notiication> createState() => _NotiicationState();
}

class _NotiicationState extends State<Notiication> {
  @override

  String usertype='';

  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
  }
  @override
  void initState() {
    _checkOfficer();
    super.initState();
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { if( usertype == "emp".toString())
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
      return Future.value(false); },
      child: Scaffold(
        appBar: AppBar(
          title:const Text("Notification"),
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
                  const SnackBar(content:const Text('Home')),
                );
              }

            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Column(
              children: [
                Container(
                  child:const Text("Notification"),
                ),

              ],
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
    );
  }
}
