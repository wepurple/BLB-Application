// @dart=2.9
import 'package:blb_entreprise/pages_auth/login/login.dart';
import 'package:blb_entreprise/pages_auth/register/register.dart';
import 'package:blb_entreprise/pages_client/mentions/mentions_legales.dart';
import 'package:blb_entreprise/pages_client/services/recyclage.dart';
import 'package:blb_entreprise/pages_client/services/stockage.dart';
import 'package:blb_entreprise/pages_client/services/transfert_administratif.dart';
import 'package:blb_entreprise/pages_client/services/transfert_industriel.dart';
import 'package:blb_entreprise/pages_entreprise/dashboard/Admin/dashboardUtilisateurs.dart';
import 'package:blb_entreprise/pages_globales/headBarPages/account.dart';
import 'package:blb_entreprise/pages_globales/qrscanner.dart';
import 'package:blb_entreprise/pages_start/navigationbar/navigation_bar.dart';
import 'package:blb_entreprise/pages_start/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Initialisation des widgets //
  WidgetsFlutterBinding.ensureInitialized();
  // Initialisation de firebase //
  await Firebase.initializeApp();
  runApp(BLBEntrepriseStart());
}

// ignore: use_key_in_widget_constructors
class BLBEntrepriseStart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Ne pas orienter le téléphone //
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Configuration globale de l'application //
    return MaterialApp(
      title: 'BLB',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(23, 74, 150, 1),
        brightness: Brightness.light,
        hintColor: Colors.white,
        focusColor: Colors.black,
        errorColor: Colors.red,
        hoverColor: const Color.fromRGBO(23, 74, 150, 1),
        shadowColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const BLBSplashScreen(),
      initialRoute: '/',
      routes: {
        'LoginPage': (context) => const BLBLoginPage(),
        'RegisterPage': (context) => const BLBRegisterPage(),
        'NavigationBar': (context) => const BLBNavigationBar(),
        'ServicesIndustriel': (context) => const BLBServicesIndustriel(),
        'ServicesAdministratif': (context) => const BLBServicesAdministratif(),
        'ServicesStockage': (context) => const BLBServicesStockage(),
        'ServicesRecyclage': (context) => const BLBServiceRecyclage(),
        'Account': (context) => const BLBAccount(),
        'MentionsLegales': (context) => const MentionsLegales(),
        'Scanner':(context) => const BLBQrScanner(),
        'RefreshPageRole': (context) => const BLBDashBoardUtilisateurs()
      },
    );
  }
}
