import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class typhoon_averages_overview extends StatefulWidget {
  const typhoon_averages_overview({super.key});

  @override
  State<typhoon_averages_overview> createState() =>
      _typhoon_averages_overviewState();
}

class _typhoon_averages_overviewState extends State<typhoon_averages_overview> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 30,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
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
                  child: 
                  //todo, not expanding, idk i need the row max in order to expand. expanded not behaving as i expected ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        StreamBuilder(
                          stream: FirestoreService2().streamOngoingTyphoon(),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              Typhoon ongoingTyphoon = snapshot.data!;
                              return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("₱ ${NumberFormat('#,##0.00', 'en_US').format(ongoingTyphoon.totalDamageCost)}", style: textStyles.lato_bold(fontSize: 30),),
                              SizedBox(height: 10,),
                              Text("Total Rice Crop Damage Cost of Typhoon ${ongoingTyphoon.typhoonName}", style: textStyles.lato_bold(fontSize: 14),)
                            ],
                          );
                            }else{
                              return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No data.", style: textStyles.lato_bold(fontSize: 30),),
                              SizedBox(height: 10,),
                              Text("Total Rice Crop Damage Cost of Typhoon Hevabi", style: textStyles.lato_bold(fontSize: 14),)
                            ],
                          );
                            }
                          },
                        ),
                      ],
                    ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        flex: 30,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("30%", style: textStyles.lato_bold(fontSize: 26),),
                              SizedBox(height: 15,),
                              Text("Avg. Increase/Day", style: textStyles.lato_bold(fontSize: 12),)

                              ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 3),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ]),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 70,
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("1,325,697.24", style: textStyles.lato_bold(fontSize: 26),),
                              SizedBox(height: 15,),
                              Text("Avg. Damage/Day", style: textStyles.lato_bold(fontSize: 11),)
                              ],
                          ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(0, 3),
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
