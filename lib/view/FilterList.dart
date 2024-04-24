import 'dart:async';
import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:emp_report/view/EditWork.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../CSV/WorkListCSV.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../PDF/WorkListPdf.dart';
import '../model/WorkList_model.dart';

class Filter_List extends ConsumerStatefulWidget {
  const Filter_List({Key? key}) : super(key: key);

  @override
  _Filter_ListState createState() => _Filter_ListState();
}

class _Filter_ListState extends ConsumerState<Filter_List> {

  @override
  int emp_id=0, startlimit=0,endlimit=10;
  List<EmpWorkClass> empmonthList=[];
  ScrollController sc = ScrollController();
  bool ispageload= false,_listVisible=true;
  String emp_name="",work_report_id="",work_detail="",report_date="";
  TextEditingController editedtask = TextEditingController();
  int selectedmonth = 0;
  String usertype='',thispage="filterlist";
  RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
  Timer? _timer;
  late double _progress;
  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
    emp_name= prefs.getString('emp_name')==null ? "":prefs.getString('emp_name')!;
  }

  List<DropdownMenuItem<int>> get menuMonthsItems{
    List<DropdownMenuItem<int>> menuMonths = [
      const DropdownMenuItem(child:const Text("---select month---"),value:0),
      const DropdownMenuItem(child:const Text("JANUARY"),value: 1),
      const  DropdownMenuItem(child:const Text("FEBURARY"),value: 2),
      const DropdownMenuItem(child:const Text("MARCH"),value: 3),
      const DropdownMenuItem(child:const Text("APRIL"),value: 4),
      const  DropdownMenuItem(child:const Text("MAY"),value: 5),
      const  DropdownMenuItem(child:const Text("JUNE"),value: 6),
      const DropdownMenuItem(child:const Text("JULY"),value: 7),
      const  DropdownMenuItem(child:const Text("AUGUST"),value: 8),
      const  DropdownMenuItem(child:const Text("SEPTEMBER"),value: 9),
      const  DropdownMenuItem(child:const Text("OCTOBER"),value: 10),
      const DropdownMenuItem(child:const Text("NOVEMBER"),value: 11),
      const DropdownMenuItem(child:const Text("DECEMBER"),value: 12),
    ];
    return menuMonths;
  }
  int selectedyear = 0;
  List<DropdownMenuItem<int>> get menuYearItems{
    List<DropdownMenuItem<int>> menuYears = [
      const DropdownMenuItem(child:const Text("---select year---"),value:0),
      const  DropdownMenuItem(child:const Text("2022"),value: 2022),
      const  DropdownMenuItem(child:const Text("2023"),value: 2023),
      const  DropdownMenuItem(child:const Text("2024"),value: 2024),
      const  DropdownMenuItem(child:const Text("2025"),value: 2025),
      const DropdownMenuItem(child:const Text("2026"),value: 2026),
      const  DropdownMenuItem(child:const Text("2027"),value: 2027),
      const  DropdownMenuItem(child:const Text("2028"),value: 2028),
      const  DropdownMenuItem(child:const Text("2029"),value: 2029),
      const DropdownMenuItem(child:const Text("2030"),value: 2030),
    ];
    return menuYears;
  }

  _getmonthList() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
      EasyLoading.show(status: 'loading...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}archive_reporting_list.php"),
          body:{
            "emp_id":emp_id.toString(),
            "from_month":selectedmonth.toString(),
            "from_year":selectedyear.toString(),
          });
      var mess = jsonDecode(response.body);
      var message = EmpWorkListResponse.fromJson(json.decode(response.body));
      EasyLoading.showToast("${mess['message']}",toastPosition:EasyLoadingToastPosition.bottom );
      EasyLoading.dismiss();
      setState(() {
        empmonthList = message.user;
      });
      print("Employee Id "+emp_id.toString());
      print("from_month "+selectedmonth.toString());
      print("from_year"+selectedyear.toString());
      print("$mess");
    }
    catch(e)
    {
      print(e);
    }
  }



  @override
  void initState()
  {
    _checkOfficer();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("FILTERED DATA",style: TextStyle(fontFamily: 'Alice',fontSize: 23)),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);

              },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
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
                        const  SizedBox(height: 20,),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(onPressed: (){
                            _getmonthList();
                            setState(() {
                            });
                          }, child:const Text("GET LIST"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[800], // background
                            ),
                          ),
                        ),
                        const  SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _listVisible,
                    child: Container(
                      child: ListView.builder(
                        controller: sc,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: empmonthList.length,
                        itemBuilder: (context, index)
                        {
                          return Card(
                            color: Colors.indigo.shade200,
                            child: ListTile(
                              title: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: empmonthList[index].workDetail.replaceAll('&nbsp;', '').replaceAll(exp, ''),style: TextStyle(fontFamily: 'DancingScript',fontSize: 20,color: Colors.black),
                                    //controller: showMsg,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(width: 1.5)
                                        ),
                                        fillColor: Colors.white,
                                        filled: true
                                    ),
                                    maxLines: 5,
                                  ),

                                  Row(
                                    children: [

                                      const Text("Date:",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15),),

                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(" ${empmonthList[index].reportDate.day}/${empmonthList[index].reportDate.month}/${empmonthList[index].reportDate.year}",
                                          style:const TextStyle(fontWeight: FontWeight.w400,color: Colors.indigo,
                                            fontSize: 15,),),
                                      ),
                                      const SizedBox(width: 30,),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if( empmonthList[index].reportDate.isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
                                                empmonthList[index].reportDate.isBefore(DateTime.now()))
                                              Container(
                                                height: 40,
                                                width: 100,
                                                color: Colors.green,
                                                child: Row(
                                                  children: [
                                                    const  Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text("Edit"),
                                                    ),
                                                    IconButton(onPressed: (){
                                                      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                          (context) => EditWork(empmonthList[index].workReportId,
                                                              empmonthList[index].workDetail,empmonthList[index].reportDate,thispage)), (route) => false);
                                                    },icon:const Icon(Icons.edit,color: Colors.black,),),
                                                  ],
                                                ),
                                              )
                                            else
                                              Container(
                                                height: 40,
                                                width: 100,
                                                color: Colors.red,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child:const Text("View"),
                                                    ),
                                                    IconButton(onPressed: (){
                                                      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder:
                                                          (context) => EditWork(empmonthList[index].workReportId,
                                                              empmonthList[index].workDetail,empmonthList[index].reportDate,thispage)), (route) => false);
                                                    },icon:const Icon(Icons.not_interested,color: Colors.black,)),
                                                  ],
                                                ),
                                              )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 5,),
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
          ),
        ),
        floatingActionButton:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(empmonthList.isNotEmpty)
              ...[
                FloatingActionButton(
                  onPressed: () {
                    printWorkList(emp_name,empmonthList,selectedmonth,selectedyear );
                  },
                  child:const Text("PDF"),
                  heroTag:const Text("emppdf"),
                ),
                const SizedBox(height: 15,),
                FloatingActionButton(
                  onPressed: () {
                    getWorkListCsv(emp_name,empmonthList,selectedmonth,selectedyear );
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
                  heroTag:const Text("empcsv"),
                ),
              ]
            else
              ...[
                const Text(""),
              ]
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
       Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);
        return Future.value(false);
      },
    );
  }
}
