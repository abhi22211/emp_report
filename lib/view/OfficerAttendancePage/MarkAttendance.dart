import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/TeamListProvider.dart';
import '../../model/TeamList_model.dart';
import 'AttendanceViewOfficer.dart';
import 'MarkAttendanceView.dart';

class Attendance extends ConsumerStatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends ConsumerState<Attendance> {

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(teamListDataProvider);
    //final _astatusdata = ref.watch(attendStatusDataProvider);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title:const Text("Attendance",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, "/reporthome", (route) => false);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                    (context) => AttendanceListOffV()), (route) => false);
              },
              child:const Padding(padding: EdgeInsets.all(15),
              child:const Text("view Attendance"),),
            ),
          ],
        ),
        body:RefreshIndicator(
          onRefresh: () async=> await ref.refresh(teamListDataProvider),
          child: _data.when(data:(_data){
            List<TeamList> _teamlst = _data.map((e) => e).toList();
            if(_teamlst.isEmpty)
            {
              return Center(
                child: Container(
                  child:const Text("NO RECORD FOUND"),
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
                    if(_teamlst[index].emp_status=='1')
                      {
                        return Card(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            leading: CircleAvatar(
                                radius: (40),
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius:BorderRadius.circular(50),
                                  child: FadeInImage(
                                    image: NetworkImage("https://reporting.rasayamultiwings.com/${_teamlst[index].profileimg}"),
                                    placeholder: AssetImage("images/profile.png"),
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
                            title: Text(" ${_teamlst[index].emp_name}",overflow: TextOverflow.ellipsis,
                              style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                            subtitle: ElevatedButton(onPressed: (){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMarkAttendance(
                                  _teamlst[index].emp_id,_teamlst[index].emp_name,_teamlst[index].profileimg
                              )), (route) => false);
                            },
                              child:const Text("MARK ATTENDANCE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                              style: ElevatedButton.styleFrom(primary:Colors.indigo.shade200),
                            ),
                          ),
                        );
                      }
                    else
                      {
                        return const Card();
                      }

                  },
                ),
              );
            }
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
        Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
        return Future.value(false);
      },
    );
  }
}

