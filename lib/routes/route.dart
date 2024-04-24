import 'package:emp_report/routes/routes.dart';
import 'package:emp_report/splash/splash.dart';
import 'package:emp_report/view/Comment.dart';
import 'package:emp_report/view/Leave/Leave.dart';
import 'package:flutter/material.dart';
import '../view/AttendanceList.dart';
import '../view/OfficerAttendancePage/AttendanceViewOfficer.dart';
import '../view/DailyWorkStatus.dart';
import '../view/DepartmentWorkFilter.dart';
import '../view/DepartmentWorkReport.dart';
import '../view/EditWork.dart';
import '../view/FilterList.dart';
import '../view/Leave/LeaveAppReportOff.dart';
import '../view/Login.dart';
import '../view/OfficerAttendancePage/MarkAttendance.dart';
import '../view/MarketCustomerReporting.dart';
import '../view/Payroll.dart';
import '../view/ReportingOfficerHome.dart';
import '../view/SalarySlip.dart';
import '../view/SurveyList.dart';
import '../view/TeamList.dart';
import '../view/UpdatePassword.dart';
import '../view/WorkList.dart';
import '../view/home.dart';
import '../view/profile.dart';

class RouterUtil {
  static get _work_id => null;
  static String get work_detail => "";
  static String get emp_phone => "";
  static DateTime get _reportDate => DateTime.now();
  static get wEmpI => null;
  static get work => null;
  static get time => null;
  static get FilterStatus => null;
  static  get thispage => null;
  static get workReportId => null;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.LOGIN:
        return MaterialPageRoute(builder: (_) => Emp_Login());
      case Routes.HOME:
        return MaterialPageRoute(builder: (_) => Emp_Home());
      case Routes.REPORTHOME:
        return MaterialPageRoute(builder: (_) => Reporting_Home());
      case Routes.ATTENDANCE:
        return MaterialPageRoute(builder: (_) => Attendance());
      case Routes.DAILYTASKREPORT:
        return MaterialPageRoute(builder: (_) => DailyWorkStatus());
      case Routes.WORKREPORTLIST:
        return MaterialPageRoute(builder: (_) => Work_List());
      case Routes.ATTENDANCELIST:
        return MaterialPageRoute(builder: (_) => AttendaceList());
      case Routes.SALARY:
        return MaterialPageRoute(builder: (_) => CommentReplyClass());
      case Routes.PROFILE:
        return MaterialPageRoute(builder: (_) => Profile());
      case Routes.UPDATEPASSWORD:
        return MaterialPageRoute(builder: (_) => UpdatePassword(emp_phone));
      case Routes.EDITWORK:
        return MaterialPageRoute(builder: (_) => EditWork(_work_id,work_detail,_reportDate,thispage));
      case Routes.DEPTREPORT:
        return MaterialPageRoute(builder: (_) => DepartmentWork());
      case Routes.MARKET:
        return MaterialPageRoute(builder: (_) => MarketSurvey());
      case Routes.OURTEAM:
        return MaterialPageRoute(builder: (_) => TeamListOfficer());
      case Routes.SURVEYLIST:
        return MaterialPageRoute(builder: (_) => SurveyList());
      case Routes.COMMENT:
        return MaterialPageRoute(builder: (_) => Comment(wEmpI,work,time,FilterStatus,workReportId));
      case Routes.FILTER:
        return MaterialPageRoute(builder: (_) => Filter_List());
      case Routes.FILTERDEPTWORK:
        return MaterialPageRoute(builder: (_) => FilterDepartmentWork());
      case Routes.OFFICERSVIEWAL:
        return MaterialPageRoute(builder: (_) => AttendanceListOffV());
      case Routes.PAYSLIP:
        return MaterialPageRoute(builder: (_) => Payroll());
      case Routes.LEAVE:
        return MaterialPageRoute(builder: (_) => Leave());
      case Routes.LEAVEREPORTING:
        return MaterialPageRoute(builder: (_) => LeaveAppReportOff());
      default:
        return MaterialPageRoute(builder: (_) => Splash());
    }
  }
}