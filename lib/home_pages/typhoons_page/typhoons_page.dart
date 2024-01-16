import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class typhoons_page extends StatefulWidget {
  const typhoons_page({super.key});

  @override
  State<typhoons_page> createState() => _typhoons_pageState();
}

class _typhoons_pageState extends State<typhoons_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Typhoons",
                    style: textStyles.lato_black(fontSize: 32),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The impact of the industrial revolution has began to uprise in terms of the rice and skermberlu it ornare accumsan. Justo vulputate in pretium integer vulputate vitae proin congue etiam. Sollicitudin egestas est in ultrices molestie lacus iaculis risus. Velit habitasse felis auctor at.",
                    style: textStyles.lato_light(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(height: 25,),
            Expanded(
              child: StreamBuilder<List<Typhoon>>(
                stream: FirestoreService().streamAllTyphoons(),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text("ERROR"),);
                  }
                  else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return Center(child: Text("No data."),);
                  }
                  else{
                    final List<Typhoon> typhoons = snapshot.data!;
              
                    return ListView(
                      children: typhoons.map((typhoon) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: double.maxFinite,
                        height: 80,
                        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Typhoon ${typhoon.typhoonName}', style: textStyles.lato_black(fontSize: 22),),
                            Text("View Details    >", style: textStyles.lato_bold(fontSize: 18),)
                          ],
                        ),
                      )).toList(),
                    );
                  }
                },
              )
            )
          ],
        )
        );
  }
}