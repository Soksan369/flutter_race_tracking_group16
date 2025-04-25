import 'package:flutter/material.dart';

class ResultTableHeader extends StatelessWidget {
  const ResultTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: const [
            Expanded(
              flex: 1,
              child: Text(
                'Rank',
                style: TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Times',
                style: TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'ID',
                style: TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}