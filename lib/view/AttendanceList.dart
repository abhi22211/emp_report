import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../Providers/AttendanceCountProvider.dart';
import '../model/CheckInCheckOut_Modal.dart';
import '../model/Coordinate_modal.dart';
import '../model/MonthwiseAttendance_model.dart';
import '../utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendaceList extends ConsumerStatefulWidget {
  const AttendaceList({Key? key}) : super(key: key);

  @override
  _AttendaceListState createState() => _AttendaceListState();
}

class _AttendaceListState extends ConsumerState<AttendaceList> {

  String workloaction = "";
  var chkIn,chkOut;
  Timer? _timer;

  //Attendance Api Calling
  List<CheckInCheckOut_Class>  stat=[];
  Future<void> _checkStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}checkdailypresent.php"),
      body: {
        "emp_id":emp_id.toString(),
        "atdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      });
      print(response.body);
      var data = CheckInCheckOutResponse.fromJson(json.decode(response.body));
      print("this is data${data}");
      setState(() {
        stat = data.user!;
        stat.forEach((element) {
           chkIn = element.intime;
           chkOut = element.outtime;
        });
      });
      print(cc);
      print("Check In Time: "+chkIn);
      print("Check Out Time: "+chkOut);
    }
    catch (error) {
      throw(error);
    }
  }

  //Api Calling
  List<Coordinate_Class>   cc=[];
  Future<void> _coordinateList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      workloaction= prefs.getString('workloaction')==null ? "":prefs.getString('workloaction')!;
      var response = await http.get(Uri.parse("${AppConstant.BASE_URL}coordinateatt.php"));
      var data = AttendanceCoordinate.fromJson(json.decode(response.body));
      setState(() {
        cc = data.data!;
      });
    }
    catch (error) {
      throw(error);
    }
  }

    checkCorrdinates() {
     cc.forEach((element) {
      var apiworkLoc = element.loaction;
      var apiLat = element.lat;
      var apiLong = element.lang;
      var mobLong = double.parse((_currentPosition?.longitude.toStringAsFixed(4)==null?"0.0":_currentPosition?.longitude.toStringAsFixed(4))!);
      var mobLat = double.parse
        (
          (_currentPosition?.latitude.toStringAsFixed(4)==null?"0.0":_currentPosition?.latitude.toStringAsFixed(4))!);

      if(workloaction == apiworkLoc.toString())
        {
          double distance = Geolocator.distanceBetween(double.parse(apiLat!), double.parse(apiLong!), mobLat, mobLong);
          if(distance <= 1000)
          {
            showAlertDialogIn(distance);
            //_markAttendance();
          }
          else
          {
            EasyLoading.showToast("Sorry you are not working area",toastPosition: EasyLoadingToastPosition.center);
            print("Coordinates didnot matched");
            print("API Lat:$apiLat Long:$apiLong");
            print("Mobile Lat:$mobLat Long:$mobLong");
            print("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
            print("${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
          }
        }
      else{
        print("Not Matched");
        print(workloaction);
        print(apiworkLoc);
      }
    });
  }

  //CheckIn
  int? emp_id;
  var rep_offer_id;

   _markAttendance() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    rep_offer_id= prefs.getString('rep_offer_id')==null ? 0:prefs.getString('rep_offer_id');
    //emp_name= prefs.getString('emp_name')==null ? "":prefs.getString('emp_name')!;
    try{
      EasyLoading.show(status: 'punching...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}addattendence.php"),
          body:{
            "emp_id":emp_id.toString(),
            "r_id":rep_offer_id,
            "status": 1.toString(),
            "atdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
            "intime":"${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
          });
      print(response.body);
      //var result = jsonDecode(response.body)['user'];
      if(jsonDecode(response.body)['status']==1)
        {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
          EasyLoading.dismiss();
        }
      else
        {
          EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
          EasyLoading.dismiss();
        }
      print("emp_id $emp_id");
      print("r_id $rep_offer_id");
      print("status 1.toString()");
      print("atdate ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
      print("intime ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
    }
    catch(e)
    {
      print(e);
    }
  }

  //CheckOut
  checkCorrdinatesOut(){
    cc.forEach((element) {
      var apiworkLoc = element.loaction;
      var apiLat = element.lat;
      var apiLong = element.lang;
      var mobLong = double.parse((_currentPosition?.longitude.toStringAsFixed(4)==null?"0.0":_currentPosition?.longitude.toStringAsFixed(4))!);
      var mobLat = double.parse((_currentPosition?.latitude.toStringAsFixed(4)==null?"0.0":_currentPosition?.latitude.toStringAsFixed(4))!);

      if(workloaction == apiworkLoc.toString()) {
        print("matched");
        print(workloaction);
        print(apiworkLoc);
        double distance = Geolocator.distanceBetween(double.parse(apiLat!), double.parse(apiLong!), mobLat, mobLong);
        print("Distance meter: "+distance.toString());
        if(distance <= 1000)
        {
          //_markAttendanceOut();
          showAlertDialogOut(distance);
          print("Coordinates matched");
          print("API Lat:$apiLat Long:$apiLong");
          print("Mobile Lat:$mobLat Long:$mobLong");
          print("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
          print("${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
        }
        else
        {
          EasyLoading.showToast("Sorry you are not working area",toastPosition: EasyLoadingToastPosition.center);
          print("Coordinates didnot matched");
          print("API Lat:$apiLat Long:$apiLong");
          print("Mobile Lat:$mobLat Long:$mobLong");
          print("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
          print("${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
        }
      }
      else
        {
          print("not matched");
          print(workloaction);
          print(apiworkLoc);
        }
    });
  }

  _markAttendanceOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id');
    try{
      EasyLoading.show(status: 'punching...');
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}outattendence.php"),
          body:{
            "emp_id":emp_id.toString(),
            "atdate":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
            "outtime":"${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
          });
      print(response.body);
      if(jsonDecode(response.body)['status']==1)
      {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
        EasyLoading.dismiss();
      }
      else
      {
        EasyLoading.showToast('${jsonDecode(response.body)['message']}',toastPosition: EasyLoadingToastPosition.bottom);
        EasyLoading.dismiss();
      }
      print("emp_id $emp_id");
      print("atdate ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
      print("outtime ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
    }
    catch(e)
    {
      print(e);
    }
  }


@override
  void initState() {
  _coordinateList();
  _checkStatus();
  _getCurrentPosition();
  _getCurrentPositionOut();
  _getPreAbsAttendance();
  EasyLoading.addStatusCallback((status) {
    print('EasyLoading Status $status');
    if (status == EasyLoadingStatus.dismiss) {
      _timer?.cancel();
    }
  });
    super.initState();
  }

//Location coordinates finding
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showToast('Location services are disabled. Please enable the services',toastPosition:EasyLoadingToastPosition.center);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      EasyLoading.showToast('Location permissions are denied',toastPosition:EasyLoadingToastPosition.center);
      return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
    EasyLoading.showToast('Location permissions are permanently denied, we cannot request permissions.',toastPosition:EasyLoadingToastPosition.center);
    return false;
    }
    checkCorrdinates();
    return true;
  }

  Future<bool> _handleLocationPermissionOut() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showToast('Location services are disabled. Please enable the services',toastPosition:EasyLoadingToastPosition.center);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showToast('Location permissions are denied',toastPosition:EasyLoadingToastPosition.center);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      EasyLoading.showToast('Location permissions are permanently denied, we cannot request permissions.',toastPosition:EasyLoadingToastPosition.center);
      return false;
    }
    checkCorrdinatesOut();
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPositionOut() async {
    final hasPermission = await _handleLocationPermissionOut();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude)
      .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

   //Calender
  var chkAyear,chkAmnth,chkAday;
  var pre,abs,leav,holi;
  List<MonthwiseAttendanceClass> _mwac=[];
  //DateTime? dateObj;
  List<DateTime> dateObj = [];
  List<DateTime> presentList = <DateTime>[];
  List<DateTime> absentList = <DateTime>[];
  List<DateTime> leaveList = <DateTime>[];
  List<DateTime> holiList = <DateTime>[];
  Future<void> _getPreAbsAttendance() async {
   // EasyLoading.show(status: 'loading...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id') == null ? 0:prefs.getInt('emp_id')!;
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}dailyattendancerp.php"),
        body:{
          "emp_id":emp_id.toString(),
          "month":DateTime.now().month.toString(),
          "year":DateTime.now().year.toString(),
        });
    print("This is $emp_id");
    if(response.statusCode == 200)
    {
      var mess = jsonDecode(response.body);
      var message = AttendanceMonthWiseResponse.fromJson(json.decode(response.body));
      EasyLoading.showToast("${mess['message']}",toastPosition:EasyLoadingToastPosition.bottom );
      EasyLoading.dismiss();
      setState((){
        _mwac = message.userdata!;
            for(var i=0; i < _mwac.length;i++){
              if(_mwac[i].atid == '1'){
                presentList.add(DateTime.parse(_mwac[i].atdate));
              } else if (_mwac[i].atid == '2'){
                absentList.add(DateTime.parse(_mwac[i].atdate));
                 chkAyear= DateTime.parse(_mwac[i].atdate).year;
                 chkAmnth= DateTime.parse(_mwac[i].atdate).month;
                 chkAday= DateTime.parse(_mwac[i].atdate).day;

              }else if (_mwac[i].atid == '3'){
                leaveList.add(DateTime.parse(_mwac[i].atdate));
              } else{
                holiList.add(DateTime.parse(_mwac[i].atdate));
              }
            }

        print("Test date list");
        print(chkAyear);
        print(chkAmnth);
        print(chkAday);
        print(presentList);
        print(absentList);
        print(leaveList);
        print(holiList);
      });

    }
    else
    {
      throw Exception(response.reasonPhrase);
    }
  }




  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(attenCountDataProvider);
    //calender
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.green.shade50,
        appBar: AppBar(
          title:const Text("ATTENDANCE CURRENT MONTH",style: TextStyle(fontSize: 18),),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async=> await ref.refresh(attenCountDataProvider),
          child: _data.when(data:(_data){
          return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                   children: [
                     Container(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        primary: false,
                        shrinkWrap: true,
                        children: [
                          GestureDetector(
                            onTap: (){
                              //Navigator.pushNamedAndRemoveUntil(context, '/attendance', (route) => false);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade500,
                                        Colors.lightGreen.shade500,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const  Text("Present",style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                      Text("${_data.ttlpresent}",style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                    ],
                                  ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              //Navigator.pushNamedAndRemoveUntil(context, '/dailytaskreport', (route) => false);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.pink.shade500,
                                        Colors.red.shade500,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Image.asset("images/daily.png",height: 100,),
                                      const Text("Absent",style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                      Text("${_data.ttlabsent}",style:const TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                    ],
                                 )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              //Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade500,
                                        Colors.yellow.shade500,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const  Text("Holiday",style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                      Text("${_data.ttlholiyday}",style:const TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                    ],
                                  )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              //Navigator.pushNamedAndRemoveUntil(context, '/worklist', (route) => false);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade500,
                                        Colors.amber.shade500,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Image.asset("images/list.png",height: 100,),
                                      const  Text("Leave",style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                      Text("${_data.ttlleave}",style:const TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.w500,fontFamily: 'Alkalami'),),
                                    ],
                                  )
                                ),
                              ),
                             ),

                           ],
                          ),
                        ),
                     const  SizedBox(height: 20,),
                     Container(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Column(
                             children: [
                               if(stat.isEmpty)...
                               [
                                 Card(
                                   elevation: 5,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(50),
                                   ),
                                   child: GestureDetector(
                                     onTap: (){
                                       //checkCorrdinates();
                                       _handleLocationPermission();
                                     },
                                     child: Container(
                                       child: Image.asset('images/punch.png',height: 90,width: 90,),
                                     ),
                                   ),
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     const  Text("Punch In: ",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 15),),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     const  Text("Date: ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15),),
                                     Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                       style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                   ],
                                 ),
                               ]
                               else...
                               [
                                 if(chkIn == "")...[
                                   Card(
                                     elevation: 5,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(50),
                                     ),
                                     child: GestureDetector(
                                       onTap: (){
                                         //checkCorrdinates();
                                         _handleLocationPermission();
                                       },
                                       child: Container(
                                         child: Image.asset('images/punch.png',height: 90,width: 90,),
                                       ),
                                     ),
                                   ),
                                   const Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                         Text("Punch In: ",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 15),),
                                     ],
                                   ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const  Text("Date: ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15),),
                                       Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                         style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                     ],
                                   ),
                                 ]
                                 else if(chkOut == "")...[
                                   Card(
                                     elevation: 5,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(50),
                                     ),
                                     child: GestureDetector(
                                       onTap: (){
                                         _handleLocationPermissionOut();
                                         //checkCorrdinatesOut();
                                       },
                                       child: Container(
                                         child: Image.asset('images/punch.png',height: 90,width: 90,),
                                       ),
                                     ),
                                   ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const Text("Punch In: ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 15),),
                                       Text(" $chkIn",style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                                     ],
                                   ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const  Text("Punch Out: ",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 15),),
                                       const  Text(" ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                                     ],
                                   ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                       const  Text("Date: ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15),),
                                       Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                         style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                     ],
                                   ),
                                 ]
                                 else...[
                                     GestureDetector(
                                       onTap: (){
                                         EasyLoading.showToast('You have already punched for today',toastPosition: EasyLoadingToastPosition.bottom);
                                         print("Already punched");
                                       },
                                       child: Card(
                                         elevation: 5,
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(50),
                                         ),
                                         child: Container(
                                           child: Image.asset('images/punch.png',height: 90,width: 90,),
                                         ),
                                       ),
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         const  Text("Punch In: ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 15),),
                                         Text(" $chkIn",style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                                       ],
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         const Text("Punch Out: ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 15),),
                                         Text(" $chkOut",style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                                       ],
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         const  Text("Date: ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15),),
                                         Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                         style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                       ],
                                     ),
                                   ]
                               ]
                             ],
                           ),
                         ],
                       ),
                     ),

                     const  SizedBox(height: 30,),

                     Container(
                       child: SfCalendar(
                        view: CalendarView.month,
                        blackoutDates: <DateTime>[
                          for(var j=0; j < _mwac.length;j++)
                            if(_mwac[j].atid == '1')
                         DateTime(DateTime.parse(_mwac[j].atdate).year,
                         DateTime.parse(_mwac[j].atdate).month,
                         DateTime.parse(_mwac[j].atdate).day),
                        ],
                        blackoutDatesTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color:Colors.green.shade700,
                        fontFamily: 'Arial',
                        ),
                       ),
                     ),
                   ],
                 ),
              );
            },
            error: (err, s) => Text(""),
            loading: () => const Center(child: CircularProgressIndicator(),),
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
       ),
      onWillPop: (){
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        return Future.value(false);
      },
    );
  }

  showAlertDialogIn(distance) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child:const Text("Cancel"),
      onPressed:  () {
        //EasyLoading.showToast("Go to your exact location",toastPosition: EasyLoadingToastPosition.bottom);
        Navigator.pop(context);
        },
    );
    Widget continueButton = TextButton(
      child:const Text("Continue"),
      onPressed:  () {
        _markAttendance();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:const Text("Confirm"),
      content: Text('Your distance is $distance meter from main location. Are you sure you want to punch?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogOut(distance) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child:const Text("Cancel"),
      onPressed:  () {
        //EasyLoading.showToast("Go to your exact location",toastPosition: EasyLoadingToastPosition.bottom);
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child:const Text("Continue"),
      onPressed:  () {_markAttendanceOut();},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:const Text("Confirm"),
      content: Text('Your distance is $distance meter from main location. Are you sure you want to punch?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
     showDialog(
      context: context,
      builder: (BuildContext context) {
      return alert;
      },
    );
  }
}
