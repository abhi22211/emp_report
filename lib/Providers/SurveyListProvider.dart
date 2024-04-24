import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/SurveyListApi.dart';
import '../model/SurveyList_model.dart';

final surveyListDataProvider = FutureProvider.autoDispose<List<SurveyClass>>((ref)async{
  return ref.watch(surveyListProvider).getSurveyPosts();
});