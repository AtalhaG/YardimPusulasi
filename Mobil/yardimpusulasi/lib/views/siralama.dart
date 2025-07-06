import 'package:flutter/material.dart';

class SiralamaPage extends StatelessWidget {
  const SiralamaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF222222)),
            dataRowColor: MaterialStateProperty.all(const Color(0xFF181818)),
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('Kolon 1', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 2', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 3', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 4', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 5', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 6', style: TextStyle(color: Colors.white))),
              DataColumn(label: Text('Kolon 7', style: TextStyle(color: Colors.white))),
            ],
            rows: List.generate(10, (index) => DataRow(
              cells: List.generate(7, (col) => DataCell(
                Text('Veri ${index + 1}.${col + 1}', style: const TextStyle(color: Colors.white)),
              )),
            )),
          ),
        ),
      ),
    );
  }
}
