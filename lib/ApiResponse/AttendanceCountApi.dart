import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/EmployeeAttendance_model.dart';
import '../utils/constant.dart';

class GetAttendanceCountResponse{

  Future<AttendanceCount> getAttendanceCountPosts() async {
    int emp_id = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}employeeattencnt.php"),
        body:{
          "emp_id":emp_id.toString(),
        });
    print("This is $emp_id");

    if(response.statusCode == 200)
    {
      final parsed = jsonDecode(response.body)['status'];
      print(parsed);
      final result = AttendanceCount.fromJson(parsed);
      return result;
    }
    else
    {
      throw Exception(response.reasonPhrase);
    }
  }

}

final attenCountProvider = Provider<GetAttendanceCountResponse>((ref)=>GetAttendanceCountResponse());