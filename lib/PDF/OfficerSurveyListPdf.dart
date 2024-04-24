import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../model/OfficersViewSL_model.dart';

Future<void> printSurveyListOff(List<OfficersviewSLclass> suvList,emp_name,from_date,to_date) async{
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
      build: (Context context) =><Widget>[
        Container(
          child: Image
            (image),
        ),
        Center(child:Text("Survey List by $emp_name", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
        ),
        Text("From $from_date - $to_date", style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold)),
        Padding(padding:EdgeInsets.only(top: 10)),
        spaceDivider(20),
        Container(
          color: PdfColors.white,
          child: Table(
            border: TableBorder.all(color: PdfColors.black),
            children: [
              tableRow(
                  ["S.No.", "CUSTOMER NAME","MOBILE NUMBER", "DISTRICT","ASSEMBLY","PANCHAYAT","WARD"], textStyle1()),
              ...suvList.map((e) =>
                  tableRow(["${++_i}", "${e.clientName}", "${e.clientMobile}",
                    "${e.dname}","${e.asname}","${e.pname}","${e.wname}"], textStyle2()
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