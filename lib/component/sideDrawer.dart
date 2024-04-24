import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget
{
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  String? client_name="",usertype="",profileimg="";

  _check_userType()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype=  prefs.getString('usertype') == null ? "" : prefs.getString('usertype')!;
    profileimg=  prefs.getString('profileimg') == null ? "" : prefs.getString('profileimg')!;
    setState(() {
      usertype;
      profileimg;
    });
  }

  @override
  void initState() {
    super.initState();
    _check_userType();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
              ),
              child: Center(
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    CircleAvatar(
                          radius: (40),
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius:BorderRadius.circular(50),
                            child: FadeInImage(
                              image: NetworkImage("https://reporting.rasayamultiwings.com/${profileimg}"),
                              placeholder:const AssetImage("images/profile.png"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    "images/profile.png",
                                    fit: BoxFit.fitWidth);
                              },
                              fit: BoxFit.fitWidth,
                            ),
                          )
                      ),
                    const SizedBox(height: 10,),
                    Text(
                      client_name.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading:const Icon(
                  Icons.person
              ),
              title:const Text("Profile"),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading:const Icon(
                  Icons.work
              ),
              title:const Text("Daily Work"),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, '/dailytaskreport', (route) => false);

              },
            ),
            ListTile(
              leading:const Icon(
                  Icons.newspaper_outlined
              ),
              title:const Text("Work Report List"),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);

              },
            ),
            const Divider(
              color: Colors.black,
            ),
             Column(
               children:
               [
                 if(usertype == "emp".toString())...[
                   ListTile(
                     leading:const Icon(
                         Icons.calendar_month_sharp
                     ),
                     title:const Text("Punch Attendance"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/attendancelist', (route) => false);
                     },
                   ),
                   ListTile(
                     leading:const Icon(
                         Icons.add_business
                     ),
                     title:const Text("Market Survey"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/market', (route) => false);
                     },
                   ),
                   ListTile(
                     leading:const Icon(
                         Icons.list_alt
                     ),
                     title:const Text("Survey List"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/surveylist', (route) => false);

                     },
                   ),
                 ]
                 else...[
                   ListTile(
                     leading:const Icon(
                         Icons.calendar_month_sharp
                     ),
                     title:const Text("Attendance"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/attendance', (route) => false);
                     },
                   ),
                   ListTile(
                     leading:const Icon(
                         Icons.work_outline_outlined
                     ),
                     title:const Text("Department Work"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/deptreport', (route) => false);
                     },
                   ),
                   ListTile(
                     leading:const Icon(
                         Icons.featured_play_list_outlined
                     ),
                     title:const Text("Team List"),
                     onTap: (){
                       Navigator.pushNamedAndRemoveUntil(context, '/ourteam', (route) => false);
                     },
                   ),
                 ]

               ],
             ),
            ListTile(
              leading:const Icon(
                  Icons.logout
              ),
              title:const Text("Logout"),
              onTap: ()async{
                final pref = await SharedPreferences.getInstance();
                pref.clear();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}