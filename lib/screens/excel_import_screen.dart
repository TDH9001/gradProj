import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';

class ExcelImportScreen extends StatefulWidget {
  const ExcelImportScreen({Key? key}) : super(key: key);

  @override
  State<ExcelImportScreen> createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  List<Map<String, String>>? _excelData;
  List<String>? _headers;
  String _fileName = '';
  bool _isLoading = false;
  String _errorMessage = '';
  int _totalRows = 0;

  Future<void> _importExcelFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await MediaService.instance.pickAndReadExcelFile();
      
      setState(() {
        _isLoading = false;
        
        if (result['success']) {
          _fileName = result['fileName'];
          _excelData = List<Map<String, String>>.from(result['data']);
          _headers = List<String>.from(result['headers']);
          _totalRows = _excelData?.length ?? 0;
        } else {
          _errorMessage = result['message'];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      });
    }
  }

  Future<void> _exportToBackend() async {
    //u can handle ur data here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data ready for export to backend')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Import'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        actions: [
          if (_excelData != null && _excelData!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _exportToBackend,
              tooltip: 'Export to Backend',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _importExcelFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import Excel File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                if (_fileName.isNotEmpty && !_isLoading)
                  Expanded(
                    child: Text(
                      'File: $_fileName (Rows: $_totalRows)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              
            if (_excelData != null && _excelData!.isNotEmpty && _headers != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Excel Data Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDataTable(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: _headers!.map((header) {
              return DataColumn(
                label: Text(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            rows: _excelData!.map((rowData) {
              return DataRow(
                cells: List.generate(_headers!.length, (index) {
                  final columnKey = index.toString();
                  return DataCell(Text(rowData[columnKey] ?? ''));
                }),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}