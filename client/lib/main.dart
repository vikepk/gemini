import 'package:flutter/material.dart';
import 'package:gemini/features/getstarted/welcome.dart';
import 'package:gemini/features/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import './service/connectivity_services.dart';
import 'package:lottie/lottie.dart';

late SharedPreferences prefs;
//declared and intialised in main dart so can be used in all files as import
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/env/.env");
  prefs = await SharedPreferences.getInstance();
  final connectivityService = ConnectivityService();
  runApp(MyApp(
    token: prefs.getString('token'),
    connectivityService: connectivityService,
  ));
}

class MyApp extends StatefulWidget {
  var token;
  final ConnectivityService connectivityService;
  MyApp({super.key, required this.token, required this.connectivityService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasInternetConnection = true;
  void initState() {
    super.initState();

    // Listen to connectivity changes
    widget.connectivityService.connectionStream.listen((hasConnection) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = hasConnection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternetConnection) {
      return MaterialApp(
        theme: ThemeData(fontFamily: "NotoSans"),
        title: 'No Connectivity',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lottie/network_error.json")
                // Text('Check Your Network Connection', style: KTitle1),
              ],
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(fontFamily: "NotoSans"),
        debugShowCheckedModeBanner: false,
        home: (widget.token != null && !JwtDecoder.isExpired(widget.token))
            ? Home(
                token: widget.token,
              )
            : Welcome(),
      );
    }
  }
}
