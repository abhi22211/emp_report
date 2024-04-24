import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/AttendanceCountApi.dart';
import '../model/EmployeeAttendance_model.dart';

final attenCountDataProvider = FutureProvider.autoDispose<AttendanceCount>((ref)async{
  return ref.watch(attenCountProvider).getAttendanceCountPosts();
});