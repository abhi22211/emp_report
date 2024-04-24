import 'dart:math';

import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:emp_report/Providers/EmployeeLeaveProvider.dart';
import 'package:emp_report/view/Leave/ActionLeaveApprove.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/Leave/LeaveAppReportOff_Model.dart';


class LeaveAppReportOff extends ConsumerWidget {
  const LeaveAppReportOff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    final _data = ref.watch(empLeaveDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title:const Text("Employee Leave List",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/reporthome", (route) => false);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.pushNamedAndRemoveUntil(context, "/reporthome", (route) => false);
          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () async => await ref.refresh(empLeaveDataProvider),
          child: _data.when(
            data: (_data){
            List<EmployeeLeaveList_Class>  epl = _data.map((e) => e).toList();
            if(epl.isEmpty)
              {
                return Center(child: Container(child:const Text("No Record Found"),));
              }
            else
              {
                return ListView.builder(
                    itemCount: epl.length,
                    itemBuilder: (_,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ApproveLeave(epl[index].id),), (route) => false);
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(child: Text("${epl[index].empName!.substring(0,1)}",
                                  style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 17),)
                                  ,backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  foregroundColor: Colors.white,),
                                title: Text(" ${epl[index].empName}",overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                                subtitle: Text("${epl[index].desgName}, ${epl[index].departName}" ,style: TextStyle(fontWeight: FontWeight.w500),),
                                trailing: Text("${epl[index].leaveDate}",style: TextStyle(fontWeight: FontWeight.w500)),
                              ),
                              const  Divider(
                                color: Colors.grey,
                              ),
                              Container(
                                padding:const EdgeInsets.only(right:10),
                                child: Column(
                                  children: [
                                    if (epl[index].status == '0') ...[
                                      Container(
                                        padding:const EdgeInsets.all(3),
                                        color: Colors.yellow.shade700,
                                        child:const Text("PENDING",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                                    ] else if(epl[index].status == '1')...[
                                      Container(
                                        padding:const EdgeInsets.all(3),
                                        color: Colors.green,
                                        child:const Text("APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                                    ] else
                                      ...[
                                        Container(
                                          padding:const EdgeInsets.all(3),
                                          color: Colors.pink,
                                          child:const Text("NOT APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                        ),
                                      ]
                                  ],
                                ),
                                alignment: Alignment.centerRight,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              }

          },
           error: (err,s)=>Text(""),
           loading: (){
            return Center(child:const CircularProgressIndicator());
            }
          ),
        )
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
    );
  }
}
