import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Providers/AttendanceStatusProvider.dart';
import '../../model/AttendanceStatusModel.dart';
import '../../utils/constant.dart';


class ViewMarkAttendance extends ConsumerStatefulWidget {
  var notReprtid,name,profileimg;

   ViewMarkAttendance(this.notReprtid,this.name,this.profileimg);

  @override
  _ViewMarkAttendanceState createState() => _ViewMarkAttendanceState();
}

class _ViewMarkAttendanceState extends ConsumerState<ViewMarkAttendance> {

  int emp_id=0;
  TextEditingController dateInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();

    _markAttendance( ) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    try{
      EasyLoading.show(status: 'marking...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}addattendence.php"),
          body:{
            "emp_id":widget.notReprtid,
            "r_id":emp_id.toString(),
            "status": selectedStatus,
            "atdate":dateInput.text.toString(),
          });
      var message = jsonDecode(response.body);
      if(response.statusCode==200)
        {
        EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.center );
        EasyLoading.dismiss();
        Navigator.pushNamedAndRemoveUntil(context, '/attendance', (route) => false);
        }
      else
      {
       EasyLoading.showToast("${message['message']}",toastPosition:EasyLoadingToastPosition.center );
      }
      print("emp_id ${widget.notReprtid}");
      print("r_id $emp_id");
      print("status $selectedStatus");
      print("atdate ${dateInput.text.toString()}");
    }
    catch(e)
    {
      print(e);
    }
  }

  var selectedStatus;
  Timer? _timer;

  @override
  void initState() {
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
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: _astatusdata.when(data: (_astatusdata){
            List<AttendanceStatusClass> _statusAttendance = _astatusdata.map((e) => e).toList();
             return Padding(
               padding: const EdgeInsets.all(10.0),
               child: Form(
                 key: _formKey,
                 child: ListView(
                   children: [
                     const SizedBox(height: 100,),
                     CircleAvatar(
                         radius: (40),
                         backgroundColor: Colors.white,
                         child: ClipRRect(
                           borderRadius:BorderRadius.circular(50),
                           child: FadeInImage(
                             image: NetworkImage("https://reporting.rasayamultiwings.com/${widget.profileimg}"),
                             placeholder: AssetImage("images/profile.png"),
                             imageErrorBuilder: (context, error, stackTrace) {
                               return Image.asset(
                                   "images/profile.png",
                                   fit: BoxFit.fitWidth);
                             },
                             fit: BoxFit.fitWidth,
                           ),
                         ),
                     ),
                     const SizedBox(height: 15,),
                     Center(child: Text("${widget.name}",style:const TextStyle(fontFamily: 'Alice',fontSize: 20,fontWeight: FontWeight.w500))),
                     SizedBox(
                       width: 150,
                       child: Container(
                         child: TextFormField(
                             controller: dateInput,
                             style:const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                             ),
                             decoration:const InputDecoration(
                                 icon: Icon(Icons.calendar_today,color: Colors.red,),
                                 labelText: "Date",
                                 labelStyle: TextStyle(color: Colors.green,
                                     fontFamily: 'Alkalami')
                             ),
                             readOnly: true,
                             onTap: () async {
                               DateTime? pickedDate = await showDatePicker(
                                 context: context,
                                 initialDate: DateTime.now(),
                                 firstDate:DateTime.now().subtract(Duration(days: 7)),
                                 lastDate: DateTime.now(),
                               );
                               if (pickedDate != null) {
                                 print(
                                     pickedDate);
                                 String formattedDate =
                                 DateFormat('yyyy-MM-dd').format(pickedDate);
                                 print(
                                     formattedDate);
                                 setState(() {
                                   dateInput.text = formattedDate;
                                 });
                               } else {}
                             },
                           validator: (value){
                               if(value!.isEmpty)
                                 {
                                   return "please select date";
                                 }
                               else
                                 {
                                   return null;
                                 }
                           },
                         ),
                       ),
                     ),
                     const SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: DropdownButtonFormField(
                         hint:const Text("--select--"),
                         items: _statusAttendance.map((item) {
                           return DropdownMenuItem(
                             value: item.id.toString(),
                             child: Center(child: Text(item.atStatus.toString().toUpperCase(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)),
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
                     ),
                     const SizedBox(height: 10,),
                     Container(
                       height: 50,
                       child: ElevatedButton(onPressed: ()
                       {
                         if(_formKey.currentState!.validate())
                         {
                          _markAttendance();
                         }
                         //
                       },
                        child:const Text("MARK ATTENDANCE"),
                       style: ElevatedButton.styleFrom(primary: Colors.indigo),),
                     )
                   ],
                 ),
               ),
             );
          },
            error: (err, s) => const Text(""),
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
        Navigator.pushNamedAndRemoveUntil(context, '/attendance', (r) => false);
        return Future.value(false);
      },
    );
  }
}
