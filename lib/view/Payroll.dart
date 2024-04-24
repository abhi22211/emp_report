import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../model/Salary_modal.dart';
import '../utils/constant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Payroll extends ConsumerStatefulWidget {
  const Payroll({Key? key}) : super(key: key);

  @override
  _PayrollState createState() => _PayrollState();
}

class _PayrollState extends ConsumerState<Payroll> {

  DateTime? _selected;
  String usertype='';
//check user type
  _checkOfficer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype= prefs.getString('usertype')==null ? "":prefs.getString('usertype')!;
  }


  //Cumulative PaySlip
  List<Salary_Class> esalCumm=[];
  int emp_id=0;
  Future<void> _showSalCumm() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emp_id= prefs.getInt('emp_id')==null ? 0 : prefs.getInt('emp_id')!;
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}salary_slip.php"),
          body:{
            "emp_id": emp_id.toString(),
            "month":DateFormat().add_M().format(_selected!),
            "year":DateFormat().add_y().format(_selected!),
          });
      print(response.body);
      var data = SalaryResponse.fromJson(json.decode(response.body));
      print("this is data${data}");
      setState(() {
        esalCumm = data.userdata!;
        print(esalCumm);
      });
    }
    catch (error) {
      throw(error);
    }
  }

 //Salary Slip Monthly
  List<Salary_Class> esal=[];
  Future<void> _showSal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
       emp_id= prefs.getInt('emp_id')==null ? 0 : prefs.getInt('emp_id')!;
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}salary_slip.php"),
          body:{
             "emp_id": emp_id.toString(),
            //"emp_id": 2.toString(),
            "month":DateTime.now().month.toString(),
            "year":DateTime.now().year.toString(),
          });
      print(response.body);
      var data = SalaryResponse.fromJson(json.decode(response.body));
      print("this is data${data}");
      setState(() {
        esal = data.userdata!;
        print(esal);
      });
    }
    catch (error) {
      throw(error);
    }
  }

  //Personal Detail
  String emp_code="",emp_name="",doj="";
  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_code=  prefs.getString('emp_code') == null ? "" : prefs.getString('emp_code')!;
    emp_name=  prefs.getString('emp_name') == null ? "" : prefs.getString('emp_name')!;
    doj=  prefs.getString('doj') == null ? "" : prefs.getString('doj')!;
    setState(() {
      emp_code;
      emp_name;
      doj;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkOfficer();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 100)/2;
    final double itemWidth =size.width/2;
    final double itemHeight1 = (size.height - kToolbarHeight - 1)/1;
    final double itemWidth1 =size.width/5;
    return WillPopScope(
      onWillPop: (){
        if( usertype == "emp".toString())
        {
          print("Login as employee");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
        }
        else
        {
          print("Login as reporting officer");
          print(usertype);
          Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          title: const Text("PaySlips",style: TextStyle(fontFamily: 'Alice',fontSize: 23),),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              if( usertype == "emp".toString())
              {
                print("Login as employee");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
              }
              else
              {
                print("Login as reporting officer");
                print(usertype);
                Navigator.pushNamedAndRemoveUntil(context, '/reporthome', (r) => false);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(),));
              }
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: (itemHeight/itemWidth),
                    crossAxisSpacing: 10,
                    primary: false,
                    shrinkWrap: true,
                    children: [
                     Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              ),
                              child:GridTile(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset("images/currentmonthsalary.png",height: 80,),
                                  ),
                                  footer: Container(
                                    alignment: Alignment.center,
                                    child: const Text("Monthly Payslip",style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                                  ),
                              ),
                          ),
                     Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:GridTile(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  "images/salary1.png",height: 80,
                                ),
                              ),
                              footer: Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Container(
                                  //color: Colors.black87,
                                  alignment: Alignment.center,
                                  child: const Text("Cumulative Payslip",style:  TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
                                ),
                              )
                           ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: (itemHeight1/itemWidth1),
                    crossAxisSpacing: 10,
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:ElevatedButton(onPressed: (){
                          _showSal();
                          //print(DateTime.now().month);
                          //print(DateTime.now().year);
                        },child:const Text("view"),style: ElevatedButton.styleFrom(primary: Colors.green.shade300),)
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:ElevatedButton(onPressed: (){
                            _onPressed(context: context);
                          },child:const Text("view"),style: ElevatedButton.styleFrom(primary: Colors.green.shade300),)
                      ),
                    ],
                  ),
                ),
               const SizedBox(height: 50,),
                Column(
                  children: [
                    if(esal.isEmpty)...[
                      Container(
                        alignment: Alignment.topLeft,
                          child: const Text(" Current Month: No Record Found",style: TextStyle(fontWeight: FontWeight.w500),)
                      )
                    ]
                    else...[
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: esal.length,
                          itemBuilder: (_, index)
                          {
                            return Container(
                              child: Row(
                                children: [
                                  const Text(" Current Month: ",style: TextStyle(fontWeight: FontWeight.w500),),
                                  IconButton(onPressed: ()async{
                                    await launch("https://reporting.rasayamultiwings.com/${esal[index].salarySlip}");
                                  }, icon: Icon(Icons.download)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
                const Divider(color: Colors.black,),

                Column(
                  children: [
                    if(esalCumm.isEmpty)...[
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(" Custom Month: No Record Found",style: TextStyle(fontWeight: FontWeight.w500),),)
                    ]
                    else...[
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: esalCumm.length,
                          itemBuilder: (_, i)
                          {
                            return Container(
                              child: Row(
                                children: [
                                  Text("Custom Month: ${esalCumm[i].months}",style: TextStyle(fontWeight: FontWeight.w500),),
                                  IconButton(onPressed: ()async{
                                    await launch("https://reporting.rasayamultiwings.com/${esalCumm[i].salarySlip}");
                                  }, icon: const Icon(Icons.download)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 20,),
                ExpansionTile(
                  backgroundColor: Colors.white,
                  initiallyExpanded: true,
                  title:  Text("Personal Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: Colors.green.shade700),),
                  children: [
                    ListTile(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Employee Name",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                              Container(
                                  padding:const EdgeInsets.only(left: 50),
                                  child: const Text("Employee Code",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${emp_name}",style: TextStyle(fontWeight: FontWeight.w500),),
                              const SizedBox(width: 40,),
                              Text("${emp_code}",style: TextStyle(fontWeight: FontWeight.w500),),
                            ],
                          ),
                          const Divider(color: Colors.black,),
                          const Row(
                            children: [
                               Text("Company",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                            ],
                          ),
                          const Row(
                            children: [
                               Text("Rasaya Multiwings Pvt. Ltd.",style: TextStyle(fontWeight: FontWeight.w500),),
                            ],
                          ),
                          const Divider(color: Colors.black,),
                          const Row(
                            children: [
                              Text("Joining Date",style: TextStyle(color:Colors.grey,fontWeight: FontWeight.w400),),
                            ],
                          ),
                          Row(
                            children: [
                              Text(doj,style: TextStyle(fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
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

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2050),
      locale: localeObj,
    );
    if (selected != null) {
      setState(() {
        _selected = selected;
        _showSalCumm();
      });
    }
  }

}
