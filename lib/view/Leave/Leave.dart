import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Providers/LeaveListProvider.dart';
import '../../model/Leave/LeaveUpdate_Modal.dart';


class Leave extends ConsumerStatefulWidget {
  const Leave({Key? key}) : super(key: key);

  @override
  _LeaveState createState() => _LeaveState();
}

class _LeaveState extends ConsumerState<Leave> {

   Timer? _timer;
   TextEditingController contMessage = TextEditingController();
   TextEditingController contTitle = TextEditingController();
   var _myLeavekey = GlobalKey<FormState>();

   applyforleave() async
   {
     int emp_id = 0;
     String rep_offer_id="";
     SharedPreferences prefs = await SharedPreferences.getInstance();
     emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
     EasyLoading.show(status: 'adding...');
     rep_offer_id= prefs.getString('rep_offer_id')==null ? "":prefs.getString('rep_offer_id')!;
     var response = await http.post(Uri.parse("${AppConstant.BASE_URL}emp_leave.php"),
       body: {
       "emp_id":emp_id.toString(),
       "rep_officer_id":rep_offer_id,
       "message":contMessage.text.toString(),
       "title":contTitle.text.toString(),
       });
       print("emp_id"+emp_id.toString());
       print("rep_offer_id"+ rep_offer_id);
       print("message"+contMessage.text.toString());
       print("title"+contTitle.text.toString());
     var message = jsonDecode(response.body);
       print(message['message']);
       if(response.statusCode == 200)
       {
         final parsed = jsonDecode(response.body);
         print(parsed);
         EasyLoading.showToast(message['message'],toastPosition: EasyLoadingToastPosition.center);
         EasyLoading.dismiss();
         _showLeaveList();
         contMessage.clear();
         contTitle.clear();
       }
       else
       {
         throw Exception(response.reasonPhrase);
       }
      }


   //Leave List
   List<LeaveUpdate_Class> leavelist=[];
   Future<void> _showLeaveList() async {
     try {
       int emp_id = 0;
       SharedPreferences prefs = await SharedPreferences.getInstance();
       emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
       var response = await http.post(Uri.parse("${AppConstant.BASE_URL}monthlyemployeeleave.php"),
           body:{
             "emp_id": emp_id.toString(),
           });
       print(response.body);
       var data = UpdateLeaveResponse.fromJson(json.decode(response.body));
       setState(() {
         leavelist = data.user!;
         print(leavelist);
       });
     }
     catch (error) {
       throw(error);
     }
   }

      @override
      void initState() {
        _showLeaveList();
        EasyLoading.addStatusCallback((status) {
        print('EasyLoading Status $status');
        if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();}});
        super.initState();
      }

      @override
    void dispose() {
    contMessage.dispose();
    contTitle.dispose();
    super.dispose();
    }


  @override
  Widget build(BuildContext context) {
        final _data = ref.watch(leaveListDataProvider);
    return WillPopScope(
      onWillPop: (){
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.green.shade800,
         title:const Text("Leave"),
         leading: IconButton(
           onPressed: (){
             Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
           },
           icon: Icon(Icons.arrow_back),
         ),
       ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding:const EdgeInsets.fromLTRB(0, 20, 0, 5),
                  child:const Text("APPLY FOR LEAVE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                ),
                Form(
                  key: _myLeavekey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: contTitle,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(width: 1.5,),),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(width: 1.5,),),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(width: 1.5,),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              label:const Text('Title'),
                              labelStyle: TextStyle(
                              fontWeight: FontWeight.w500)),
                             validator: (value){
                            if(value!.isEmpty){
                              return "*required";
                            }
                            else
                              {
                                return null;
                              }
                             },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: contMessage,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  width: 1.5,),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  width: 1.5,),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  width: 1.5,),
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              label:const Text('Write reason'),
                              labelStyle:const TextStyle(
                              fontWeight: FontWeight.w500)),
                              maxLines: 5,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return "*required";
                                }
                                else
                                {
                                  return null;
                                }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:const EdgeInsets.fromLTRB(10,0,10,0),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      if(_myLeavekey.currentState!.validate())
                        {
                          applyforleave();
                        }
                      else
                        {
                          return null;
                        }
                    },
                    child:const Text("APPLY"),style: ElevatedButton.styleFrom(primary: Colors.green.shade200),
                  ),
                ),
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:const EdgeInsets.all(10),
                    color: Colors.purple.shade200,
                    width: double.infinity,
                    child:const Text("Applied Leave Status",style:const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),),),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  itemCount: leavelist.length,
                  itemBuilder: (context, index) {
                    if(leavelist.isEmpty)
                    {
                      return Container(child:const Text("Not Applied for Leave"),);
                    }
                    else
                    {
                      return Card(
                        color: Colors.purple.shade50,
                        child: ListTile(
                          title: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: Text(" ${leavelist[index].title!.toUpperCase()}",overflow: TextOverflow.ellipsis,
                                    style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                                  ),
                                  Text(" ${leavelist[index].leaveDate}",overflow: TextOverflow.ellipsis,
                                  style:const TextStyle(fontSize: 15),),
                                ],
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: leavelist[index].message,style:const TextStyle(fontFamily: 'DancingScript',fontSize: 20,color: Colors.black),
                                //controller: showMsg,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:const BorderSide(width: 1.5)
                                    ),
                                  fillColor: Colors.white,
                                  filled: true
                                ),
                                maxLines: 5,
                               ),
                              Row(
                                children: [
                                  const Text("Status: ",overflow: TextOverflow.ellipsis, style:const TextStyle(fontSize: 15,color: Colors.grey),),
                                Container(
                                    padding:const EdgeInsets.only(right:10),
                                    child: Column(
                                      children: [
                                        if (leavelist[index].status == '0') ...[
                                          Card(
                                            elevation:5,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              color: Colors.yellow.shade700,
                                              child:const Text("PENDING",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                                          ),
                                        ] else if(leavelist[index].status == '1')...[
                                          Card(
                                            elevation:5,
                                            child: Container(
                                              padding:const EdgeInsets.all(3),
                                              color: Colors.green,
                                              child:const Text("APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                                          ),
                                        ] else
                                          ...[
                                            Card(
                                              elevation:5,
                                              child: Container(
                                                padding:const EdgeInsets.all(3),
                                                color: Colors.pink,
                                                child:const Text("NOT APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                                            ),
                                          ]
                                      ],
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      );
                    }
                  },
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
