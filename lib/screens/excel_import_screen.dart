import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class ExcelImportScreen extends StatefulWidget {
  const ExcelImportScreen({Key? key}) : super(key: key);

  @override
  State<ExcelImportScreen> createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  List<List<dynamic>>? _excelData;
  String _fileName = '';

  Future<void> _pickAndReadExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
        });

        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        final excel = Excel.decodeBytes(bytes);

        
        final sheet = excel.tables.keys.first;
        final rows = excel.tables[sheet]!.rows;

        
        final data = <List<dynamic>>[];
        for (var row in rows) {
          final rowData = <dynamic>[];
          for (var cell in row) {
            rowData.add(cell?.value ?? '');
          }
          if (rowData.any((element) => element != '')) {
            data.add(rowData);
          }
        }

        setState(() {
          _excelData = data;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reading Excel file: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Import'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickAndReadExcelFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Import Excel File'),
            ),
            if (_fileName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('File: $_fileName'),
              ),
            if (_excelData != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Excel Data Preview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: _excelData![0]
                          .map((header) => DataColumn(
                                label: Text(
                                  header.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      rows: _excelData!
                          .skip(1)
                          .map(
                            (row) => DataRow(
                              cells: row
                                  .map((cell) => DataCell(Text(cell.toString())))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}