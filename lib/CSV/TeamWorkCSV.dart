import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/TeamWork_model.dart';


RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
void teamWorkCsv(List<TeamWorkClass> _printTeamwork,_dateInput) async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  List<List<dynamic>> rows = [];


  List<dynamic> row = [];
  row.add("EMPLOYEE NAME");
  row.add("DESIGNATION");
  row.add("DATE");
  row.add("WORK DETAIL");
  rows.add(row);

  for (int i = 0; i < _printTeamwork.length; i++) {
    List<dynamic> row = [];
    row.add(_printTeamwork[i].empName);
    row.add(_printTeamwork[i].desgName);
    row.add(_printTeamwork[i].reportDate);
    row.add(_printTeamwork[i].workDetail.replaceAll(exp, ''));
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";
  File f = File(file + "/teamwork$_dateInput.csv");
  f.writeAsString(csv);
}
