import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:emp_report/model/Leave/LeaveUpdate_Modal.dart';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../Providers/AttendanceStatusProvider.dart';
import '../../Providers/AttendanceStatusProvider1.dart';
import '../../model/AttendanceStatusModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApproveLeave extends ConsumerStatefulWidget {
  var id;
  ApproveLeave(this.id);

  @override
  _ApproveLeaveState createState() => _ApproveLeaveState();
}

class _ApproveLeaveState extends ConsumerState<ApproveLeave> {

  TextEditingController showMsg = TextEditingController();
  String? _character = "1";
  Timer? _timer;
  var selectedStatus;
  var selectedStatus1;


  //Employee Leave Detail
  List<LeaveUpdate_Class> luc=[];
  var msg;
  Future<void>  _leavedetail()async{
    try{
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}/leaveAction.php"),
    body:{
      "id":widget.id
    });
    print(response);
     var data = UpdateLeaveResponse.fromJson(json.decode(response.body));
     print(data);
     setState(() {
       luc=data.user!;
     });
     print(luc);
    }
    catch(error){
      throw(error);
    }
  }

  updateLeave(leavedate,id,emp,rep) async{
    try{
      EasyLoading.show(status: 'updating...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}leaveupdate.php"),
          body:{
            "leave_status":_character,
            "at_status":selectedStatus.toString(),
            "emp_id":emp.toString(),
            "reporting_id":rep.toString(),
            "leave_date":leavedate.toString(),
            "id":id.toString(),
          });
      print(response.body);
      if(jsonDecode(response.body)['error']=="200")
      {
        Navigator.pushNamedAndRemoveUntil(context, '/leavereporting', (route) => false);
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
      }
      else
      {
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
      }
      print("leave_status"+ _character.toString());
      print("at_status"+selectedStatus.toString());
      print("emp_id"+emp.toString());
      print("reporting_id"+rep.toString());
      print("leave_date"+leavedate.toString());
      print("id"+id.toString());
    }
    catch(e)
    {
      print(e);
    }
  }
  updateLeave1(leavedate,id,emp,rep) async{
    try{
      EasyLoading.show(status: 'updating...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}leaveupdate.php"),
          body:{
            "leave_status":_character,
            "at_status":selectedStatus1.toString(),
            "emp_id":emp.toString(),
            "reporting_id":rep.toString(),
            "leave_date":leavedate.toString(),
            "id":id.toString(),
          });
      print(response.body);
      if(jsonDecode(response.body)['error']=="200")
      {
        Navigator.pushNamedAndRemoveUntil(context, '/leavereporting', (route) => false);
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
      }
      else
      {
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
      }
      print("leave_status"+ _character.toString());
      print("at_status"+selectedStatus1.toString());
      print("emp_id"+emp.toString());
      print("reporting_id"+rep.toString());
      print("leave_date"+leavedate.toString());
      print("id"+id.toString());
    }
    catch(e)
    {
      print(e);
    }
  }
  @override
  void initState() {
    _leavedetail();
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
    final _astatusdata = ref.watch(attendStatusDataProvider);
    final _astatusdata1 = ref.watch(attendStatusDataProvider1);
    return WillPopScope(
      onWillPop: (){
        Navigator.pushNamedAndRemoveUntil(context, '/leavereporting', (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: Container(
              alignment: Alignment.center,
              child:const Text("Employee Leave Update",style:const TextStyle(fontFamily: 'Alice'),)),
        ),
        body: SafeArea(
          child: ListView.builder(
              itemCount: luc.length >1 ? 1: luc.length,
              itemBuilder: (_,index){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(child: Text("${luc[index].empName!.substring(0,1)}",
                          style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,),
                        title: Text(" ${luc[index].empName}",overflow: TextOverflow.ellipsis,
                          style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                        subtitle: Text(" ${luc[index].departName}" ,style:const TextStyle(fontWeight: FontWeight.w500),),
                        trailing: Text("${luc[index].leaveDate}",style:const TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        padding:const EdgeInsets.only(right:10),
                        child: Column(
                          children: [
                            if (luc[index].status == '0') ...[
                              Container(
                                padding:const EdgeInsets.all(3),
                                color: Colors.yellow.shade700,
                                child:const Text("PENDING",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                            ] else if(luc[index].status == '1')...[
                              Container(
                                padding:const EdgeInsets.all(3),
                                color: Colors.green,
                                child:const Text("APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                            ] else
                              ...[
                                Container(
                                  padding:const EdgeInsets.all(3),
                                  color: Colors.pink,
                                  child:const Text("NOT APPROVED",style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),),
                              ]
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          const Text("Subject: ",style:const TextStyle(fontSize: 15,color: Colors.black54)),
                          Text("${luc[index].title}",style:const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Container(child:const Text("Message"),),
                      TextFormField(
                        enabled: false,
                        initialValue: luc[index].message,style:const TextStyle(fontFamily: 'DancingScript',fontSize: 20,color: Colors.black),
                        //controller: showMsg,
                         decoration: InputDecoration(
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:const BorderSide(width: 1.5)
                          )
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: ListTile(
                                title: const Text('Approve'),
                                leading: Radio(
                                  value: "1",
                                  groupValue: _character,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _character = value;
                                      print(_character);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: ListTile(
                                title: const Text('Not Approve'),
                                leading: Radio(
                                  value: "2",
                                  groupValue: _character,
                                  onChanged: (String? value){
                                    setState(() {
                                      _character = value;
                                      print(_character);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child:Column(
                          children: [
                            if (_character == "1".toString()) ...[
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  children: [
                                    /*Container(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text("Change Status")
                                      ,alignment: Alignment.centerLeft,
                                      ),*/
                                    Container(
                                      child: _astatusdata1.when(data: (_astatusdata1){
                                        List<AttendanceStatusClass> _statusAttendance = _astatusdata1.map((e) => e).toList();
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: DropdownButtonFormField(
                                            hint:const Text("--select--"),
                                            items: _statusAttendance.map((item) {
                                              return DropdownMenuItem(
                                                value: item.id.toString(),
                                                child: Text(item.atStatus.toString()),
                                              );
                                            }).toList(),
                                            onChanged:(newVal) {
                                              setState(() {
                                                selectedStatus1 = newVal;
                                                print(selectedStatus1);
                                              });
                                            },
                                            validator: (value) => value == null
                                                ? '*required' : null,
                                          ),
                                        );
                                      },
                                        error: (err, s) => Text(err.toString()),
                                        loading: () => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(onPressed: (){
                                        updateLeave1(luc[index].leaveDate,luc[index].id,luc[index].empId,luc[index].reportingId);
                                      }, child:const Text("Employee Leave Update",
                                        style:const TextStyle(fontSize: 16),),
                                        style: ElevatedButton.styleFrom(primary: Colors.green.shade300),),
                                    )
                                  ],
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  children: [
                                    //present
                                    /*Container(
                                      padding: EdgeInsets.only(right:30),
                                      child: Text("Change Status"),alignment: Alignment.centerRight,),*/
                                    Container(
                                      child: _astatusdata.when(data: (_astatusdata){
                                        List<AttendanceStatusClass> _statusAttendance = _astatusdata.map((e) => e).toList();
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: DropdownButtonFormField(
                                            hint:const Text("--select--"),
                                            items: _statusAttendance.map((item) {
                                              return DropdownMenuItem(
                                                value: item.id.toString(),
                                                child: Text(item.atStatus.toString()),
                                              );
                                            }).toList(),
                                            onChanged:(newVal) {
                                              setState(() {
                                                selectedStatus = newVal;
                                                print(selectedStatus);
                                              });
                                            },
                                            validator: (value) => value == null
                                                ? '*required' : null,
                                          ),
                                        );
                                      },
                                        error: (err, s) => Text(err.toString()),
                                        loading: () => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(onPressed: (){
                                        updateLeave(luc[index].leaveDate,luc[index].id,luc[index].empId,luc[index].reportingId);
                                      }, child:const Text("Employee Leave Update",
                                        style:const TextStyle(fontSize: 16),),
                                        style: ElevatedButton.styleFrom(primary: Colors.green.shade300),),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
             })
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
