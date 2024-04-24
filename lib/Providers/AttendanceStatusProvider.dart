import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/AttendanceStatusApi.dart';
import '../model/AttendanceStatusModel.dart';

final attendStatusDataProvider = FutureProvider.autoDispose<List<AttendanceStatusClass>>((ref)async{
  return ref.watch(attendStatusProvider).getAttendanceStatusPosts();
} );