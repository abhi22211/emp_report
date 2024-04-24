import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/AttendanceStatusModel.dart';
import '../utils/constant.dart';

class GetAttendanceStatusResponse{

  Future<List<AttendanceStatusClass>> getAttendanceStatusPosts() async {
    var response = await http.get(Uri.parse("${AppConstant.BASE_URL}attendencestatus.php"));
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

final attendStatusProvider = Provider<GetAttendanceStatusResponse>((ref)=>GetAttendanceStatusResponse());