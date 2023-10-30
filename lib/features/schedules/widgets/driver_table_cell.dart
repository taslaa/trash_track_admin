import 'package:flutter/material.dart';

class DriverTableCellWidget extends StatelessWidget {
  final Future<List<String>> textFuture;
  final Color textColor;

  DriverTableCellWidget({
    required this.textFuture,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: textFuture,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); 
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final textList = snapshot.data ?? [];
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color(0xFFE0D8E0),
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: textList.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  textList[index],
                  style: TextStyle(
                    color: textColor,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
