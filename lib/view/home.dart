import 'dart:convert';

import 'package:emp_report/model/Banner/Banner_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../Providers/BannerListProvider.dart';
import '../component/sideDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/constant.dart';

class Emp_Home extends ConsumerStatefulWidget {
  const Emp_Home({Key? key}) : super(key: key);
  @override
  _Emp_HomeState createState() => _Emp_HomeState();
}

class _Emp_HomeState extends ConsumerState<Emp_Home> {

  String _wish="",emp_name="";
  int emp_id=0;
  var  bancs;
  //Attendance Api Calling



  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_name = prefs.getString('emp_name') == null ? "" : prefs.getString('emp_name')!;
    emp_id = prefs.getInt('emp_id') == null ? 0 : prefs.getInt('emp_id')!;
    var response = await http.get(Uri.parse("${AppConstant.BASE_URL}topbanner.php"));
    print(response.body);
    var data = BannerResponse.fromJson(json.decode(response.body));
    setState(() {
      emp_name;
      emp_id;
      print("Employee Id =$emp_id");
      bancs = data.textmessage;
    });
  }

    greetingMessage() async{
    var timeNow = await DateTime.now().hour;
    if (timeNow <= 12) {
      return _wish='Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return _wish='Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return _wish='Good Evening';
    } else {
      return _wish='Good Night';
    }
  }

  @override
  void initState() {
    super.initState();
    greetingMessage();
    _fetchData();
  }



  @override
  Widget build(BuildContext context) {
    final bannerData= ref.watch(bannerListDataProvider);
    return Scaffold(
      drawer: SideDrawer(),
        appBar: AppBar(
          title: const Text("RASAYA EMPLOYEE",style: const TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.green[800],
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                child: Text("${bancs ??"-"}",style: const TextStyle(fontSize: 20,fontFamily: 'DancingScript',
                fontWeight: FontWeight.w600),),
              ),
              const SizedBox(height: 10,),

              Container(
                padding: EdgeInsets.all(5),
                height: 210,
                child: bannerData.when(data:(bannerData){
                  List<Banner_class> bn = bannerData.map((e) => e).toList();
                    return ImageSlideshow(
                    width: double.infinity,
                    height: 200,
                    initialPage: 0,
                    indicatorColor: Colors.blue,
                    indicatorBackgroundColor: Colors.grey,
                    children: bn.map((e) =>Image.network(
                      'https://reporting.rasayamultiwings.com/api/uploadphoto/bannerimage/${e.bannerImage}',
                      fit: BoxFit.cover,
                    ), ).toList(),
                    onPageChanged: (value) {
                      print('Page changed: $value');

                    },
                    autoPlayInterval: 3000,
                    isLoop: true,
                   );

                },
                    error: (err,s){return Text("");},
                    loading: (){}
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hi, ",style: const TextStyle(fontSize: 25),),
                    Text("$emp_name",style: const TextStyle(fontSize: 25,fontFamily: 'DancingScript',),),
                  ],
                ),
              ),
              Container(
                child: Text("$_wish",style: const TextStyle(fontSize: 20,fontFamily: 'Alkalami'),),
              ),
              Container(
                child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                primary: false,
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/attendancelist', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:GridTile(
                            child: Image.asset(
                              "images/biometrices.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child: const Text("Attendance",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/dailytaskreport', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:GridTile(
                            child: Image.asset(
                              "images/daily.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child:const Text("Daily Work",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:GridTile(
                            child: Image.asset(
                              "images/list.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child:const Text("Work Report List",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/salary', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade500,
                                Colors.lime.shade500,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child:GridTile(
                              child: Image.asset(
                                "images/comment1.png",height: 50,
                              ),
                              footer: Container(
                                color: Colors.black87,
                                alignment: Alignment.center,
                                child: const Text("Officer Comment",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              )
                          ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/market', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: GridTile(
                            child: Image.asset(
                              "images/mkt.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child:const Text("Market Survey",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/surveylist', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                             ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:    GridTile(
                            child: Image.asset(
                              "images/mktList.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child: const Text("Survey List",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                           )
                         ),
                       ),
                     ),
                   ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(context, '/payslip', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:    GridTile(
                            child: Image.asset(
                              "images/salary1.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child: const Text("Payroll",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                        Navigator.pushNamedAndRemoveUntil(context, '/leave', (route) => false);
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade500,
                              Colors.lime.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:    GridTile(
                            child: Image.asset(
                              "images/leave.png",height: 80,
                            ),
                            footer: Container(
                              color: Colors.black87,
                              alignment: Alignment.center,
                              child: const Text("Leave",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ),
                 ],
                ),
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
          /*Container(
            color: Colors.red.shade500,
            child:const Text("Oops! you are offline :(",style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black45),textAlign: TextAlign.center,),
          );*/
        },
      ),
    );
  }
}
