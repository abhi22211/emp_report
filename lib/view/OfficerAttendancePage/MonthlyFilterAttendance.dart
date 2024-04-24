import 'dart:async';
import 'dart:convert';
import 'package:emp_report/Connectivity/ConnectivitystatusNotifier.dart';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../CSV/AttendanceCSV.dart';
import '../../PDF/AttendancePdf.dart';
import '../../Providers/TeamListProvider.dart';
import '../../model/MonthwiseAttendance_model.dart';
import '../../model/TeamList_model.dart';

class AttendanceMonthFilter extends ConsumerStatefulWidget {
  const AttendanceMonthFilter({Key? key}) : super(key: key);

  @override
  _AttendanceMonthFilterState createState() => _AttendanceMonthFilterState();
}

class _AttendanceMonthFilterState extends ConsumerState<AttendanceMonthFilter> {

  @override
  int emp_id=0;
  int selectedmonth = 0;
  var selectedEmp;
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  late double _progress;

  List<DropdownMenuItem<int>> get menuMonthsItems{
    List<DropdownMenuItem<int>> menuMonths = [
      const  DropdownMenuItem(child:const Text("---select month---"),value:0),
      const DropdownMenuItem(child:const Text("JANUARY"),value: 1),
      const DropdownMenuItem(child:const Text("FEBURARY"),value: 2),
      const DropdownMenuItem(child:const Text("MARCH"),value: 3),
      const DropdownMenuItem(child:const Text("APRIL"),value: 4),
      const DropdownMenuItem(child:const Text("MAY"),value: 5),
      const DropdownMenuItem(child:const Text("JUNE"),value: 6),
      const DropdownMenuItem(child:const Text("JULY"),value: 7),
      const DropdownMenuItem(child:const Text("AUGUST"),value: 8),
      const DropdownMenuItem(child:const Text("SEPTEMBER"),value: 9),
      const DropdownMenuItem(child:const Text("OCTOBER"),value: 10),
      const DropdownMenuItem(child:const Text("NOVEMBER"),value: 11),
      const DropdownMenuItem(child:const Text("DECEMBER"),value: 12),
    ];
    return menuMonths;
  }
  int selectedyear = 0;
  List<DropdownMenuItem<int>> get menuYearItems{
    List<DropdownMenuItem<int>> menuYears = [
      const  DropdownMenuItem(child:const Text("---select year---"),value:0),
      const DropdownMenuItem(child:const Text("2022"),value: 2022),
      const DropdownMenuItem(child:const Text("2023"),value: 2023),
      const DropdownMenuItem(child:const Text("2024"),value: 2024),
      const DropdownMenuItem(child:const Text("2025"),value: 2025),
      const DropdownMenuItem(child:const Text("2026"),value: 2026),
      const DropdownMenuItem(child:const Text("2027"),value: 2027),
      const DropdownMenuItem(child:const Text("2028"),value: 2028),
      const DropdownMenuItem(child:const Text("2029"),value: 2029),
      const DropdownMenuItem(child:const Text("2030"),value: 2030),
    ];
    return menuYears;
  }
List<MonthwiseAttendanceClass> mwac=[];
  bool _listVisible = true;
  Future<void> _getfilterAttendance() async {
    EasyLoading.show(status: 'loading...');
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}dailyattendancerp.php"),
        body:{
          "emp_id":selectedEmp.toString(),
          "month":selectedmonth.toString(),
          "year":selectedyear.toString(),
        });
    print("This is $emp_id");
    if(response.statusCode == 200)
    {
      var mess = jsonDecode(response.body);
      var message = AttendanceMonthWiseResponse.fromJson(json.decode(response.body));
      EasyLoading.showToast("${mess['message']}",toastPosition:EasyLoadingToastPosition.bottom );
      EasyLoading.dismiss();
      setState((){
        mwac = message.userdata!;
      });

    }
    else
    {
      throw Exception(response.reasonPhrase);
    }
  }


  @override
  void initState()
  {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final _data = ref.watch(teamListDataProvider);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("FILTERED DATA",style: TextStyle(fontFamily: 'Alice',fontSize: 23)),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/officersviewal', (route) => false);
            },
          ),
        ),
        body: _data.when(data: (_data){
          List<TeamList> _teamList = _data.map((e) => e).toList();
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButtonFormField(
                      hint:const Text("--select employee--"),
                      items: _teamList.map((item) {
                        return DropdownMenuItem(
                          value: item.emp_id.toString(),
                          child: Text(item.emp_name.toString()),
                        );
                      }).toList(),
                      onChanged:(newVal) {
                        setState(() {
                          selectedEmp = newVal;
                          print(selectedEmp);
                        });
                      },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child:DropdownButton(
                        alignment: Alignment.centerRight,
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style:const TextStyle(color:Colors.green, fontSize: 20.0,fontWeight: FontWeight.w400,
                        ),
                        value: selectedmonth,
                        onChanged: (int? newValue){
                          setState(() {
                            selectedmonth = newValue!;
                          });
                        },
                        items: menuMonthsItems
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    child:DropdownButton(
                        alignment: Alignment.centerRight,
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style:const TextStyle(color:Colors.green, fontSize: 20.0,fontWeight: FontWeight.w400,
                        ),
                        value: selectedyear,
                        onChanged: (int? newValue){
                          setState(() {
                            selectedyear = newValue!;
                          });
                        },
                        items: menuYearItems
                    ),
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(onPressed: ()
                  {
                    if(_formKey.currentState!.validate())
                    {
                      _getfilterAttendance();
                    }
                    //
                  }, child:const Text("GET LIST"),style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade800
                  ),),
                  Visibility(
                    visible: _listVisible,
                    child: Container(
                      child: ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mwac.length,
                        itemBuilder: (context, index)
                        {
                          return Card(
                            color: Colors.orange.shade50,
                            child: ListTile(
                              title: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const  Text("S.NO: ",
                                        style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 15),),
                                      Text(" ${index+1}",
                                        style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                          fontSize: 15,),),
                                    ],
                                  ),
                                  const  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text("NAME : ",
                                        style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 15),),
                                      Text(" ${mwac[index].empName}",
                                        style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                          fontSize: 15,),),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text("STATUS : ",
                                        style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 15),),
                                      Column(
                                        children: [
                                          if(mwac[index].atid==1.toString())
                                            Text("${mwac[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.green.shade500,
                                                fontWeight: FontWeight.w500),)
                                          else if(mwac[index].atid==2.toString())
                                            Text("${mwac[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.red.shade500,
                                                fontWeight: FontWeight.w500),)
                                          else if(mwac[index].atid==3.toString())
                                              Text("${mwac[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.orange.shade500,
                                                  fontWeight: FontWeight.w500),)
                                            else
                                              Text("${mwac[index].atStatus.toUpperCase()}",style: TextStyle(color: Colors.blue.shade500,
                                                  fontWeight: FontWeight.w500),)
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      const Text("DATE : ",
                                        style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 15),),
                                      Expanded(
                                        child: Text("${mwac[index].atdate}",
                                          style:const  TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,
                                            fontSize: 15,),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
          error: (err, s) =>const Text(""),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(mwac.isNotEmpty)...[
              FloatingActionButton(
                onPressed: () {
                  printAttendance(mwac,selectedmonth,selectedyear );
                },
                child:const Text("PDF"),
                heroTag:const Text("AttenPDF"),
              ),
              SizedBox(height: 15,),
              FloatingActionButton(
                onPressed: () {
                  generateAttendanceCsv(mwac,selectedmonth,selectedyear );
                  _progress = 0;
                  _timer?.cancel();
                  _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (Timer timer) {
                        EasyLoading.showProgress(_progress,
                            status: '${(_progress * 100).toStringAsFixed(0)}%');
                        _progress += 0.03;
                        if (_progress >= 1) {
                          _timer?.cancel();
                          EasyLoading.showSuccess("Downloaded check your download");
                          EasyLoading.dismiss();
                        }
                      });
                },
                child:const Text("CSV"),
                heroTag:const Text("AttenCSV"),
              ),
            ]
            else...[const Text("")]
          ],
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
        Navigator.pushNamedAndRemoveUntil(context, '/officersviewal', (route) => false);
        return Future.value(false);
      },
    );
  }
}
