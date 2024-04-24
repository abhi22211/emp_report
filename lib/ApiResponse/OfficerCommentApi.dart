import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/OfficerComment_model.dart';
import '../utils/constant.dart';

class GetOfficerReplyResponse{

  Future<List<OfficerReply>> getOfficerReplyPosts() async {
    int emp_id = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emp_id= prefs.getInt('emp_id')==null ? 0:prefs.getInt('emp_id')!;
    var response = await http.post(Uri.parse("${AppConstant.BASE_URL}msgreplylist.php"),
        body:{
          "empid":emp_id.toString(),
        });
    print("This is $emp_id");
    if(response.statusCode == 200)
    {
      final List result = jsonDecode(response.body)['user'];
      print(result);
      return result.map((e) => OfficerReply.fromJson(e)).toList();
    }
    else
    {
      throw Exception(response.reasonPhrase);
    }

  }
}

final OfficerReplyProvider = Provider<GetOfficerReplyResponse>((ref)=>GetOfficerReplyResponse());