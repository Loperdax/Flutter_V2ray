import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //vars
  bool isActive = false;
  late SharedPreferences _prefs;
  late Timer _timer;
  Duration _remainingTime = const Duration(hours: 0);
  bool showInformation = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadRemainingTime();
  }

  Duration _loadRemainingTime() {
    final savedTime = _prefs.getInt('remaining_time');
    if (savedTime != null) {
      setState(() {
        _remainingTime = Duration(seconds: savedTime);
      });
    }
    return _remainingTime;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
        _prefs.setInt('remaining_time', _remainingTime.inSeconds);
      } else {
        disconnectVpn();
        _timer.cancel();
        _showTimeEndedDialog();
      }
    });
  }

  void connectVpn() {
    if (!isActive) {
      _initPreferences().then((_) {
        if (_loadRemainingTime().inSeconds <= 0) {
          _showTimeEndedDialog();
          return;
        }

        _startTimer();

        setState(() {
          isActive = true;
        });

        // Implement your VPN connection logic here
        // Example:
        // connectVpnFunction();
      });
    }
  }

  void disconnectVpn() {
    if (isActive) {
      _timer.cancel();

      setState(() {
        isActive = false;
      });
      // Implement your VPN disconnection logic here
      // Example:
      // disconnectVpnFunction();
    }
  }

  void showAd() {
    setState(() {
      _remainingTime += const Duration(minutes: 5);
    });
    _prefs.setInt('remaining_time', _remainingTime.inSeconds);
    Navigator.pop(context);
  }

  void toggleState() {
    if (isActive) {
      disconnectVpn();
    } else {
      connectVpn();
    }
  }

  void _showTimeEndedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your time has ended!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to watch an ad to recharge your time?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                showAd();
              },
              child: const Text('Show Ad'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePageBgColorLight,
      appBar: AppBar(
        backgroundColor: appBarBgColorLight,
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: appBarIconColorLight),
        actionsIconTheme: const IconThemeData(color: appBarActionsColorLight),
        title: const Text(
          "Khalil Vpn",
          style: TextStyle(color: appBarTextColorLight),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/drawer_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/user.png'),
                          ),
                        ),
                        SizedBox(height: 5),
                        ],
                    ),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl ,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Implement settings logic
                },
                trailing: const Icon(Icons.arrow_forward_outlined),
                
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl ,
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  // Implement information logic
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start Vpn Button
                  InkWell(
                    onTap: () {
                      toggleState();
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: isActive == true
                                ? homePageStopVpnOutsideColorLight
                                : homePageStartVpnOutsideColorLight,
                            shape: BoxShape.circle),
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                              color: isActive == true
                                  ? homePageStopVpnInsideColorLight
                                  : homePageStartVpnInsideColorLight,
                              shape: BoxShape.circle),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.power_settings_new,
                                size: 30,
                                color: isActive == true
                                    ? homePageStopVpnPowerColorLight
                                    : homePageStartVpnPowerColorLight,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isActive == true ? "Stop" : "Start",
                                style: TextStyle(
                                    color: isActive == true
                                        ? homePageStopVpnTextColorLight
                                        : homePageStartVpnTextColorLight,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_remainingTime.inHours}:${(_remainingTime.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 20),
                  ),

                  // Status
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: isActive == true
                            ? homePageStopVpnStatusZoneBgColor.withOpacity(0.5)
                            : homePageStartVpnStatusZoneBgColor
                                .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        // replace with Vpn Status and process jobs name
                        isActive == true ? "Connected" : "Not Connected",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showInformation = !showInformation;
                      });
                    },
                    child: Text(showInformation
                        ? 'Hide Information'
                        : 'Show Information'),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: showInformation ? 130 : 0,
                    width: double.infinity,
                    curve: Curves.easeInOut,
                    child: showInformation
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.blue,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text("Duration: 10:10:10"),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Speed:'),
                                      SizedBox(width: 10),
                                      Text("150 KB/s"),
                                      Text('↑'),
                                      SizedBox(width: 10),
                                      Text("150 KB/s"),
                                      Text('↓'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Traffic:'),
                                      SizedBox(width: 10),
                                      Text("25.5 GB"),
                                      Text('↑'),
                                      SizedBox(width: 10),
                                      Text("15 GB"),
                                      Text('↓'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),

            // Ad Placeholder

            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              color: Colors.grey[500],
              height: 50,
              width: double.infinity,
              child: const Text(
                  'Banner Ad Placeholder'), // Text to indicate it's an ad placeholder
            ),
          ],
        ),
      ),
    );
  }
}
