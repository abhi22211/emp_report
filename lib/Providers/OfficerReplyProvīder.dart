import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ApiResponse/OfficerCommentApi.dart';
import '../model/OfficerComment_model.dart';

final officerreplyDataProvider = FutureProvider.autoDispose<List<OfficerReply>>((ref)async{
  return ref.watch(OfficerReplyProvider).getOfficerReplyPosts();
} );