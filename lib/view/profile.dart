import 'package:emp_report/Providers/ProfileProvider.dart';
import 'package:emp_report/model/Profile_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import 'UpdatePassword.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  String usertype='';
  bool _enabled = true;
  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')  == null ? "" : prefs.getString('usertype')!;
  }


  @override
  void initState() {
    super.initState();
    _checkOfficer();
  }

  @override
  Widget build(BuildContext context) {
   final data = ref.watch(profileListDataProvider);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Text("PROFILE"),
          backgroundColor: Colors.green[800],
          leading: IconButton(onPressed: (){
            if( usertype == "emp".toString())
            {
              print("Login as employee");
              print(usertype);
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Home')),);
            }
            else
            {
              print("Login as reporting officer");
              print(usertype);
              Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home')),
               );
             }
           }, icon: const Icon(Icons.arrow_back)),
        ),
        body: data.when(
          data: (data){
            List<Profile_Class> pc = data.map((e) => e).toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height*1,
              child: ListView.builder(
                itemCount: pc.length,
                itemBuilder: (_, index)
                {
                  return ListTile(title: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  IconButton(onPressed: (){
                                    //Navigator.pushNamedAndRemoveUntil(context, '/updatepassword', (route) => false);
                                    Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                        (context) => UpdatePassword("${pc[index].empPhone}")), (route) => false);

                                  }, icon: const Icon(Icons.key)),
                                  const Text("change password",style: TextStyle(fontSize: 10),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child:CircleAvatar(radius: (40),
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius:BorderRadius.circular(50),
                              child: pc[index].profileimg == null ? Image.asset("images/profile.png") : Image.network("https://reporting.rasayamultiwings.com/${pc[index].profileimg}"),
                            )
                        ),
                      ),
                      Container(
                        child: Text("${pc[index].empName}",style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Container(child: Text("${pc[index].empEmail}",style:const TextStyle(color: Colors.grey),),),
                      const SizedBox(
                        height: 25,
                      ),
                      ExpansionTile(
                        backgroundColor: Colors.white,
                        initiallyExpanded: true,
                        title: Text("PERSONAL DETAILS",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.green.shade700),),
                        children: [
                          ListTile(
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Employee Code",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                                    Container(
                                        padding:const EdgeInsets.only(left: 50),
                                        child: const Text("Blood Group",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${pc[index].empCode}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                    Text("${pc[index].blood_grp}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                const Divider(color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Mobile Number",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                                    Container(
                                        padding:const EdgeInsets.only(left: 50),
                                        child:const Text("Date Of Joining",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${pc[index].empPhone}",style: TextStyle(fontWeight: FontWeight.w500),),
                                    Text("${pc[index].doj}",style: TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                const Divider(color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Gender",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                                    Container(
                                        padding:const EdgeInsets.only(left: 50),
                                        child:const Text("Material Status",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${pc[index].gender??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                    Text("${pc[index].metrial_status??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                const Divider(color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Department",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                                    Container(
                                        padding:const EdgeInsets.only(left: 50),
                                        child:const Text("Designation",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${pc[index].depart_name??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                    Text("${pc[index].desg_name??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                const Divider(color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Reporting Officer",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                                    Container(
                                        padding:const EdgeInsets.only(left: 50),
                                        child:const Text("Work Loaction",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${pc[index].rep_offer_id??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                    Text("${pc[index].workloaction??"--"}",style:const TextStyle(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      //Address
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        color: Colors.black12,
                        width: double.infinity,
                        height: 40,
                        child:const Text("EMPLOYEE ADDRESS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Row(
                          children: [
                            const Text("ADDRESS: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].empAdress ??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("STATE: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].state_name??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("CITY: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].city_name??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding:const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("PINCODE: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].pincode??"-"}")
                          ],
                        ),
                      ),

                      //Emergency Contact
                      const SizedBox(height: 15,),
                      Container(
                        padding:const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        color: Colors.black12,
                        width: double.infinity,
                        height: 40,
                        child: const Text("EMERGENCY CONTACT",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Row(
                          children: [
                            const Text("CONTACT PERSON: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].contactname ??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("CONTACT: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].emecontactno??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("RELATION: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].relation??"-"}")
                          ],
                        ),
                      ),

                      //Bank Detail
                      const SizedBox(height: 15,),
                      Container(
                        padding:const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        color: Colors.black12,
                        width: double.infinity,
                        height: 40,
                        child: const Text("BANK DETAIL",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.grey),),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: Row(
                          children: [
                            const Text("BANK: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].bankname ??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("BRANCH: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].branchname??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("ACCOUNT NO.: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].accountno??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("IFSC CODE: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].ifsc??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("NOMINEE NAME: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].nomneename??"-"}")
                          ],
                        ),
                      ),

                      Container(
                        padding:const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("NOMINEE CONTACT: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].nomineecontact??"-"}")
                          ],
                        ),
                      ),
                      Container(
                        padding:const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text("NOMINEE RELATION: ",style: TextStyle(color: Colors.grey),),
                            Text(" ${pc[index].nomneerelation??"-"}")
                          ],
                        ),
                      ),
                    ],
                  ));
                },
              ),
            );
          },

          error: (err, s) => Text(""),
          loading: () => const Center(
            child: CircularProgressIndicator(),
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
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Home')),);
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
