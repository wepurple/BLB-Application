import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBServicesStockage extends StatefulWidget {
  const BLBServicesStockage({ Key? key }) : super(key: key);

  @override
  _BLBServicesStockageState createState() => _BLBServicesStockageState();
}

class _BLBServicesStockageState extends State<BLBServicesStockage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).hintColor,
      appBar: AppBar(
        title: const Text(
          'Stockage BLB',
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
                child: Image.asset('assets/servicesImages/stockage.jpg',
                  height: 200, width: 350, fit: BoxFit.cover),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Nos entrepôts sont situés à 28 kilomètres de Paris sur la commune de Sainte Geneviève des Bois (91700), au 4, rue de la Fosse aux Leux.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Nos entrepôts sont sous surveillance permanente, gardiennés 24 h/24h et 7j/7. Alarmes anti-incendie et caméras anti intrusions complètent le système de sécurité.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Nos entrepôts sont aménagés de façon à :',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                    '- Optimiser les flux',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16
                    ),
                  ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                    '- Organiser le mode de Stockage\n en fonction des biens stockés',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16
                    ),
                  ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                    '- Gérer les stocks',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16
                    ),
                  ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Nos entrepôts disposent d’une aire de chargement et déchargement des véhicules.',
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