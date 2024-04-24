import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/TeamListApi.dart';
import '../model/TeamList_model.dart';

final teamListDataProvider = FutureProvider.autoDispose<List<TeamList>>((ref)async{
  return ref.watch(teamListProvider).getTeamListPosts();
});