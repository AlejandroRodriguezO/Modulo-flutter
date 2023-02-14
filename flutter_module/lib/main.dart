import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'res/color.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.souvikbiswas.tipsy/result');

  String splitAmount = '';
  int personCount = 0;
  int percent = 0;

  Future<void> _receiveFromHost(MethodCall call) async {
    dynamic jData;

    try {
      print(call.method);

      if (call.method == "getCalculatedResult") {
        final String data = call.arguments;
        print(call.arguments);
        jData = await jsonDecode(data);
      }
    } on PlatformException catch (error) {
      print(error);
    }

    setState(() {
      splitAmount = jData['amount'];
      personCount = jData['count'];
      percent = jData['percent'];
    });
  }

  @override
  void initState() {
    platform.setMethodCallHandler(_receiveFromHost);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: screenHeight * 0.3,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Total per person',
                    style: TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    splitAmount,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: CustomColor.primaryLight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Split between $personCount people with $percent% tip',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColor.primaryDark),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'RECALCULATE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Text(splitAmount),
            // Text(personCount.toString()),
            // Text(percent.toString())
          ],
        ),
      ),
    );
  }
}
