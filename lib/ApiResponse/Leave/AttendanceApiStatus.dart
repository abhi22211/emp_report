import 'dart:convert';
import 'package:emp_report/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../model/AttendanceStatusModel.dart';


class GetAttendanceStatusResponse1{

  Future<List<AttendanceStatusClass>> getAttendanceStatusPosts1() async {
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}attendencestatus.php"),
    body: {
      "leavestatus":'1',
    });
    if(response.statusCode == 200)
    {
      final List result = jsonDecode(response.body)['user'];
      print(result);
      return result.map((e) => AttendanceStatusClass.fromJson(e)).toList();
    }
    else
    {
      throw Exception(response.reasonPhrase);
    }
  }
}

final attendStatusProvider1 = Provider<GetAttendanceStatusResponse1>((ref)=>GetAttendanceStatusResponse1());