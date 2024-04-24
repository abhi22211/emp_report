import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/WorkList_model.dart';


RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
void getWorkListCsv(emp_name,List<EmpWorkClass> empcsvList,selectedmonth,selectedyear) async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  List<List<dynamic>> rows = [];


  List<dynamic> row = [];
  row.add("DATE");
  row.add("WORK");
  rows.add(row);

  for (int i = 0; i < empcsvList.length; i++) {
    List<dynamic> row = [];
    row.add(empcsvList[i].reportDate);
    row.add(empcsvList[i].workDetail.replaceAll(exp, ''));
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";
  File f = File(file + "/worklist($selectedmonth-$selectedyear).csv");
  f.writeAsString(csv);
}
