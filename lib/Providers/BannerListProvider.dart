
import 'package:emp_report/model/Banner/Banner_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiResponse/Banner/BannerResponse.dart';

final bannerListDataProvider = FutureProvider.autoDispose<List<Banner_class>>((ref)async{
  return ref.watch(bannerListProvider).getBannerListPosts();
} );