import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class actions extends StatefulWidget {
  const actions({super.key});

  @override
  State<actions> createState() => _actionsState();
}

class _actionsState extends State<actions> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 20,
        child: Column(
          children: [
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                     Container(
                    // color: Colors.red,
                    child: Image.asset('lib/assets/images/basil_add-outline.png', height: 24,)),
                    
                  Text('Add Estimation', style: textStyles.lato_bold(fontSize: 16),),
                  
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
            )),
            SizedBox(height: 15,),
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
               
                  Container(
                    // color: Colors.red,
                    child: Image.asset('lib/assets/images/Vector (1).png', height: 20)),
                  
                  Text('Edit Parameters', style: textStyles.lato_bold(fontSize: 16),),
                  
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
            ),),
            SizedBox(height: 15,),
            Expanded(child: Container(
              
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  Container(
                    // color: Colors.blue,
                    child: Image.asset('lib/assets/images/Vector (2).png', height: 20 ,color: Colors.white,)),
                  
                  Text('Delete Estimation', style: textStyles.lato_bold(fontSize: 16, color: Colors.white),),
                  
                ],
              ),
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
            ),)
          ]
        ));
  }
}
