import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';


class PdfApi {
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async{
    final path = (await getExternalStorageDirectory())?.path;
    final file =  File('$path/$fileName');
    await file.writeAsBytes(bytes,flush: true);
  }


  static Future<File> saveSurveyDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    var directory = await getExternalStorageDirectory();
    String outputFile =
        directory!.path + "/Survey/$name.pdf";

    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);



    print(file);
    OpenFile.open(outputFile);
    print("/////////////////////");


    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<File> saveB2CDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    var directory = await getExternalStorageDirectory();
    String outputFile =
        directory!.path + "/B2C/INVOICE/$name.pdf";

    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);



    print(file);

    await file.writeAsBytes(await pdf.save());

    return file;
  }
  static Future<File> saveB2BDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    var directory = await getExternalStorageDirectory();
    String outputFile =
        directory!.path + "/B2B/INVOICE/$name.pdf";

    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);



    print(file);

    await file.writeAsBytes(await pdf.save());

    return file;
  }
  static Future<File> saveb2cReturnedDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    var directory = await getExternalStorageDirectory();
    String outputFile =
        directory!.path + "/B2C/RTO/$name.pdf";

    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);



    print(file);

    await file.writeAsBytes(await pdf.save());

    return file;
  }
  static Future<File> saveb2bReturnedDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    var directory = await getExternalStorageDirectory();
    String outputFile =
        directory!.path + "/B2B/RTO/$name.pdf";

    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);



    print(file);

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
// class PdfApi {
//   static Future<File> generateInvoice() async {
//     final pdf = Document();
//
//     return saveDocument(name: 'Invoice.pdf',pdf:pdf);
//   }
//
//   static Future openFile(File file) async {
//     final url = file.path;
//     await OpenFile.open(url);
//   }
//
//   static Future<File> saveDocument({
//     String name, Document pdf
//   }) async{
//     final bytes =await pdf.save();
//     final dir =await getApplicationDocumentsDirectory();
//         final file = File('${dir.path}/$name');
//     await file.writeAsBytes(bytes);
//     return file;
//   }
// }
// void createPdf() async {
//   final doc = pw.Document();
//   image = await imageFromAssetBundle('assets/369logo-removebg-preview.jpg');
//   doc.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Container(
//             decoration: pw.BoxDecoration(),
//             child: pw.ListView(children: [
//               pw.Container(
//                   padding: pw.EdgeInsets.all(15),
//                   height: 137,
//                   width: double.infinity,
//                   color: PdfColors.teal,
//                   child: pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Image(image),
//                         pw.Column(
//                             mainAxisAlignment: pw.MainAxisAlignment.center,
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Row(
//                                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                   pw.CrossAxisAlignment.start,
//                                   children: [
//                                     pw.Text('369',
//                                         style: pw.TextStyle(
//                                             color: PdfColors.white,
//                                             fontWeight: pw.FontWeight.bold,
//                                             fontSize: 18)),
//                                     pw.SizedBox(width: 110),
//                                     pw.Text(
//                                         '''Reg No: KKD/CA/11/2023,Iringath P.O,
// Kozhikode,kerala,-673523''',
//                                         style: pw.TextStyle(
//                                             color: PdfColors.white,
//                                             fontWeight: pw.FontWeight.bold)),
//                                   ]),
//                               pw.Row(
//                                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                   pw.CrossAxisAlignment.start,
//                                   children: [
//                                     pw.Text('GLOBAL CLUB',
//                                         style: pw.TextStyle(
//                                             color: PdfColors.white,
//                                             fontWeight: pw.FontWeight.bold,
//                                             fontSize: 18)),
//                                     pw.SizedBox(width: 60),
//                                     pw.Text(
//                                         '369globalclub@gmail.com\nwww.369globalclub.org',
//                                         style: pw.TextStyle(
//                                             color: PdfColors.white,
//                                             fontWeight: pw.FontWeight.bold)),
//                                   ]),
//                               pw.SizedBox(height: 5),
//                               pw.Row(
//                                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                   pw.CrossAxisAlignment.start,
//                                   children: [
//                                     pw.Text('CHARITABLE SOCIETY',
//                                         style: pw.TextStyle(
//                                             color: PdfColors.white,
//                                             fontWeight: pw.FontWeight.bold,
//                                             fontSize: 18)),
//                                   ]),
//
// // Email-369globalclub@gmail.com''',style: pw.TextStyle(fontSize: 15)),
//                             ])
//                       ])),
//               pw.SizedBox(height: 60),
//               pw.Text('Receipt',
//                   style: pw.TextStyle(
//                       decoration: pw.TextDecoration.underline,
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 18,
//                       color: PdfColors.deepPurple)),
//               pw.SizedBox(height: 40),
//               pw.Text('WELCOME TO 369 GLOBAL CLUB ONLINE SYSTEM',
//                   style: pw.TextStyle(
//                       fontSize: 18, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 25),
//               pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text('Ref.No:- ${currentuser?.uid}'),
//                     pw.Text(
//                         "Date: ${DateFormat('dd-MMM-yyyy').format(currentuser?.joinDate ?? DateTime.now())}"),
//                   ]),
//               pw.SizedBox(height: 80),
//               pw.RichText(
//                 text: pw.TextSpan(
//                   style: pw.TextStyle(color: PdfColors.black, fontSize: 15),
//                   children: <pw.TextSpan>[
//                     pw.TextSpan(text: 'Received with thanks from '),
//                     pw.TextSpan(
//                         text: ' ${currentuser?.name} ',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.TextSpan(text: 'the sum of '),
//                     pw.TextSpan(
//                         text: ' Rs. 369 ',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     const pw.TextSpan(
//                       text:
//                       ' (Rupees Three Hundred and Sixty Nine only) by E-Transfer as Donation.',
//                     )
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 15),
//               pw.Text(
//                   'Once again thanks for supporting social welfare activity and connected Global club online helping project.',
//                   style: pw.TextStyle(fontSize: 15)),
//               pw.SizedBox(height: 25),
//               pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
//                 pw.Text('- 369 Global Club', style: pw.TextStyle(fontSize: 15)),
//               ]),
//               pw.SizedBox(height: 20),
//               pw.Text(
//                   'This is a computer generated receipt, signature not required.',
//                   style: pw.TextStyle(fontSize: 10)),
//               pw.Spacer(),
//               pw.Container(
//                   height: 30,
//                   child: pw.Footer(
//                       decoration: pw.BoxDecoration(color: PdfColors.teal)))
//             ])); // Center
//       },
//     ),
//   ); // Page
//   await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => doc.save());
// }