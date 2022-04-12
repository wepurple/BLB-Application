// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MentionsLegales extends StatefulWidget {
  const MentionsLegales({ Key? key }) : super(key: key);

  @override
  _MentionsLegalesState createState() => _MentionsLegalesState();
}

class _MentionsLegalesState extends State<MentionsLegales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 74, 150, 1),
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
        title: Text(
          'CGU',
          style: TextStyle(
            color: Theme.of(context).hintColor,
          ),
        ),
        elevation: 5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              child: Column(
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'Conditions générales d\'utilisation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Color.fromRGBO(23, 74, 150, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'En vigueur au 06/08/2021',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Les présentes conditions générales d'utilisation (dites « CGU ») ont pour objet l'encadrement juridique des modalités de mise à disposition du site et des services par BLB Transfert  et de définir les conditions d’accès et d’utilisation des services par « l'Utilisateur ». Les présentes CGU sont accessibles sur le site à la rubrique «CGU».",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Article 1 : Les mentions légales',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'L\'édition du site https://blb-fr.com/ est assurée par la Société SASU BLB Transfert au capital de 50.000 euros, immatriculée au RCS de SAINTE-GENEVIEVE-DES-BOIS sous le numéro 483205647, dont le siège social est situé au 4 RUE DE LA FOSSE AUX LEUX 91700 SAINTE-GENEVIEVE-DES-BOIS\n\nNuméro de téléphone 01 69 21 42 95\nAdresse e-mail : blb@blb-fr.com.\nLe Directeur de la publication est : BLANCHEMAIN Michael\nNuméro de TVA intracommunautaire : FR65483205647',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'L\'hébergeur du site https://blb-fr.com/ est la société IONOS, dont le siège social est situé au 7 Pl. de la Gare - 57200 Sarreguemines, avec le numéro de téléphone : 09 70 80 89 11.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 2 : Accès au site",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Le site https://blb-fr.com/ permet à l'Utilisateur un accès gratuit aux services suivants :\nLe site internet propose les services suivants :\nServices FACTOTUM aux entreprises\nLe site est accessible gratuitement en tout lieu à tout Utilisateur ayant un accès à Internet. Tous les frais supportés par l'Utilisateur pour accéder au service (matériel informatique, logiciels, connexion Internet, etc.) sont à sa charge.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 3 : Collecte des données",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Le site est exempté de déclaration à la Commission Nationale Informatique et Libertés (CNIL) dans la mesure où il ne collecte aucune donnée concernant les Utilisateurs.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 4 : Propriété intellectuelle",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Les marques, logos, signes ainsi que tous les contenus du site (textes, images, son…) font l'objet d'une protection par le Code de la propriété intellectuelle et plus particulièrement par le droit d'auteur.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "La marque BLB est une marque déposée par BLB Transfert.Toute représentation et/ou reproduction et/ou exploitation partielle ou totale de cette marque, de quelque nature que ce soit, est totalement prohibée.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "L'Utilisateur doit solliciter l'autorisation préalable du site pour toute reproduction, publication, copie des différents contenus. Il s'engage à une utilisation des contenus du site dans un cadre strictement privé, toute utilisation à des fins commerciales et publicitaires est strictement interdite. Toute représentation totale ou partielle de ce site par quelque procédé que ce soit, sans l’autorisation expresse de l’exploitant du site Internet constituerait une contrefaçon sanctionnée par l’article L 335-2 et suivants du Code de la propriété intellectuelle. Il est rappelé conformément à l’article L122-5 du Code de propriété intellectuelle que l’Utilisateur qui reproduit, copie ou publie le contenu protégé doit citer l’auteur et sa source.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 5 : Responsabilité",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Les sources des informations diffusées sur le site https://blb-fr.com/ sont réputées fiables mais le site ne garantit pas qu’il soit exempt de défauts, d’erreurs ou d’omissions. Les informations communiquées sont présentées à titre indicatif et général sans valeur contractuelle. Malgré des mises à jour régulières, le site https://blb-fr.com/ ne peut être tenu responsable de la modification des dispositions administratives et juridiques survenant après la publication. De même, le site ne peut être tenue responsable de l’utilisation et de l’interprétation de l’information contenue dans ce site. Le site https://blb-fr.com/ ne peut être tenu pour responsable d’éventuels virus qui pourraient infecter l’ordinateur ou tout matériel informatique de l’Internaute, suite à une utilisation, à l’accès, ou au téléchargement provenant de ce site. La responsabilité du site ne peut être engagée en cas de force majeure ou du fait imprévisible et insurmontable d'un tiers.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 6 : Liens hypertextes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Des liens hypertextes peuvent être présents sur le site. L’Utilisateur est informé qu’en cliquant sur ces liens, il sortira du site https://blb-fr.com/. Ce dernier n’a pas de contrôle sur les pages web sur lesquelles aboutissent ces liens et ne saurait, en aucun cas, être responsable de leur contenu.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 7 : Cookies",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "L’Utilisateur est informé que lors de ses visites sur le site, un cookie peut s’installer automatiquement sur son logiciel de navigation. Les cookies sont de petits fichiers stockés temporairement sur le disque dur de l’ordinateur de l’Utilisateur par votre navigateur et qui sont nécessaires à l’utilisation du site https://blb-fr.com/. Les cookies ne contiennent pas d’information personnelle et ne peuvent pas être utilisés pour identifier quelqu’un. Un cookie contient un identifiant unique, généré aléatoirement et donc anonyme. Certains cookies expirent à la fin de la visite de l’Utilisateur, d’autres restent. L’information contenue dans les cookies est utilisée pour améliorer le site https://blb-fr.com/. En naviguant sur le site, L’Utilisateur les accepte. L’Utilisateur pourra désactiver ces cookies par l’intermédiaire des paramètres figurant au sein de son logiciel de navigation.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "ARTICLE 8 : Droit applicable et juridiction compétente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(23, 74, 150, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "La législation française s'applique au présent contrat. En cas d'absence de résolution amiable d'un litige né entre les parties, les tribunaux français seront seuls compétents pour en connaître. Pour toute question relative à l’application des présentes CGU, vous pouvez joindre l’éditeur aux coordonnées inscrites à l’ARTICLE 1.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}