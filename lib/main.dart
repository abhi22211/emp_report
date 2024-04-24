import 'package:emp_report/view/AttendanceList.dart';
import 'package:emp_report/view/OfficerAttendancePage/AttendanceViewOfficer.dart';
import 'package:emp_report/view/Comment.dart';
import 'package:emp_report/view/DailyWorkStatus.dart';
import 'package:emp_report/view/DepartmentWorkFilter.dart';
import 'package:emp_report/view/DepartmentWorkReport.dart';
import 'package:emp_report/view/EditWork.dart';
import 'package:emp_report/view/FilterList.dart';
import 'package:emp_report/view/Leave/Leave.dart';
import 'package:emp_report/view/Leave/LeaveAppReportOff.dart';
import 'package:emp_report/view/Login.dart';
import 'package:emp_report/view/OfficerAttendancePage/MarkAttendance.dart';
import 'package:emp_report/view/MarketCustomerReporting.dart';
import 'package:emp_report/view/Payroll.dart';
import 'package:emp_report/view/ReportingOfficerHome.dart';
import 'package:emp_report/view/SalarySlip.dart';
import 'package:emp_report/view/SurveyList.dart';
import 'package:emp_report/view/TeamList.dart';
import 'package:emp_report/view/UpdatePassword.dart';
import 'package:emp_report/view/WorkList.dart';
import 'package:emp_report/view/home.dart';
import 'package:emp_report/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Splash/Splash.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async{
runApp(const ProviderScope(child: Emp()));
configLoading();
 }

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class Emp extends StatelessWidget {
  const Emp({Key? key}) : super(key: key);
  get _work_id => null;
  get work_detail => "";
  get add_date => "";
  get emp_phone => "";
  get wEmpI => null;
  get work => null;
  get time => null;
  get FilterStatus => null;
  get thispage => null;
  get workReportId => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes:{
          '/' : (context) =>Splash(),
          '/login' : (context) =>Emp_Login(),
          '/home' : (context) =>const Emp_Home(),
          '/reporthome' : (context) =>const Reporting_Home(),
          '/attendance' : (context) =>const Attendance(),
          '/dailytaskreport' : (context) =>const DailyWorkStatus(),
          '/worklist' : (context) =>const Work_List(),
          '/attendancelist' : (context) =>const AttendaceList(),
          '/salary' : (context) =>CommentReplyClass(),
          '/profile' : (context) =>const Profile(),
          '/updatepassword' : (context) =>UpdatePassword(emp_phone),
          '/editwork' : (context) =>EditWork(_work_id,work_detail,add_date,thispage),
          '/deptreport' : (context) =>const DepartmentWork(),
          '/market' :(context) =>const MarketSurvey(),
          '/ourteam' :(context) =>const TeamListOfficer(),
          '/surveylist' :(context) =>const SurveyList(),
          '/comment' : (context)=>Comment(wEmpI,work,time,FilterStatus,workReportId),
          '/filter' : (context)=>const Filter_List(),
          '/filterdeptwork' : (context)=>const FilterDepartmentWork(),
          '/officersviewal' : (context)=>const AttendanceListOffV(),
          '/payslip' : (context)=>const Payroll(),
          '/leave' : (context)=>const Leave(),
          '/leavereporting' : (context)=>const LeaveAppReportOff(),
        },
      builder: EasyLoading.init(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );


  }
}

