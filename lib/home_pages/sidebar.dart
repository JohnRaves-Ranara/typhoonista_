import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/sidebar_widgets/settings.dart';
import 'sidebar_widgets/overview.dart';
import 'sidebar_widgets/logo.dart';


class sidebar extends StatelessWidget {
  const sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2))),
      padding: EdgeInsets.symmetric(vertical: 30),
      height: double.infinity,
      width: 225,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo(),
          overview(),
          Spacer(),
          settings()
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:typhoonista_thesis/home_pages/sidebar_widgets/settings.dart';
// import 'sidebar_widgets/overview.dart';
// import 'sidebar_widgets/logo.dart';


// class sidebar extends StatelessWidget {
//   const sidebar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   offset: Offset(2, 0), // Only shadow to the right
//                   blurRadius: 2,
//                   spreadRadius: 2,
//                 ),
//               ],
//         ),
//       padding: EdgeInsets.symmetric(vertical: 30),
//       height: double.infinity,
//       width: 225,
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           logo(),
//           overview(),
//           Spacer(),
//           settings()
//         ],
//       ),
//     );
//   }
// }