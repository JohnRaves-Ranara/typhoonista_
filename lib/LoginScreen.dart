import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/Home.dart';
import 'package:typhoonista_thesis/Home_2.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'assets/themes/textStyles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usercontroller = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image(
            image: AssetImage("lib/assets/images/login_screen_bg.png"),
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            // fit: BoxFit.cover,
          ),
          Positioned(
            top: 30,
            left: 30,
            child: Row(
              children: [
                Image(
                  image: AssetImage(
                      "lib/assets/images/typhoonista_logo_white.png"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "TYPHOONISTA",
                  style:
                      textStyles.lato_black(fontSize: 25, color: Colors.white),
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(-5, 0), // Shadow to the left
                    blurRadius: 10,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Container(
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        "Login",
                        style: textStyles.lato_black(fontSize: 45),
                      ),
                    ),
                    Container(
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Spacer(),
                          Image.asset(
                            'lib/assets/images/largevector_2.png',
                            height: MediaQuery.of(context).size.height*0.5,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          TextField(
                        controller: usercontroller,
                        style: textStyles.lato_regular(),
                        decoration: InputDecoration(
                            labelStyle: textStyles.lato_light(
                                color: Colors.grey.withOpacity(0.9)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Username"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passController,
                        style: textStyles.lato_regular(),
                        decoration: InputDecoration(
                            labelStyle: textStyles.lato_light(
                                color: Colors.grey.withOpacity(0.9)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600.withOpacity(0.5),
                                    width: 1,
                                    style: BorderStyle.solid)),
                            labelText: "Password"),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: (() {
                          if (usercontroller.text.trim() == "admin" &&
                              passController.text.trim() == "admin") {
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => route.isFirst);
                            // context.read<page_provider>().changeMainPage(1);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_2()));
                          }
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          width: double.maxFinite,
                          height: 55,
                          child: Row(
                            children: [
                              Text(
                                "Login",
                                style: textStyles.lato_bold(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_right_alt_sharp,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
