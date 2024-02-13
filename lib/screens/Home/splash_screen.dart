import 'package:flutter/material.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.push(
          context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Image.asset(
                "assets/logo/logo.png" ,
              height: 100,
              width: 100,
            ),
            const Text("khalil Vpn")
          ],
        ),
      ),
    );
  }
}
