import 'package:emp_report/model/Profile_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/ProfileApi.dart';

final profileListDataProvider = FutureProvider.autoDispose<List<Profile_Class>>((ref)async{
  return ref.watch(profileListProvider).getProf();
});