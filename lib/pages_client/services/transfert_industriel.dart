import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBServicesIndustriel extends StatefulWidget {
  const BLBServicesIndustriel({ Key? key }) : super(key: key);

  @override
  _BLBServicesIndustrielState createState() => _BLBServicesIndustrielState();
}

class _BLBServicesIndustrielState extends State<BLBServicesIndustriel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).hintColor,
      appBar: AppBar(
        title: const Text(
          'Transfert Industriel',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 18,
            color: Theme.of(context).hintColor,
          ),
          splashRadius: 15,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            right: 15,
            left: 15
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/servicesImages/transfertIndustriel/industriel.jpg',
                  height: 200, width: 350, fit: BoxFit.cover),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Le transfert d’une unité de production, de stocks, de matières premières, de produits, de machines industrielles, obéit à des règles strictes.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Nos techniciens maîtrisent parfaitement les process d’environnement pour préparer la chronologie des opérations et limiter l’impact sur la production.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Ils définiront les outils de levage adaptés aux poids et dimensions des machines pour la parfaite préservation de vos matériels.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        )
      ),
    );
  }
}