import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';


class header_user_section extends StatefulWidget {
  const header_user_section({super.key});

  @override
  State<header_user_section> createState() => _header_user_sectionState();
}

class _header_user_sectionState extends State<header_user_section> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.white,
        child: Ink(
          height: 78,
          width: 218,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: ((){}),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  height: 55,
                  width: 55,
                  child: CircleAvatar(
                    child: Center(child: Text("J"),),
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("John Doe", style: textStyles.lato_bold(fontSize: 18, color: Colors.black),),
                    Text("DRR Focal", style: textStyles.lato_light(fontSize: 12, color: Colors.black),)
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
