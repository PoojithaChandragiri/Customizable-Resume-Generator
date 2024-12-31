import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const ResumeGeneratorApp());
}

class ResumeGeneratorApp extends StatelessWidget {
  const ResumeGeneratorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Resume Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ResumeGeneratorPage(),
    );
  }
}

class ResumeGeneratorPage extends StatefulWidget {
  const ResumeGeneratorPage({Key? key}) : super(key: key);

  @override
  _ResumeGeneratorPageState createState() => _ResumeGeneratorPageState();
}

class _ResumeGeneratorPageState extends State<ResumeGeneratorPage> {
  // Controllers for text inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  // Lists for dynamic content
  List<String> experienceList = [];
  List<String> educationList = [];
  List<String> skillsList = [];

  // Color selection
  Color fontColor = Colors.black;
  Color backgroundColor = Colors.white;
  double fontSize = 16;

  // QR Code Data
  String qrData = "https://example.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Resume Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Controls for customization
            Column(
              children: [
                Row(
                  children: [
                    const Text('Font Size:'),
                    Expanded(
                      child: Slider(
                        min: 10,
                        max: 30,
                        value: fontSize,
                        onChanged: (value) {
                          setState(() {
                            fontSize = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Font Color:'),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () async {
                        final color = await showDialog<Color>(
                          context: context,
                          builder: (context) {
                            return ColorPickerDialog(
                              initialColor: fontColor,
                            );
                          },
                        );
                        if (color != null) {
                          setState(() {
                            fontColor = color;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Background Color:'),
                    IconButton(
                      icon: const Icon(Icons.color_lens),
                      onPressed: () async {
                        final color = await showDialog<Color>(
                          context: context,
                          builder: (context) {
                            return ColorPickerDialog(
                              initialColor: backgroundColor,
                            );
                          },
                        );
                        if (color != null) {
                          setState(() {
                            backgroundColor = color;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Resume Preview
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        nameController.text.isEmpty ? "Your Name" : nameController.text,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: fontColor,
                        ),
                      ),
                      Text(
                        "Email: ${emailController.text}\nPhone: ${phoneController.text}",
                        style: TextStyle(fontSize: fontSize, color: fontColor),
                      ),
                      Text(
                        addressController.text.isEmpty ? "Your Address" : addressController.text,
                        style: TextStyle(fontSize: fontSize, color: fontColor),
                      ),
                      const SizedBox(height: 20),
                      ...buildSection('Experience', experienceList),
                      const SizedBox(height: 10),
                      ...buildSection('Education', educationList),
                      const SizedBox(height: 10),
                      ...buildSection('Skills', skillsList),
                      const SizedBox(height: 20),
                      QrImage(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Input fields for dynamic content
            Column(
              children: [
                buildInputField('Name', nameController),
                buildInputField('Email', emailController),
                buildInputField('Phone', phoneController),
                buildInputField('Address', addressController),
                buildInputField('Experience', experienceController),
                buildInputField('Education', educationController),
                buildInputField('Skills', skillController),
                ElevatedButton(
                  onPressed: addExperience,
                  child: const Text('Add Experience'),
                ),
                ElevatedButton(
                  onPressed: addEducation,
                  child: const Text('Add Education'),
                ),
                ElevatedButton(
                  onPressed: addSkill,
                  child: const Text('Add Skill'),
                ),
                ElevatedButton(
                  onPressed: generatePDF,
                  child: const Text('Generate PDF'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildSection(String title, List<String> items) {
    return [
      Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: fontColor,
        ),
      ),
      for (var item in items) Text(item, style: TextStyle(fontSize: fontSize, color: fontColor)),
    ];
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void addExperience() {
    setState(() {
      experienceList.add(experienceController.text);
      experienceController.clear();
    });
  }

  void addEducation() {
    setState(() {
      educationList.add(educationController.text);
      educationController.clear();
    });
  }

  void addSkill() {
    setState(() {
      skillsList.add(skillController.text);
      skillController.clear();
    });
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(nameController.text, style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
            pw.Text('Email: ${emailController.text}\nPhone: ${phoneController.text}'),
            pw.Text(addressController.text),
            pw.SizedBox(height: 20),
            buildPdfSection('Experience', experienceList),
            pw.SizedBox(height: 10),
            buildPdfSection('Education', educationList),
            pw.SizedBox(height: 10),
            buildPdfSection('Skills', skillsList),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/resume.pdf');
    await file.writeAsBytes(await pdf.save());

    // Trigger download (this will be platform-dependent, e.g., showing a dialog to open the file)
    print('PDF saved at ${file.path}');
  }

  pw.Widget buildPdfSection(String title, List<String> items) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
        for (var item in items) pw.Text(item, style: pw.TextStyle(fontSize: fontSize)),
      ],
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const ColorPickerDialog({required this.initialColor, Key? key}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
          showLabel: true,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
