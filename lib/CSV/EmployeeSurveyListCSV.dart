import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/SurveyList_model.dart';

void generateEmpSurveyCsv(List<SurveyClass> _printSurveyLST,emp_name) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  List<List<dynamic>> rows = [];

  List<dynamic> row = [];
  row.add("CUSTOMER NAME");
  row.add("SURVEY DATE");
  row.add("MOBILE NUMBER");
  row.add("DISTRICT");
  row.add("ASSEMBLY");
  row.add("PANCHAYAT");
  row.add("WARD");
  rows.add(row);

  for (int i = 0; i < _printSurveyLST.length; i++) {
    List<dynamic> row = [];
    row.add(_printSurveyLST[i].clientName);
    row.add(_printSurveyLST[i].createdAt);
    row.add(_printSurveyLST[i].clientMobile);
    row.add(_printSurveyLST[i].dname);
    row.add(_printSurveyLST[i].asname);
    row.add(_printSurveyLST[i].pname);
    row.add(_printSurveyLST[i].wname);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);
  var dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";
  File f = File(file + "/emp_surveylist.csv");
  f.writeAsString(csv);
}
