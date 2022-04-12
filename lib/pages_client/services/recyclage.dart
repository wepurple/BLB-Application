import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBServiceRecyclage extends StatefulWidget {
  const BLBServiceRecyclage({ Key? key }) : super(key: key);

  @override
  _BLBServiceRecyclageState createState() => _BLBServiceRecyclageState();
}

class _BLBServiceRecyclageState extends State<BLBServiceRecyclage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recyclage mobilier',
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
      backgroundColor: Theme.of(context).hintColor,
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
                child: Image.asset('assets/servicesImages/recyclage.png',
                  height: 200, width: 350, fit: BoxFit.contain),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Cette prestation réalisée en collaboration avec l’éco organisme VALDELIA permet d’assurer la traçabilité du mobilier.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/servicesImages/recyclage/valdelia.png',
                  height: 150, width: 350, fit: BoxFit.contain),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'BLB, via sa société MOBI ECO, assure également un rôle de conseil et d’accompagnement à la réflexion la plus adaptée pour le traitement de vos mobiliers en fin de cycle (Mobi Eco).',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/servicesImages/recyclage/mobieco.png',
                  height: 150, width: 350, fit: BoxFit.contain),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'CONSEIL | ASSISTANCE | ACCOMPAGNEMENT',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              AutoSizeText(
                'SOLUTIONS DE VALORISATION DE MOBILIER',
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