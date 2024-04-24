import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/Leave/AttendanceApiStatus.dart';
import '../model/AttendanceStatusModel.dart';



final attendStatusDataProvider1 = FutureProvider<List<AttendanceStatusClass>>((ref)async{
  return ref.watch(attendStatusProvider1).getAttendanceStatusPosts1();
} );