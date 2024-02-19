// import 'package:flutter/material.dart';

// class test5 extends StatefulWidget {
//   const test5({super.key});

//   @override
//   State<test5> createState() => _test5State();
// }

// class _test5State extends State<test5> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Column(
//           children: owners
//               .map(
//                 (owner) => Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: 
//                   Row(
//                     children: [
//                       Consumer<SampleProvider>(
//                         builder: (context, prov, _) {
//                           Set<Owner> selectedOwners = prov.selectedOwners;
//                           return Container(
//                             child: (!selectedOwners.contains(owner))
//                                 ? GestureDetector(
//                                     onTap: (() {
//                                       prov.addSelectedOwner(owner);
//                                     }),
//                                     child: Icon(Icons.visibility_outlined))
//                                 : GestureDetector(
//                                     onTap: (() {
//                                       prov.removeSelectedOwner(owner);
//                                     }),
//                                     child: Icon(Icons.visibility)),
//                           );
//                         },
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       CircleAvatar(
//                         radius: 10,
//                         backgroundColor: owner.colorMarker.withOpacity(0.5),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//         Spacer(),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: owners
//               .map(
//                 (owner) => Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: 
//                   Text(
//                     owner.ownerName,
//                     style: textStyles.lato_light(fontSize: 16),
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//         Spacer(),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: owners
//               .map(
//                 (owner) => Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: 
//                   Text(
//                     "${NumberFormat('#,##0.00', 'en_US').format(owner.totalDamageCost)}",
//                     style: textStyles.lato_light(fontSize: 16),
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//       ],
//     );
//   }
// }
