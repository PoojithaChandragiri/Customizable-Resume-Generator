import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

void main() {
  runApp(ResumeGeneratorApp());
}

class ResumeGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResumeGeneratorScreen(),
    );
  }
}

class ResumeGeneratorScreen extends StatelessWidget {
  final String name = "John Doe";
  final String email = "john.doe@example.com";
  final String phone = "+1 234 567 890";
  final String address = "1234 Elm Street, Apt 56\nSpringfield, IL 62701";
  final String skills = "Flutter, Dart, JavaScript, HTML, CSS, React, Node.js, Git, SQL, Agile Methodologies";
  final String education = """
B.S. in Computer Science
ABC University, Graduated 2020
Relevant Courses: Data Structures, Algorithms, Web Development, Mobile App Development, Machine Learning, Database Systems
Achievements: Dean’s List for 3 semesters, Top 5% of the class
Certifications: Google Associate Android Developer, AWS Certified Developer - Associate

M.S. in Software Engineering
XYZ University, Graduated 2022
Relevant Courses: Advanced Algorithms, Cloud Computing, Big Data Analytics
Achievements: Graduated with Honors, Research Assistant in Cloud Computing
  """;
  final String experience = """
Software Developer at XYZ Corp. (Jan 2021 - Present)
- Developed and maintained mobile applications using Flutter.
- Collaborated with a cross-functional team to design and implement features.
- Optimized the performance of applications, resulting in a 30% speed improvement.
  """;

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(name, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Text(email, style: pw.TextStyle(fontSize: 14, color: PdfColor.fromHex('#007bff'))),
                pw.SizedBox(width: 10),
                pw.Text(phone, style: pw.TextStyle(fontSize: 14, color: PdfColor.fromHex('#007bff'))),
              ],
            ),
            pw.Text(address, style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),
            pw.Text("Skills:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#007bff'))),
            pw.Text(skills, style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 10),
            pw.Text("Education:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#007bff'))),
            pw.Text(education, style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 10),
            pw.Text("Experience:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#007bff'))),
            pw.Text(experience, style: pw.TextStyle(fontSize: 14)),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/resume.pdf");
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customizable Resume Generator"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resume Preview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Contact Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(name, style: TextStyle(fontSize: 18)),
            Text(email, style: TextStyle(fontSize: 18, color: Colors.blue)),
            Text(phone, style: TextStyle(fontSize: 18)),
            Text(address, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Skills", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(skills, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Education", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(education, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Experience", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(experience, style: TextStyle(fontSize: 18)),
            Spacer(),
            ElevatedButton(
              onPressed: generatePDF,
              child: Text("Generate PDF"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
