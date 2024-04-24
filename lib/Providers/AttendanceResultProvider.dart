import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/AttendanceRecordApi.dart';
import '../model/AttendanceResult_model.dart';

final attenResultDataProvider = FutureProvider.autoDispose<List<AttendanceClass>>((ref)async{
  return ref.watch(attenResultProvider).getAttendanceResultPosts();
} );