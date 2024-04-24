import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/OfficersViewSL_model.dart';

void generateCsvFile(List<OfficersviewSLclass> suvList,emp_name,from_date,to_date) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  List<List<dynamic>> rows = [];


  List<dynamic> row = [];
  row.add("CUSTOMER NAME");
  row.add("MOBILE NUMBER");
  row.add("DISTRICT");
  row.add("ASSEMBLY");
  row.add("PANCHAYAT");
  row.add("WARD");
  rows.add(row);

  for (int i = 0; i < suvList.length; i++) {
    List<dynamic> row = [];
    row.add(suvList[i].clientName);
    row.add(suvList[i].clientMobile);
    row.add(suvList[i].dname);
    row.add(suvList[i].asname);
    row.add(suvList[i].pname);
    row.add(suvList[i].wname);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";
  File f = File(file + "/surveyby($from_date-$to_date).csv");
  f.writeAsString(csv);
}
