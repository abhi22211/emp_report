import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/AttendanceResultProvider.dart';
import '../../model/AttendanceResult_model.dart';
import 'MonthlyFilterAttendance.dart';

class AttendanceListOffV extends ConsumerStatefulWidget {
  const AttendanceListOffV({Key? key}) : super(key: key);
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends ConsumerState<AttendanceListOffV> {

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(attenResultDataProvider);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title:const Text("Today's Attendance",style: TextStyle(fontFamily: 'Alice',fontSize: 23)),
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, "/attendance", (route) => false);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:
                    (context) => AttendanceMonthFilter()), (route) => false);
              }, icon: Icon(Icons.filter_alt_sharp)),
            )
          ],
        ),
        body:RefreshIndicator(
          onRefresh: () async=> await ref.refresh(attenResultDataProvider),
          child: _data.when(data:(_data){
            List<AttendanceClass> _alstov = _data.map((e) => e).toList();
              return ListView.builder(
                  //controller: sc,
                  itemCount: _alstov.length,
                  itemBuilder: (_, index)
                  {
                    return Card(
                      color: Colors.orange.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: (20),
                            backgroundColor: Colors.white,
                            child: Text("${index+1}"),
                        ),
                        title: Text("${_alstov[index].empName}"),
                        trailing:Stack(
                          children: [
                            if(_alstov[index].attendence_id==1.toString())
                              Text("${_alstov[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.green.shade500,
                              fontWeight: FontWeight.w500),)
                              else if(_alstov[index].attendence_id==2.toString())
                              Text("${_alstov[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.red.shade500,
                              fontWeight: FontWeight.w500),)
                              else if(_alstov[index].attendence_id==3.toString())
                              Text("${_alstov[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.orange.shade500,
                              fontWeight: FontWeight.w500),)
                              else
                              Text("${_alstov[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.blue.shade500,
                              fontWeight: FontWeight.w500),)
                             ],
                          ),//Text("${_alstov[index].atStatus}"),
                      ),
                    );
                  },
                );
          },
            error: (err, s) => Text(err.toString()),
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

