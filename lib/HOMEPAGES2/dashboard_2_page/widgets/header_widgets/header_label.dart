import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class header_label extends StatefulWidget {
  const header_label({super.key});

  @override
  State<header_label> createState() => _header_labelState();
}

class _header_labelState extends State<header_label> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 34),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      height: 78,
      child: Row(
        children: [
          Text(
            "Dashboard",
            style: textStyles.lato_bold(color: Colors.black, fontSize: 20),
          ),
          Spacer(),
          Text("23, Tue, 2035",
              style: textStyles.lato_bold(color: Colors.black, fontSize: 20)),
          SizedBox(
            width: 30,
          ),
          Container(
            width: 1,
            height: 34,
            color: Color(0xffcccccc),
          ),
          SizedBox(
            width: 30,
          ),
          Text("5:46 pm",
              style: textStyles.lato_bold(color: Colors.black, fontSize: 20)),
        ],
      ),
    ));
  }
}
