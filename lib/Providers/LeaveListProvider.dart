import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/Leave/LeaveListApi.dart';
import '../model/Leave/LeaveUpdate_Modal.dart';


final leaveListDataProvider = FutureProvider<List<LeaveUpdate_Class>>((ref)async{
  return ref.watch(leaveListProvider).leaveListfun();
} );