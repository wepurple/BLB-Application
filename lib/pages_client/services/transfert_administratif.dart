import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBServicesAdministratif extends StatefulWidget {
  const BLBServicesAdministratif({ Key? key }) : super(key: key);

  @override
  _BLBServicesAdministratifState createState() => _BLBServicesAdministratifState();
}

class _BLBServicesAdministratifState extends State<BLBServicesAdministratif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).hintColor,
      appBar: AppBar(
        title: const Text(
          'Transfert Administratif',
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
                child: Image.asset('assets/servicesImages/administratif.png',
                  height: 200, width: 350, fit: BoxFit.cover),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'Partiel ou total, intra ou inter sites, la mobilité de votre entreprise est toujours une opération délicate. Pour optimiser le maintien de votre activité, les équipes BLB Transfert s’appuient sur une méthodologie sans faille qui garantit, dans un temps optimisé, la bonne réalisation de chaque mission. Disposant d’une large palette de services aux entreprises, d’équipes expérimentées, autonomes et réactives, BLB Transfert s’adapte à tous vos besoins.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              AutoSizeText(
                'L’expertise BLB, c’est de nous positionner comme votre véritable partenaire grâce à notre offre complète : l’analyse précise de vos besoins, le suivi rigoureux de vos opérations et la création d’un conseil d’organisation spécifique.Un chef de projet dédié organise les différentes phases de votre déménagement : la préparation, le transfert et l’accueil.',
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
                  )
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                    '- Organiser le mode de stockage \n en fonction des biens stockés',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16
                    )
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.35),
                    child: ClipRRect(
                      child: Image.asset('assets/servicesImages/transfertAdministratif/administratif2.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.1, left: MediaQuery.of(context).size.width * 0.3),
                    child: ClipRRect(
                      child: Image.asset('assets/servicesImages/transfertAdministratif/administratif1.png'),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              AutoSizeText(
                'BLB met en oeuvre une stratégie d’accompagnement pour vos collaborateurs grâce à une communication originale et ludique.',
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