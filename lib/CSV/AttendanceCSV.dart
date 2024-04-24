import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/MonthwiseAttendance_model.dart';

void generateAttendanceCsv(List<MonthwiseAttendanceClass> mwac,selectedmonth,selectedyear) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();


  List<List<dynamic>> rows = [];
  List<dynamic> row = [];
  row.add("EMPLOYEE NAME");
  row.add("STATUS");
  row.add("DATE");
  rows.add(row);

  for (int i = 0; i < mwac.length; i++) {
    List<dynamic> row = [];
    row.add(mwac[i].empName);
    row.add(mwac[i].atStatus);
    row.add(mwac[i].atdate);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";
  File f = File(file + "/attendance($selectedmonth-$selectedyear).csv");
  f.writeAsString(csv);
}
