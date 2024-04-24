import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Connectivity/ConnectivitystatusNotifier.dart';
import '../model/Address_model/Assembly -model.dart';
import '../model/Address_model/District_model.dart';
import '../model/Address_model/Panchayat_model.dart';
import '../model/Address_model/State_model.dart';
import '../model/Address_model/Ward_model.dart';
import '../utils/constant.dart';


class MarketSurvey extends ConsumerStatefulWidget{
  const MarketSurvey({Key? key}) : super(key: key);
  @override
  _MarketSurveyState createState() => _MarketSurveyState();
}

class _MarketSurveyState extends ConsumerState<MarketSurvey> {

  var selectedState;var selectedDistrict,selectedAssembly,selectedPanchayat,selectedWard;
  TextEditingController _clientName = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPressed= false;

  List<StateClass> _state=[];
  String? _character = "1";
  String? _character1 ="1";
  bool  _showDiscription =false;
  Future<void> _getState() async{
    var url ="${AppConstant.BASE_URL}statelist.php";
    try
    {
      var response = await http.get(Uri.parse(url));
      print(response);
      var data = StateResponse.fromJson(json.decode(response.body));
      print(data);
      setState((){
        _state = data.user;
        print(_state);
       // _getDistrict(selectedState);
      });
    }
    catch(error)
    {
      throw(error);
    }
  }
  List<DistrictClass> _district=[];
  Future<void> _getDistrict(_stateId) async{
    try{
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}citylist.php"),
          body:{
            "state_id":_stateId.toString(),
          });
      print(response.body);
      var data = DistrictResponse.fromJson(json.decode(response.body));
      print("state_id $_stateId");
      setState(() {
        _district = data.user;
      });
    }
    catch(e)
    {
      print(e);
    }
  }
  List<AssemblyClass> _assem=[];
  Future<void> _getAssembly(_districtId) async{
    try{
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}assambleylist.php"),
          body:{
            "district_id":_districtId.toString(),
          });
      print(response.body);
      var data = AssemblyResponse.fromJson(json.decode(response.body));
      print("district id: $_districtId");
      setState(() {
        _assem = data.user;
      });
    }
    catch(e)
    {
      print(e);
    }
  }
  List<PanchayatClass> _pancha=[];
  Future<void> _getPanchayat(_assemblyId) async{
    try{
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}panchayatlist.php"),
          body:{
            "assemblyid":_assemblyId.toString(),
          });
      print(response.body);
      var data = PanchayatResponse.fromJson(json.decode(response.body));
      print("assemblyid: $_assemblyId");
      setState(() {
        _pancha = data.user;
      });
    }
    catch(e)
    {
      print(e);
    }
  }
  List<WardClass> _war=[];
  Future<void> _getWard(_panchayatId) async{
    try{
      var response = await http.post(Uri.parse("${AppConstant.BASE_URL}wardlist.php"),
          body:{
            "panchhayat_id":_panchayatId.toString(),
          });
      print(response.body);
      var data = WardResponse.fromJson(json.decode(response.body));
      print("panchhayat_id: $_panchayatId");
      setState(() {
        _war = data.user;
      });
    }
    catch(e)
    {
      print(e);
    }
  }

  _checkYesNO()
  {
    if(_character == "0".toString())
    {
      setState(() {
        _showDiscription=false;
      });
      print(_showDiscription);
    }
    else
    {
      setState(() {
        _showDiscription = true;
      });
      print(_showDiscription);
    }
  }

 int emp_id=0;
  uploadImage()async{
    setState((){
      _isPressed = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    String givenMob=_mobileNumber.text;
    if(_image == null )
      {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Please upload an image',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        );
        setState((){
          _isPressed = false;
        });
      }
    else
      {
        var dio = Dio();
        String fileName = _image!.path.split('/').last;
        //final file = File(image!.path);
        FormData formData = FormData();
        formData.fields.add(MapEntry("emp_id", emp_id.toString(),));
        formData.fields.add(MapEntry("state_id", selectedState.toString()));
        formData.fields.add(MapEntry("distrct_id", selectedDistrict.toString()));
        formData.fields.add(MapEntry("assembly_id", selectedAssembly.toString()));
        formData.fields.add(MapEntry("panchyat_id", selectedPanchayat.toString()));
        formData.fields.add(MapEntry("ward_id", selectedWard.toString()));
        formData.fields.add(MapEntry("client_name", _clientName.text.toString()));
        formData.fields.add(MapEntry("client_mobile", givenMob));
        formData.fields.add(MapEntry("know_rasaya", _character1.toString()));
        formData.fields.add(MapEntry("is_app", _character.toString()));
        formData.fields.add(MapEntry("description", _description.text.toString()));
        formData.files.add(MapEntry("image1", await MultipartFile.fromFile(_image!.path, filename:fileName)));
        var response = await dio.post("${AppConstant.BASE_URL}marketingservey.php", data: formData);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Record Added Successfully!',
        );
      }
    print("Checking all fields data $emp_id,${_clientName.text.toString()},$givenMob");
    print("This is file path"+ _image!.path);
  }

  //image get from file
  File? _image;
  Future getImage() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image!="")
    {
      File file = File(image!.path);
      setState((){
        _image = file;
      });
    }
    else
    {
      print("Image not selected");
    }
    setState(() {
      _image = _image;
    });
  }


  @override
  void initState() {
    _getState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title:const Text("Market Survey Reporting",style: TextStyle(fontSize:17),),
          backgroundColor: Colors.green[800],
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
            icon:const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
            child: Container(
              padding:const EdgeInsets.all(20),
              child:Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        label:const Text("Customer's Name"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            // color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            // color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            //color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                      ),
                      controller: _clientName,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return "*required";
                        }
                        else
                        {
                          return null;
                        }
                      },
                    ),
                    const  SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        label:const Text("Mobile Number"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            // color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            // color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:const BorderSide(
                            //color: AppColors.rasayagreen,
                            width: 1.5,),
                        ),
                      ),
                      controller: _mobileNumber,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty)
                        {
                          return"*required";
                        }
                        else  if (value.length != 10)
                        {
                          return 'Mobile Number must be of 10 digit';
                        }
                        else
                        {
                          return null;
                        }

                      },
                    ),
                    const  SizedBox(height: 20,),
                    const Text("ADDRESS"),
                    SizedBox(height: 10,),
                    DropdownButtonFormField(
                      hint:const Text("select state"),
                      items: _state.map((item) {
                      return DropdownMenuItem(
                        value: item.id.toString(),
                        child: Text(item.sname.toString()),
                      );
                      }).toList(),
                      onChanged:(newVal1) {
                      setState(() {
                        selectedState = newVal1;
                        print(selectedState);
                        _getDistrict(newVal1);
                      });
                    },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                    SizedBox(height: 5,),
                    DropdownButtonFormField(
                      hint:const Text("--select district--"),
                      items:_district.map((ite) {
                      return DropdownMenuItem(
                        value: ite.id.toString(),
                        child: Text(ite.dname.toString()),
                      );
                    }).toList(),
                        onChanged:(newVal2) {
                          setState(() {
                            selectedDistrict = newVal2;
                            print(selectedDistrict);
                            _getAssembly(newVal2);
                          });
                        },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                    const SizedBox(height: 5,),
                    DropdownButtonFormField(
                      hint:const Text("--select assembly--"),
                      items: _assem.map((it) {
                      return DropdownMenuItem(
                        value: it.id.toString(),
                        child: Text(it.asname.toString()),
                      );
                    }).toList(),
                        onChanged: (newVal3) {
                          setState(() {
                            selectedAssembly = newVal3;
                            print(selectedAssembly);
                            _getPanchayat(newVal3);
                          });
                        },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                    const  SizedBox(height: 5,),
                    DropdownButtonFormField(
                      hint:const Text('--select panchayat--'),
                        items: _pancha.map((i) {
                          return DropdownMenuItem(
                            value: i.id.toString(),
                            child: Text(i.pname.toString()),
                          );
                        }).toList(),
                      onChanged: (newVal4) {
                        setState(() {
                          selectedPanchayat = newVal4;
                          print(selectedPanchayat);
                          _getWard(newVal4);
                        });
                      },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                    const  SizedBox(height: 5,),
                    DropdownButtonFormField(
                        hint:const Text('--select ward--'),
                        items: _war.map((w) {
                          return DropdownMenuItem(
                            value: w.id.toString(),
                            child: Text(w.wname.toString()),
                          );
                        }).toList(),
                      onChanged: (newVal5) {
                        setState(() {
                          selectedWard = newVal5;
                          print(selectedWard);
                        });
                      },
                      validator: (value) => value == null
                          ? '*required' : null,
                    ),
                    const SizedBox(height: 20,),
                    const Text("Do you know about RASAYA previously?"),
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child:ListTile(
                            title:const  Text('Yes'),
                            leading: Radio(
                              value: "1",
                              groupValue: _character1,
                              onChanged: (String? value) {
                                setState(() {
                                  _character1 = value;
                                  print(_character1);
                                });
                              },
                            ),
                          ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ListTile(
                              title:const  Text('No'),
                              leading: Radio(
                                value: "0",
                                groupValue: _character1,
                                onChanged: (String? value) {
                                  setState(() {
                                    _character1 = value;
                                    print(_character1);

                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const  SizedBox(height: 20,),
                    const Text("Is Rasaya App installed?"),
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: ListTile(
                              title:const  Text('Yes'),
                              leading: Radio(
                                value: "1",
                                groupValue: _character,
                                onChanged: (String? value) {
                                  setState(() {
                                    _checkYesNO();
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
                              title: const Text('No'),
                              leading: Radio(
                                value: "0",
                                groupValue: _character,
                                onChanged: (String? value) {
                                  setState(() {
                                    _checkYesNO();
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
                    const  SizedBox(height: 20,),
                    Visibility(
                      visible: _showDiscription,
                      child: TextFormField(
                        controller: _description,
                        autofocus: true,
                        maxLines: 2,
                        decoration:const InputDecoration(
                          label: Text("Description"),
                        ),
                      ),
                    ),
                    const  SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: getImage,
                            child: Column(
                              children: [
                                const  Icon(Icons.camera_alt,
                                    color: Colors.black),
                                const  Text("upload photo")
                              ],
                            ),
                          ),
                          _image == null ?const Text("*select an image",style: TextStyle(color: Colors.red),) : Image.file(_image!,
                            width:200,height:150,),
                        ],
                      ),
                    ),
                    const  SizedBox(
                       height: 10,
                     ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      height: 50.0,
                      width:double.infinity,
                      child: ElevatedButton(
                        onPressed: _isPressed ? null:()
                        {
                          if(_formKey.currentState!.validate())
                          {
                            uploadImage();
                          }
                          //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        },
                        child:const Text("SAVE RECORD"),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            primary: Colors.green[800]
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
        return Future.value(false);
      },
    );
  }
}


