import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:emp_report/utils/constant.dart';
import 'package:emp_report/view/OfficersViewSL.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providers/TeamListProvider.dart';
import '../model/TeamList_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:shared_preferences/shared_preferences.dart';

class TeamListOfficer extends ConsumerStatefulWidget {
  const TeamListOfficer({Key? key}) : super(key: key);

  @override
  _TeamListOfficerState createState() => _TeamListOfficerState();
}

class _TeamListOfficerState extends ConsumerState<TeamListOfficer> {

  Timer? _timer;
  //Active=1,Deactive=0
  changeEmpStatus(empid,ref) async{
    EasyLoading.show(status: 'updating...');
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}update_employee_status.php"),
    body: {
      "emp_id":empid.toString(),
      "status":"1",
    });
    var message = jsonDecode(response.body);
    EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.bottom );
    EasyLoading.dismiss();
    await ref.refresh(teamListDataProvider);
  }
  changeEmpStatus1(empid,ref) async{
    EasyLoading.show(status: 'updating...');
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}update_employee_status.php"),
        body: {
          "emp_id":empid.toString(),
          "status":"0",
        });
    var message = jsonDecode(response.body);
    EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.bottom );
    EasyLoading.dismiss();
    await ref.refresh(teamListDataProvider);
  }

  String depart_name="";
  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    depart_name = prefs.getString('depart_name') == null ? "" : prefs.getString('depart_name')!;
    setState(() {
      print("Departmenrt:"+depart_name);
    });
  }

@override
void initState() {
  _fetchData();
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
    final _data = ref.watch(teamListDataProvider);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: Text("Team List",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, "/reporthome", (route) => false);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body:RefreshIndicator(
          onRefresh: () async=> await ref.refresh(teamListDataProvider),
          child: _data.when(data:(_data){
            List<TeamList> _teamlst = _data.map((e) => e).toList();
            if(_teamlst.isEmpty)
            {
             return Center(
                child: Container(
                child: Text("NO RECORD FOUND"),
                ),
              );
            }
            else
              {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    //controller: sc,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _teamlst.length,
                    itemBuilder: (context, index)
                    {
                      return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                      radius: (40),
                                      backgroundColor: Colors.white,
                                      child: ClipRRect(
                                        borderRadius:BorderRadius.circular(30),
                                        child: _teamlst[index].profileimg == "" ? Image.asset("images/profile.png") : Image.network("https://reporting.rasayamultiwings.com/${_teamlst[index].profileimg}"),
                                      )
                                  ),
                                  title: Text(" ${_teamlst[index].emp_name}",overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                                  subtitle: Text("${_teamlst[index].desg_name}, ${_teamlst[index].depart_name}" ,style: TextStyle(fontWeight: FontWeight.w500),),
                                  trailing: GestureDetector(
                                    onTap: (){
                                      UrlLauncher.launch('tel: ${_teamlst[index].emp_phone}');
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            child: IconButton(onPressed: (){

                                            }, icon: Icon(Icons.call,),)),
                                        SizedBox(height: 15,),

                                        Text("${_teamlst[index].emp_phone ?? "-"}",style: TextStyle(fontWeight: FontWeight.w500)),

                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextButton(
                                        child: Text("View Detail"),
                                        onPressed: (){
                                          showModalBottomSheet(
                                            useSafeArea: true,
                                            isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                              return Container(
                                                padding:const EdgeInsets.only(left: 5),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Text("Emp Code: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey
                                                          ),),
                                                          Text(" ${_teamlst[index].emp_code}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Name: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].emp_name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Email: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].emp_email ?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Mobile: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].emp_phone?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Blood Group: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].blood_grp?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Gender: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].gender?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Material Status: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].metrial_status?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Date of Joining: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].doj?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Address: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Flexible(child: Text("${_teamlst[index].emp_adress?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Work Location: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].workloaction?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children: [
                                                          Text("Designation: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].desg_name?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                      Divider(color: Colors.black,),
                                                      Row(
                                                        children : [
                                                          Text("Departmrnt: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey),),
                                                          Text("${_teamlst[index].depart_name?? "-"}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              );
                                          });
                                        },
                                      ),
                                    ),
                                     Container(
                                        child: Column(
                                          children: [
                                            if (depart_name == "Marketing") ...[
                                              Container(
                                                padding: EdgeInsets.only(right:10),
                                                child: ElevatedButton(onPressed: (){
                                                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                      (context) => OfficersViewSL(_teamlst[index].emp_id,_teamlst[index].emp_name)), (route) => false);
                                                },
                                                  child: Text("SURVEY LIST",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                                  style: ElevatedButton.styleFrom(primary:Colors.indigo.shade200),
                                                )
                                              ),
                                            ]  else ...[
                                              Container()
                                            ],
                                          ],
                                        ),
                                      ),
                                    Container(
                                            padding: EdgeInsets.only(right:10),
                                            child: Column(
                                              children: [
                                                if (_teamlst[index].emp_status == '0') ...[
                                                ElevatedButton(onPressed: (){
                                                  changeEmpStatus(_teamlst[index].emp_id,ref);
                                                },
                                                child: Text("DEACTIVE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                                style: ElevatedButton.styleFrom(primary:Colors.pink),
                                                )
                                                ]  else ...[
                                                ElevatedButton(onPressed: (){
                                                  changeEmpStatus1(_teamlst[index].emp_id,ref);
                                                },
                                                child: Text("ACTIVE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                                style: ElevatedButton.styleFrom(primary: Colors.green),
                                                )
                                                ]
                                              ],
                                            ),
                                            alignment: Alignment.centerRight,
                                          ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                              ],
                            ),
                          );
                    },
                  ),
                );
              }
          },
            error: (err, s) => Text(""),
            loading: () => const Center(
              child: CircularProgressIndicator(),
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
        Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
        return Future.value(false);
      },
    );
  }

}
