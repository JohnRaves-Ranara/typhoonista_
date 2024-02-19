import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/add_estimation.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/add_typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/delete_comp.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/edit_params.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/generate_doc.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/dashboard_2_page/widgets/dashboard_2_content_widgets/actions_and_overview_widgets/actions/mark_finished.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/locations_.dart';


class actions extends StatefulWidget {
  const actions({super.key});

  @override
  State<actions> createState() => _actionsState();
}

class _actionsState extends State<actions> {
  final windspeedCtlr = TextEditingController();
  final rainfall6Ctlr = TextEditingController();
  final rainfall24Ctlr = TextEditingController();
  final ricePriceCtlr = TextEditingController();
  final ctrlr = TextEditingController();
  final manualDistanceCtrlr = TextEditingController();
  String selectedMunicipalName = "Select Location";
  String selectedMunicipalCode = "";
  String selectedLocationProvname = "";
  TyphoonDay? newlyAddedDayInformation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 30,
        child: Row(children: [
          Expanded(
              child: Column(
            children: [
              add_estimation(),
              SizedBox(
                height: 15,
              ),
              edit_params(),
              SizedBox(
                height: 15,
              ),
              delete_comp()
            ],
          )),
          SizedBox(width: 15,),
          Expanded(
              child: Column(
            children: [
              add_typhoon(),
              SizedBox(
                height: 15,
              ),
              mark_finished(),
              SizedBox(
                height: 15,
              ),
              stats()
            ],
          ))
        ]));
  }
}
