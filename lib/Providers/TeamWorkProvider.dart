import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/TeamWorkApi.dart';
import '../model/TeamWork_model.dart';

final teamworkListDataProvider = FutureProvider.autoDispose<List<TeamWorkClass>>((ref)async{
  return ref.watch(teamworkListProvider).getTeamWorkPosts();
});