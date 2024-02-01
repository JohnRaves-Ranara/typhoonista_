import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';

class typhoonDocsList extends StatefulWidget {
  const typhoonDocsList({super.key});

  @override
  State<typhoonDocsList> createState() => _typhoonDocsListState();
}

class _typhoonDocsListState extends State<typhoonDocsList> {
  bool underlined = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: StreamBuilder<List<Typhoon>>(
          stream: FirestoreService().streamAllTyphoons(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR", style: textStyles.lato_regular(fontSize: 16),),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: SpinKitSpinningLines(size: 60, lineWidth: 3.5, color: Colors.blue));
            }
             else {
              final List<Typhoon> typhoons = snapshot.data!;

              return ListView(
                children: typhoons
                    .map((typhoon) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          width: double.maxFinite,
                          height: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Typhoon ${typhoon.typhoonName}',
                                style: textStyles.lato_black(fontSize: 22),
                              ),
                              InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onHover: ((bool isHovered) {
                                    setState(() {
                                      if (isHovered) {
                                        underlined = true;
                                      } else {
                                        underlined = false;
                                      }
                                    });
                                  }),
                                  onTap: (() async{

                                    final locations = await FirestoreService().getDistinctLocations(typhoon.id);

                                    
                                    setState(() {
                                      underlined = false;
                                    });
                                    context
                                        .read<page_provider>()
                                        .changeDocumentsPage(2);
                                    context
                                        .read<page_provider>()
                                        .changeSelectedTyphoon(typhoon);
                                    
                                    context.read<page_provider>().changeSelectedLocations(locations);
                                  }),
                                  child: Text(
                                    "View Details    >",
                                    style: textStyles.lato_bold(
                                        fontSize: 18, underlined: underlined),
                                  ))
                            ],
                          ),
                        ))
                    .toList(),
              );
            }
          },
        ))
      ],
    ));
  }
}
