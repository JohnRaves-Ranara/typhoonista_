import 'package:flutter/material.dart';

class actions extends StatefulWidget {
  const actions({super.key});

  @override
  State<actions> createState() => _actionsState();
}

class _actionsState extends State<actions> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 25,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9c9797).withOpacity(1),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9c9797).withOpacity(1),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9c9797).withOpacity(1),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9c9797).withOpacity(1),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ));
  }
}
