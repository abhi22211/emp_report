import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/WorkListApi.dart';
import '../model/WorkList_model.dart';


final workListDataProvider = FutureProvider.autoDispose<List<EmpWorkClass>>((ref)async{
  return ref.watch(workListProvider).getWorkListPosts();
});


