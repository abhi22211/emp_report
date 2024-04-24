import 'package:emp_report/model/Leave/LeaveAppReportOff_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/Leave/LeaveAppReportOffApi.dart';



final empLeaveDataProvider = FutureProvider<List<EmployeeLeaveList_Class>>((ref)async{
  return ref.watch(empLeaveProvider).getEmployeeLeavefun();
} );