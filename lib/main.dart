import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/tests/test6.dart';
import 'package:typhoonista_thesis/Home.dart';
import 'package:typhoonista_thesis/Home_2.dart';
import 'package:typhoonista_thesis/LoginScreen.dart';
import 'package:typhoonista_thesis/providers/TyphoonProvider.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/providers/sample_provider.dart';
import 'package:typhoonista_thesis/tests/idk.dart';
import 'package:typhoonista_thesis/tests/idk2.dart';
import 'package:typhoonista_thesis/tests/idk3.dart';
import 'package:typhoonista_thesis/tests/idkkk.dart';
import 'package:typhoonista_thesis/tests/screen2.dart';
import 'package:typhoonista_thesis/tests/test2.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/tests/test4.dart';
import 'package:typhoonista_thesis/tests/textDataProvider.dart';
import 'home_pages/estimator_page/estimator_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    print("WEBB!");
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBSn3pTQvHIDuS1yN1tph1gpFeidCuw5Ko",
            projectId: "typhoonistadb",
            storageBucket: "typhoonistadb.appspot.com",
            messagingSenderId: "598391340065",
            appId: "1:598391340065:web:b20f6cf51eb55d5f9c3760"
            ));
  }

  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SampleProvider()),
        ChangeNotifierProvider(create: (context) => TextDataProvider()),
        ChangeNotifierProvider(create: (context) => page_provider()),
        ChangeNotifierProvider(create: (context) => TyphoonProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Home_2(),
        // home: Consumer<page_provider>(
        //   builder: (context, prov, child){
        //     if(prov.mainpage == 0){
        //       return LoginScreen();
        //     }
        //     else{
        //       return Home();
        //     }
        //   }
        //   ),
      ),
    );
  }
}
