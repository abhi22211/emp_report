import 'dart:convert';
import 'package:emp_report/model/Banner/Banner_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../utils/constant.dart';

class GetBannerListResponse{

  Future<List<Banner_class>> getBannerListPosts() async {

    var response = await http.get(Uri.parse("${AppConstant.BASE_URL}topbanner.php"),);
    if(response.statusCode == 200)
    {
      final List result = jsonDecode(response.body)['user'];

      print(result);
      return result.map((e) => Banner_class.fromJson(e)).toList();
    }
    else
    {
      throw Exception(response.reasonPhrase);
    }
  }
}

final bannerListProvider = Provider<GetBannerListResponse>((ref)=>GetBannerListResponse());
