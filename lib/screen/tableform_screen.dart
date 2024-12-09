import 'package:flutter/material.dart';
import 'package:grad_proj/screen/orgappbar.dart';
import 'navbar_screen.dart';
import 'text_style.dart';

class TableformScreen extends StatefulWidget {
  const TableformScreen({super.key});

  @override
  State<TableformScreen> createState() => _TableformScreenState();
}

class _TableformScreenState extends State<TableformScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> headers = ['Day', 'Courses', 'Hour',];
  final List<List<String>> rows = [
    ['Monday', 'Maths', 'M101', ],
    ['Tuesday', 'Physics', 'P202',],
    ['Wednesday', 'Chemistry', 'C303', ],
    ['Thursday', 'Biology', 'B404', ],
    ['Friday', 'English', 'E505', ],
    ['starday', 'English', 'E505', ],
  ];

  // Helper function to build a table row
  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader
          ? const BoxDecoration(color: Color(0xff7AB2D3))
          : null,
      children: cells
          .map(
            (cell) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: isHeader
                ? const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)
                : const TextStyle(),
          ),
        ),
      )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( key:  scaffoldKey,
      appBar: Orgappbar(scaffoldKey: scaffoldKey),
      drawer: const NavbarScreen(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Table',
                  style: TextStyles.text,
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(), // Adds a border to the table
                  columnWidths: const {
                    0: FixedColumnWidth(100),
                    1: FlexColumnWidth(100),
                    2: FlexColumnWidth(100),

                  },
                  children: [
                    buildTableRow(headers, isHeader: true),
                    ...rows.map((row) => buildTableRow(row)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}