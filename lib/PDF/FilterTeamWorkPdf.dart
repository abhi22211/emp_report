import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../model/TeamWork_model.dart';
RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);
Future<void> printTeamWork(List<TeamWorkClass> _printTeamwork,_dateInput) async{
  int _i=0;
  final image = await imageFromAssetBundle(
    "images/report_header.png",
  );
  final image1 = await imageFromAssetBundle(
    "images/report_footer.png",
  );
  final doc = Document();
  doc.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build:(Context context)
      =><Widget>[
        Container(
          child: Image
            (image),
        ),
        Text("TEAM WORK LIST", style: TextStyle(fontSize: 15.0,fontWeight:FontWeight.bold)),
        Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Date: $_dateInput", style: TextStyle(fontSize: 10.0)),

                ]
            )
        ),
        Padding(padding:EdgeInsets.only(top: 10)),
        spaceDivider(20),
        Container(
          color: PdfColors.white,
          child: Table(
            border: TableBorder.all(color: PdfColors.black),
            children: [
              tableRow(
                  ["S.No.", "EMPLOYEE NAME","DESIGNATION", "DATE","WORK DETAIL"], textStyle1()),
              ..._printTeamwork.map((e) =>
                  tableRow(["${++_i}", "${e.empName}", "${e.desgName}",
                    "${e.reportDate.day}/${e.reportDate.month}/${e.reportDate.year}","${e.workDetail.replaceAll(exp, '')}"], textStyle2()
                  )).toList(),
            ],
          ),
        ),
        Container(
          child: Image
            (image1),
        ),
      ]
  ));

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());

}

tableRow(List<String> attributes, TextStyle textStyle) {
  return TableRow(
    children: attributes
        .map(
          (e) => Text(
        "  " + e,
        style: textStyle,
      ),
    )
        .toList(),
  );
}

TextStyle textStyle1() {
  return TextStyle(
    color: PdfColors.black,
    fontSize: 8,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyle2() {
  return TextStyle(
    color: PdfColors.black,
    fontSize: 8,
  );
}
TextStyle textStyle3() {
  return TextStyle(
    color: PdfColors.black,
    fontSize: 10,
    decoration: TextDecoration.lineThrough,decorationColor:PdfColors.red,
  );
}
Widget spaceDivider(double height) {
  return SizedBox(height: height);
}
Widget divider(double width) {
  return Container(
    height: 3,
    width: width,
    decoration: BoxDecoration(
      color: PdfColors.grey,
    ),
  );
}
Widget textRow(List<String> titleList, TextStyle textStyle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: titleList
        .map(
          (e) => Text(
        e,
        style: textStyle,
      ),
    )
        .toList(),
  );
}