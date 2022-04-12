// ignore_for_file: unrelated_type_equality_checks
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BLBAccueil extends StatefulWidget {
  const BLBAccueil({ Key? key }) : super(key: key);

  @override
  _BLBAccueilState createState() => _BLBAccueilState();
}

class _BLBAccueilState extends State<BLBAccueil> {

  // Icon compte //
  bool firebaseConnect = false;

  // Instance //
  User? authFirebase = FirebaseAuth.instance.currentUser;
  CollectionReference<Map<String, dynamic>> collectionFirebase = FirebaseFirestore.instance.collection('utilisateurs_inscrit');

  @override
  void initState() {
    // Si les documents de la collection Firebase et égale à l'uid de l'utilisateur connecté //
    if(collectionFirebase.doc(authFirebase!.uid) == authFirebase!.uid) {
      // Activation de l'accès au compte Firebase
      firebaseConnect = true;
    }
    super.initState();
  }

  // PERMISSION CONTACTS IOS //
  // Aller dans ios/runner/info.plist et ajouté la permission //
  set permissionGranted(bool permissionGranted) {}
  void permissionContactsIOS() async {
    if (Platform.isIOS || Platform.isAndroid) {
      if (await Permission.contacts.isGranted) {
        numeroBlb(url);
      }
      if (await Permission.contacts.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.contacts.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.contacts.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    }
  }

  var url = 'tel://0169214295';

  Future<void> numeroBlb(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Impossible de charger le numéro";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      homePageXValue: 150,
      homePageYValue: 80,
      homePageAngle: -0.3,
      homePageSpeed: 250,
      shadowXValue: 122,
      shadowYValue: 110,
      shadowAngle: -0.375,
      shadowSpeed: 550,
      openIcon: Icon(Icons.menu_open, color: Theme.of(context).hintColor),
      closeIcon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
      shadowColor: Theme.of(context).hintColor,
      backgroundGradient: LinearGradient(
        colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
      ),
      menuPageContent: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/iconSignIn.png',
                width: 100,
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text(
                    "BLB",
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    "Menu",
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
              ),
              Text(
                'Nos Réseaux Sociaux',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () async {
                  var url = 'https://www.facebook.com/blbtransfert/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw "Impossible de charger l'url";
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'BLB Transfert',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () async {
                  var url = 'https://www.linkedin.com/company/blbdemenagement/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw "Impossible de charger l'url";
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.linkedin,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'BLB Transfert',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                'Contacts & Localisations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () async {
                  var url = 'https://blb-fr.com/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw "Impossible de charger l'url";
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.globe,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 22,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'Site Web',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () async {
                  if (Platform.isAndroid) {
                    var urlAndroid = 'tel:+33169214295';
                    if (await canLaunch(urlAndroid)) {
                      await launch(urlAndroid);
                    } else {
                      throw "Impossible de charger le numéro";
                    }
                  }
                  if (Platform.isIOS) {
                    permissionContactsIOS();
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.phone,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'Nous Contacter',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(String url) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                  const url =
                      'https://www.google.fr/maps/place/BLB/@48.6213918,2.3317291,17z/data=!4m12!1m6!3m5!1s0x47e5d9500ea263b3:0x5e42cb6ce37c2107!2sBLB!8m2!3d48.6213883!4d2.3339178!3m4!1s0x47e5d9500ea263b3:0x5e42cb6ce37c2107!8m2!3d48.6213883!4d2.3339178';
                  _launchURL(url);
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.locationArrow,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 19,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'Où sommes-nous ?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                'Informations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                  fontSize: 15,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'MentionsLegales');
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.balanceScaleLeft,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      'Mentions Légales',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        )
      ),
      homePageContent: Scaffold(
        backgroundColor: Theme.of(context).hintColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text('Accueil'),
          actions: [
            firebaseConnect ? Container(
              margin: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/iconSignIn.png',
              ),
            ) : GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Account');
              },
              child: Icon(
                Icons.account_circle,
                color: Theme.of(context).hintColor,
                size: 25,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
            GestureDetector(
              onTap: () async {
                if(authFirebase!.uid.isNotEmpty) {
                  // Méthode de déconnexion Firebase //
                  MethodFirebase().signOut().whenComplete((){
                    Navigator.pushNamedAndRemoveUntil(context, 'LoginPage', ModalRoute.withName('/'));
                  });
                }
              },
              child: Icon(
                Icons.logout,
                color: Theme.of(context).hintColor,
                size: 25,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Slogan(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SectionServices(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              boxServices(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              sponsor(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Slogan() => Text(
    'une EXPERTISE, des PROCESS RIGOUREUX, \ndes COMPÉTENCES & DES VALEURS HUMAINES...',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    ),
  );

  // ignore: non_constant_identifier_names
  Widget SectionServices() => Container(
    margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    child: Row(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          width: 3,
          height: 25,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        Text(
          'Nos services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor
          ),
        )
      ],
    ),
  );

  Widget boxServices() => Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/servicesImages/industriel.jpg',
                          height: 130,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transfert Industriel',
                                style: TextStyle(
                                    fontSize: 18, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'Le transfert d’une unité de production, de machines industrielles, etc..', // choice rapid improuvmentof painting ability
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor)),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'ServicesIndustriel');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Text(
                                    'En savoir plus',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/servicesImages/administratif.png',
                          height: 130,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transfert Administratif',
                                style: TextStyle(
                                    fontSize: 18, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'Partiel ou total, intra ou inter sites, la mobilité de votre entreprise est ect..', // choice rapid improuvmentof painting ability
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor)),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'ServicesAdministratif');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Text(
                                    'En savoir plus',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/servicesImages/stockage.jpg',
                          height: 130,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stockage BLB',
                                style: TextStyle(
                                    fontSize: 18, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'Nos entrepôts sont sous surveillance permanente, gardiennés 24 h/24h et 7j/7',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor)),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'ServicesStockage');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Text(
                                    'En savoir plus',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/servicesImages/recyclage.png',
                          height: 130,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recyclage mobilier',
                                style: TextStyle(
                                    fontSize: 18, color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    'BLB, via sa société MOBI ECO, assure également un rôle de conseil et d’accompagnement à la réflexion la plus adaptée pour le traitement de vos mobiliers en fin de cycle (Mobi Eco) .',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor)),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'ServicesRecyclage');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: const Text(
                                    'En savoir plus',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

      Widget sponsor() => Container(
        margin: const EdgeInsets.only(top: 20),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/leparisien.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/lesechos.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/loreal.png'),
              ),
            ),
            Container(
              width: 120,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/louboutin.png'),
              ),
            ),
            Container(
              width: 180,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/macif.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/mazars.png'),
              ),
            ),
            Container(
              width: 220,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/mcsgroupes.png'),
              ),
            ),
            Container(
              width: 220,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/mondialassistance.png'),
              ),
            ),
            Container(
              width: 220,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/ordrenationaldesmedecins.jpg'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/gefco.png'),
              ),
            ),
            Container(
              width: 190,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/fnac.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/fidal.png'),
              ),
            ),
            Container(
              width: 210,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/euronex.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/étandex.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/eliorgroup.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/ecoemballage.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/cocacola.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/cms.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/capsule.png'),
              ),
            ),
            Container(
              width: 160,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/bel.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/banquepopulaire.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/afd.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/aldebaran.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/atradius.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/ysl.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/vancleef&arpels.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/valdelia.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/solocalgroup.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/safran.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/rothschild&co.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/ricoh.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/pwc.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/primagaz.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/pierre&vacances.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/beaumanoir.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/lafrançaise.png'),
              ),
            ),
            Container(
              width: 200,
              color: Colors.transparent,
              child: Center(
                child: Image.asset('assets/sponsorImage/bdo.png'),
              ),
            ),
          ],
        ),
      );
}