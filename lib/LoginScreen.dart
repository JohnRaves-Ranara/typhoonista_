import 'package:flutter/material.dart';
import 'assets/themes/textStyles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  image: AssetImage("lib/assets/images/typhoonista_logo.png"),
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
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.4,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: textStyles.lato_black(fontSize: 45),
                  ),
                  Spacer(),
                  TextField(
                    style: textStyles.lato_regular(),
                    decoration: InputDecoration(
                        labelStyle: textStyles.lato_light(
                            color: Colors.grey.withOpacity(0.9)),
                        border: OutlineInputBorder(),
                        labelText: "Username"),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    style: textStyles.lato_regular(),
                    decoration: InputDecoration(
                        labelStyle: textStyles.lato_light(
                            color: Colors.grey.withOpacity(0.9)),
                        border: OutlineInputBorder(),
                        labelText: "Password"),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
