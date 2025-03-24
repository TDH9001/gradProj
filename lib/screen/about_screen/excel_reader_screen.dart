import 'package:flutter/material.dart';
import 'excel_service.dart';

class ExcelReaderScreen extends StatefulWidget {
  @override
  _ExcelReaderScreenState createState() => _ExcelReaderScreenState();
}

class _ExcelReaderScreenState extends State<ExcelReaderScreen> {
  List<Map<String, dynamic>> _excelData = [];
  bool _isLoading = false;

  Future<void> _loadExcel() async {
    setState(() => _isLoading = true);
    
    final data = await ExcelService.readExcel();
    // For translation:
    // final data = await ExcelService.translateExcelData(targetLanguage: 'ar');
    
    setState(() {
      _excelData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SciConnect Excel Reader'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _excelData.isEmpty
              ? Center(child: Text('No Excel data loaded'))
              : ListView.builder(
                  itemCount: _excelData.length,
                  itemBuilder: (context, index) {
                    final entry = _excelData[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry['Course Name'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: ${entry['Time']}'),
                            Text('Professor: ${entry['Professor']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadExcel,
        tooltip: 'Load Excel',
        child: Icon(Icons.upload_file),
      ),
    );
  }
}