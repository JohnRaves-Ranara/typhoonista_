import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class generate_doc extends StatefulWidget {
  const generate_doc({super.key});

  @override
  State<generate_doc> createState() => _generate_docState();
}

class _generate_docState extends State<generate_doc> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      // color: Colors.red,
                      child: Image.asset('lib/assets/images/Vector (1).png',
                          height: 20)),
                  Text(
                    'Documents',
                    style: textStyles.lato_bold(fontSize: 16),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
  }
}