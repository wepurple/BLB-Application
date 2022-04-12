// ignore_for_file: file_names
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class BLBDevisPDF extends StatefulWidget {
  const BLBDevisPDF({ Key? key }) : super(key: key);

  @override
  _BLBDevisPDFState createState() => _BLBDevisPDFState();
}

class _BLBDevisPDFState extends State<BLBDevisPDF> {

  // Clé globale du formulaire de devis PDF //
  final _keyFormPdf = GlobalKey<FormState>();

  // Controlleur de formulaire principale //
  final _controllerNomRemplisseur = TextEditingController();
  final _controllerNomFiche = TextEditingController();
  final _controllerNumeroDossier = TextEditingController();
  final _controllerVolume = TextEditingController();
  final _controllerProvenance = TextEditingController();
  final _controllerVisite = TextEditingController();
  final _controllerDate = TextEditingController();
  final _controllerHeure = TextEditingController();
  final _controllerSociete = TextEditingController();
  final _controllerContact = TextEditingController();
  final _controllerTelephone = TextEditingController();
  final _controllerFax = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerAdresseFacturation = TextEditingController();
  final _controllerPt = TextEditingController();

  // Controlleur de formulaire tableau de chargement //
  final _controllerDateChargement = TextEditingController();
  final _controllerAdresseChargement1 = TextEditingController();
  final _controllerAdresseChargement2 = TextEditingController();
  final _controllerAdresseChargement3 = TextEditingController();
  final _controllerBatChargement = TextEditingController();
  final _controllerAscChargement = TextEditingController();
  final _controllerEtageChargement = TextEditingController();
  final _controllerMMChargement = TextEditingController();
  final _controllerMoyenPrecoChargement = TextEditingController();

  // Controlleur de formulaire tableau de livraison //
  final _controllerDateLivraison = TextEditingController();
  final _controllerAdresseLivraison1 = TextEditingController();
  final _controllerAdresseLivraison2 = TextEditingController();
  final _controllerAdresseLivraison3 = TextEditingController();
  final _controllerBatLivraison = TextEditingController();
  final _controllerAscLivraison = TextEditingController();
  final _controllerEtageLivraison = TextEditingController();
  final _controllerMMLivraison = TextEditingController();
  final _controllerMoyenPrecoLivraison = TextEditingController();

  // Controlleur de formulaire tableau de transfert //
  int _currentPosteInfoValue = 0;
  int _currentImprimanteValue = 0;
  int _currentCartonValue = 0;
  int _currentfoisonnementValue = 0;
  int _currentarmoiresRoulantesValue = 0;
  int _currentbureauSimpleValue = 0;
  int _currentbenchValue = 0;
  int _currentarmoireHauteValue = 0;
  int _currentarmoireBasseValue = 0;
  int _currenttableValue = 0;
  int _currenttableRondeValue = 0;
  int _currentchaiseValue = 0;
  int _currentetagereValue = 0;
  int _currentphotocopieurValue = 0;
  int _currentcoffrefortValue = 0;
  int _currentcanapeValue = 0;
  int _currentplanteValue = 0;

  // Categories Erreur //
  bool informationsCategorieError = false;

  // Si certains controllers ne sont pas remplis //
  var emptyController = '//';

  // PERMISSION FICHIER //
  set permissionGranted(bool permissionGranted) {}
  void permissionStorage() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        setState(() {
          // Vérifications des champs de textes
          inputPDF();
        });
      }
      if (await Permission.manageExternalStorage.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.manageExternalStorage
          .request()
          .isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.manageExternalStorage.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    }
  }

  Future<void> inputPDF() async {
    // Si le formulaire est validé, que la permission d'accès au fichier et validé et que certains champs on été remplis //
    if(_keyFormPdf.currentState!.validate()) {
      try {
        setState(() {
          informationsCategorieError = false;
        });
        _createPDF();
        if (_controllerVolume.text.isEmpty ||
              _controllerProvenance.text.isEmpty ||
              _controllerVisite.text.isEmpty ||
              _controllerDate.text.isEmpty ||
              _controllerHeure.text.isEmpty ||
              _controllerContact.text.isEmpty ||
              _controllerTelephone.text.isEmpty ||
              _controllerFax.text.isEmpty ||
              _controllerPt.text.isEmpty ||
              _controllerEmail.text.isEmpty ||
              _controllerAdresseFacturation.text.isEmpty ||
              _controllerDateChargement.text.isEmpty ||
              _controllerDateLivraison.text.isEmpty ||
              _controllerAdresseChargement1.text.isEmpty ||
              _controllerAdresseLivraison1.text.isEmpty ||
              _controllerAdresseChargement2.text.isEmpty ||
              _controllerAdresseLivraison2.text.isEmpty ||
              _controllerAdresseChargement3.text.isEmpty ||
              _controllerAdresseLivraison3.text.isEmpty ||
              _controllerBatChargement.text.isEmpty ||
              _controllerBatLivraison.text.isEmpty ||
              _controllerAscChargement.text.isEmpty ||
              _controllerAscLivraison.text.isEmpty ||
              _controllerEtageChargement.text.isEmpty ||
              _controllerEtageLivraison.text.isEmpty ||
              _controllerMMChargement.text.isEmpty ||
              _controllerMMLivraison.text.isEmpty ||
              _controllerMoyenPrecoLivraison.text.isEmpty ||
              _controllerMoyenPrecoChargement.text.isEmpty) {
            _controllerVolume.text = emptyController;
            _controllerProvenance.text = emptyController;
            _controllerVisite.text = emptyController;
            _controllerDate.text = emptyController;
            _controllerHeure.text = emptyController;
            _controllerContact.text = emptyController;
            _controllerTelephone.text = emptyController;
            _controllerFax.text = emptyController;
            _controllerPt.text = emptyController;
            _controllerEmail.text = emptyController;
            _controllerAdresseFacturation.text = emptyController;
            _controllerDateChargement.text = emptyController;
            _controllerDateLivraison.text = emptyController;
            _controllerAdresseChargement1.text = emptyController;
            _controllerAdresseLivraison1.text = emptyController;
            _controllerAdresseChargement2.text = emptyController;
            _controllerAdresseLivraison2.text = emptyController;
            _controllerAdresseChargement3.text = emptyController;
            _controllerAdresseLivraison3.text = emptyController;
            _controllerBatChargement.text = emptyController;
            _controllerBatLivraison.text = emptyController;
            _controllerAscChargement.text = emptyController;
            _controllerAscLivraison.text = emptyController;
            _controllerEtageChargement.text = emptyController;
            _controllerEtageLivraison.text = emptyController;
            _controllerMMChargement.text = emptyController;
            _controllerMMLivraison.text = emptyController;
            _controllerMoyenPrecoLivraison.text = emptyController;
            _controllerMoyenPrecoChargement.text = emptyController;
          }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      setState(() {
        informationsCategorieError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: const Text('Créateur de devis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
            bottom: MediaQuery.of(context).size.width * 0.08,
          ),
          child: Form(
            key: _keyFormPdf,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '* = champs obligatoires',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                // Première catégorie de formulaire //
                informationsCategorieError ? ExpansionTile(
                  initiallyExpanded: false,
                  maintainState: true,
                  leading: FaIcon(
                    FontAwesomeIcons.info,
                    color: Theme.of(context).errorColor,
                  ),
                  title: Text(
                    "Informations",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                  subtitle: Text(
                    'Certaines informations obligatoires sont manquantes',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Nom du remplisseur du formulaire //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onSaved: (input) => _controllerNomRemplisseur.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNomRemplisseur != null) {
                              _controllerNomRemplisseur.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).errorColor,
                        ),
                        labelText: '*Nom du remplisseur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).errorColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Nom de la fiche //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onSaved: (input) => _controllerNomFiche.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNomFiche != null) {
                              _controllerNomFiche.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.file_present,
                          color: Theme.of(context).errorColor,
                        ),
                        labelText: '*Nom de la fiche',
                        labelStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom de fiche',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).errorColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Numéro du dossier //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerNumeroDossier.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNumeroDossier != null) {
                              _controllerNumeroDossier.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.folder_special_outlined,
                          color: Theme.of(context).errorColor,
                        ),
                        labelText: '*N° Dossier',
                        labelStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un numéro de dossier',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).errorColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Volume //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerVolume.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerVolume != null) {
                              _controllerVolume.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.emoji_objects_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Volume',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un volume',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Provenance //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerProvenance.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerProvenance != null) {
                              _controllerProvenance.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Provenance',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un prénom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Visite //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerVisite.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerVisite != null) {
                              _controllerVisite.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Prénom du visiteur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un prénom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Date //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      onSaved: (input) => _controllerDate.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerDate != null) {
                              _controllerDate.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timelapse_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Date de la visite',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une date',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Heure //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerHeure.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerHeure != null) {
                              _controllerHeure.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timer,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Heure de la visite',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une heure',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Société //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerSociete.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerSociete != null) {
                              _controllerSociete.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.business_center_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '*Société',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une société',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Contact //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerContact.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerContact != null) {
                              _controllerContact.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Contact',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom et un prénom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Téléphone //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onSaved: (input) => _controllerTelephone.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerTelephone != null) {
                              _controllerTelephone.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Téléphone',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un téléphone',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Fax //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerFax.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerFax != null) {
                              _controllerFax.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.print_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Fax',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un fax',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Portable //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerPt.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerPt != null) {
                              _controllerPt.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.phone_iphone,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Portable',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un portable',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Email //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _controllerEmail.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerEmail != null) {
                              _controllerEmail.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.mail_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Adresse mail',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse mail',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse de facturation //
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseFacturation.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseFacturation != null) {
                              _controllerAdresseFacturation.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.mark_as_unread_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Adresse de facturation',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de facturation',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ) : ExpansionTile(
                  initiallyExpanded: false,
                  maintainState: true,
                  leading: FaIcon(
                    FontAwesomeIcons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Informations",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'Informations sur le client',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Nom du remplisseur du formulaire //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onSaved: (input) => _controllerNomRemplisseur.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNomRemplisseur != null) {
                              _controllerNomRemplisseur.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '*Nom du remplisseur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Nom de la fiche //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      onSaved: (input) => _controllerNomFiche.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNomFiche != null) {
                              _controllerNomFiche.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.file_present,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '*Nom de la fiche',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom de fiche',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Numéro du dossier //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerNumeroDossier.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerNumeroDossier != null) {
                              _controllerNumeroDossier.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.folder_special_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '*N° Dossier',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un numéro de dossier',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Volume //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerVolume.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerVolume != null) {
                              _controllerVolume.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.emoji_objects_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Volume',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un volume',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Provenance //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerProvenance.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerProvenance != null) {
                              _controllerProvenance.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Provenance',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un prénom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Visite //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerVisite.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerVisite != null) {
                              _controllerVisite.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Prénom du visiteur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer le prénom du visiteur',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Date //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      onSaved: (input) => _controllerDate.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerDate != null) {
                              _controllerDate.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timelapse_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Date de la visite',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une date',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Heure //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerHeure.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerHeure != null) {
                              _controllerHeure.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timer,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Heure de la visite',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une heure',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Société //
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                         return "Veuillez remplir ce champ.";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerSociete.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerSociete != null) {
                              _controllerSociete.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.business_center_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '*Société',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une société',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Contact //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerContact.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerContact != null) {
                              _controllerContact.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Contact',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un nom et un prénom',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Téléphone //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onSaved: (input) => _controllerTelephone.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerTelephone != null) {
                              _controllerTelephone.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Téléphone',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un téléphone',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Fax //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => _controllerFax.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerFax != null) {
                              _controllerFax.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.print_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Fax',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un fax',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Portable //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerPt.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerPt != null) {
                              _controllerPt.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.phone_iphone,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Portable',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un portable',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Email //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => _controllerEmail.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerEmail != null) {
                              _controllerEmail.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.mail_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Adresse mail',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse mail',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse de facturation //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseFacturation.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseFacturation != null) {
                              _controllerAdresseFacturation.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.mark_as_unread_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Adresse de facturation',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de facturation',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                // Deuxième catégorie de formulaire //
                ExpansionTile(
                  initiallyExpanded: false,
                  maintainState: true,
                  leading: FaIcon(
                    FontAwesomeIcons.truckLoading,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Tableau de chargement",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'Informations de chargement',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Date de chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      onSaved: (input) => _controllerDateChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerDateChargement != null) {
                              _controllerDateChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timelapse,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Date de chargement',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une date de chargement',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 1 de chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseChargement1.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseChargement1 != null) {
                              _controllerAdresseChargement1.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '1er adresse de chargement',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de chargement',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 2 de chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseChargement2.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseChargement2 != null) {
                              _controllerAdresseChargement2.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '2e adresse de chargement',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de chargement',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 3 de chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseChargement3.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseChargement3 != null) {
                              _controllerAdresseChargement3.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '3e adresse de chargement',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de chargement',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès Bat chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerBatChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerBatChargement != null) {
                              _controllerBatChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Bâtiment',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un bâtiment',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès ascenseur chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerAscChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAscChargement != null) {
                              _controllerAscChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Ascenseur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a un ascenseur',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès étage chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerEtageChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerEtageChargement != null) {
                              _controllerEtageChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Étage',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a des étages',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès Monte Meuble chargement //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerMMChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerMMChargement != null) {
                              _controllerMMChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Monte meuble',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a des MM',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Moyens préconiser chargement //
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerMoyenPrecoChargement.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerMoyenPrecoChargement != null) {
                              _controllerMoyenPrecoChargement.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.inbox,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Type d\'emballage',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez le type d\'emballage',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                // Troisième catégorie de formulaire //
                ExpansionTile(
                  initiallyExpanded: false,
                  maintainState: true,
                  leading: FaIcon(
                    FontAwesomeIcons.truck,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Tableau de livraison",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'Informations de livraison',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Date de Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      onSaved: (input) => _controllerDateLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerDateLivraison != null) {
                              _controllerDateLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.timelapse,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Date de livraison',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une date de livraison',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 1 de Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseLivraison1.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseLivraison1 != null) {
                              _controllerAdresseLivraison1.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '1er adresse de livraison',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de livraison',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 2 de Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseLivraison2.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseLivraison2 != null) {
                              _controllerAdresseLivraison2.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '2e adresse de livraison',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de livraison',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Adresse 3 de Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      onSaved: (input) => _controllerAdresseLivraison3.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAdresseLivraison3 != null) {
                              _controllerAdresseLivraison3.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: '3e adresse de livraison',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer une adresse de livraison',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès Bat Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerBatLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerBatLivraison != null) {
                              _controllerBatLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Bâtiment',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Entrer un bâtiment',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès ascenseur Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerAscLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerAscLivraison != null) {
                              _controllerAscLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Ascenseur',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a un ascenseur',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès étage Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerEtageLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerEtageLivraison != null) {
                              _controllerEtageLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Étage',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a des étages',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Accès Monte Meuble livraison //
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerMMLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerMMLivraison != null) {
                              _controllerMMLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.domain,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Monte meuble',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez s\'il y a des MM',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    // Moyens préconiser Livraison //
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _controllerMoyenPrecoLivraison.text = input!,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).errorColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Color.fromRGBO(23, 74, 150, 1),
                            size: 22,
                          ),
                          splashRadius: 15,
                          tooltip: "Effacer le texte",
                          onPressed: () {
                            // ignore: unnecessary_null_comparison
                            if (_controllerMoyenPrecoLivraison != null) {
                              _controllerMoyenPrecoLivraison.clear();
                            }
                            return;
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.euro,
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Prix de vente',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                        hintText: 'Précisez un prix de vente',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                // Quatrième catégorie de formulaire //
                ExpansionTile(
                  initiallyExpanded: false,
                  maintainState: true,
                  leading: FaIcon(
                    FontAwesomeIcons.archive,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Transfert",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'Informations des biens',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Poste Informatique',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentPosteInfoValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentPosteInfoValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Imprimante',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentImprimanteValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentImprimanteValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Carton/Personne',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentCartonValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentCartonValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Foisonnement/Personne',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentfoisonnementValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentfoisonnementValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Armoires roulantes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentarmoiresRoulantesValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentarmoiresRoulantesValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Bureau simple',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentbureauSimpleValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentbureauSimpleValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Banc',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentbenchValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentbenchValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Armoire Haute',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentarmoireHauteValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentarmoireHauteValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Armoire Basse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentarmoireBasseValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentarmoireBasseValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Table',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currenttableValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currenttableValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Table Ronde',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currenttableRondeValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currenttableRondeValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Chaise',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentchaiseValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentchaiseValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Étagère',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentetagereValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentetagereValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Photocopieur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentphotocopieurValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentphotocopieurValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Coffre Fort/Armoire Forte',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentcoffrefortValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentcoffrefortValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Canapé',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentcanapeValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentcanapeValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Plante',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    NumberPicker(
                      axis: Axis.horizontal,
                      zeroPad: false,
                      infiniteLoop: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      step: 1,
                      value: _currentplanteValue,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (value) =>
                          setState(() => _currentplanteValue = value),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ]
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                ElevatedButton(
                  onPressed: () {
                    if(Platform.isAndroid) {
                      permissionStorage();
                    } else if(Platform.isIOS) {
                      inputPDF();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double?>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).primaryColor)
                      )
                    ),
                  ),
                  child: Text(
                    'Créer le document PDF',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18
                    ),
                  )
                ),
              ],
            ),
          )
        )
      ),
    );
  }

  // Création du PDF //
  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawImage(PdfBitmap(await _readImageData('pdflogo.png')),
        const Rect.fromLTWH(0, 0, 175, 150));

    page.graphics.drawString('FICHE TECHNIQUE',
        PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(225, 0, 0, 0));

    // N° DOSSIER
    page.graphics.drawString('N° Dossier : ' + _controllerNumeroDossier.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(235, 50, 0, 0), brush: PdfBrushes.midnightBlue);

    // END N° DOSSIER

    // VOLUME
    page.graphics.drawString('Volume : ' + _controllerVolume.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(235, 98, 0, 0), brush: PdfBrushes.black);

    // END VOLUME

    // PROVENANCE
    page.graphics.drawString('Provenance : ' + _controllerProvenance.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(15, 170, 0, 0));
    // END PROVENANCE

    // VISITE
    page.graphics.drawString('Visité par : ' + _controllerVisite.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(15, 205, 0, 0));
    // END VISITE

    // DATE
    page.graphics.drawString('Date : ' + _controllerDate.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(15, 240, 0, 0));
    // END DATE

    // HEURE
    page.graphics.drawString('Heure : ' + _controllerHeure.text,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(220, 240, 0, 0));
    // END HEURE

    // SOCIETE
    page.graphics.drawString('Société : ' + _controllerSociete.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(15, 300, 0, 0), brush: PdfBrushes.midnightBlue);

    // END SOCIETE

    // CONTACT
    page.graphics.drawString('Contact : ' + _controllerContact.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(220, 300, 0, 0), brush: PdfBrushes.midnightBlue);

    // END CONTACT

    // TEL
    page.graphics.drawString('Tél. : ' + _controllerTelephone.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(15, 340, 0, 0));
    // END TEL

    // FAX
    page.graphics.drawString('Fax : ' + _controllerFax.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(220, 340, 0, 0));
    // END FAX

    // PT
    page.graphics.drawString('Pt. : ' + _controllerPt.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(18, 380, 0, 0));
    // END PT

    // EMAIL
    page.graphics.drawString('Email : ' '\n' + _controllerEmail.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(220, 380, 0, 0));
    // END EMAIL

    // ADRESSE FACTURATION
    page.graphics.drawString(
        'Adresse de Facturation : ' '\n' + _controllerAdresseFacturation.text,
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: const Rect.fromLTWH(18, 420, 0, 0));
    // END ADRESSE FACTURATION

    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 485, 515, 277), pen: PdfPens.black);

    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 485, 100, 30), pen: PdfPens.black);

    // CHARGEMENT CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 485, 203, 30), pen: PdfPens.black);
    page.graphics.drawString('CHARGEMENT',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(130, 487, 0, 0), brush: PdfBrushes.midnightBlue);
    // END CHARGEMENT CASE

    // LIVRAISON CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 485, 211, 30), pen: PdfPens.black);
    page.graphics.drawString('LIVRAISON',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(355, 487, 0, 0), brush: PdfBrushes.midnightBlue);
    // END LIVRAISON CASE

    // DATES CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 515, 100, 35), pen: PdfPens.black);
    page.graphics.drawString('Dates',
        PdfStandardFont(PdfFontFamily.helvetica, 19, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(24, 520, 0, 0));
    // END DATES CASE

    // DATES CHARGEMENT CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 515, 203, 35), pen: PdfPens.black);
    page.graphics.drawString(
        _controllerDateChargement.text,
        PdfStandardFont(
          PdfFontFamily.helvetica,
          16,
        ),
        bounds: const Rect.fromLTWH(110, 521, 0, 0));
    // END DATES CHARGEMENT CASE

    // DATES LIVRAISON CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 515, 211, 35), pen: PdfPens.black);
    page.graphics.drawString(
        _controllerDateLivraison.text,
        PdfStandardFont(
          PdfFontFamily.helvetica,
          16,
        ),
        bounds: const Rect.fromLTWH(315, 521, 0, 0));
    // END DATES LIVRAISON CASE

    // ADRESSE CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 550, 100, 100), pen: PdfPens.black);
    page.graphics.drawString('Adresses',
        PdfStandardFont(PdfFontFamily.helvetica, 19, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(7, 587, 0, 0));
    // ADRESSE DATES CASE

    // ADRESSE CHARGEMENT CASE
    // ADRESSE 1
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 550, 203, 100), pen: PdfPens.black);
    page.graphics.drawString('1. ' + _controllerAdresseChargement1.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 557, 0, 0));
    // ADRESSE 2
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 550, 203, 33.33), pen: PdfPens.black);
    page.graphics.drawString('2. ' + _controllerAdresseChargement2.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 589, 0, 0));
    // ADRESSE 3
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 583, 203, 33.33), pen: PdfPens.black);
    page.graphics.drawString('3. ' + _controllerAdresseChargement3.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 622, 0, 0));
    // END ADRESSE CHARGEMENT CASE

    // ADRESSE LIVRAISON CASE
    // ADRESSE 1
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 550, 211, 100), pen: PdfPens.black);
    page.graphics.drawString('1. ' + _controllerAdresseLivraison1.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 557, 0, 0));
    // ADRESSE 2
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 550, 211, 33.33), pen: PdfPens.black);
    page.graphics.drawString('2. ' + _controllerAdresseLivraison2.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 589, 0, 0));
    // ADRESSE 3
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 583, 211, 33.33), pen: PdfPens.black);
    page.graphics.drawString('3. ' + _controllerAdresseLivraison3.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 622, 0, 0));
    // END ADRESSE LIVRAISON CASE

    // ACCES CASE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 650, 100, 70), pen: PdfPens.black);
    page.graphics.drawString('Accès',
        PdfStandardFont(PdfFontFamily.helvetica, 19, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(20, 671, 0, 0));
    // END ACCES CASE

    // ACCES CASE CHARGEMENT
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 650, 203, 70), pen: PdfPens.black);

    // BAT
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 650, 101.5, 35), pen: PdfPens.black);
    page.graphics.drawString('Bât. : ' + _controllerBatChargement.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 658, 0, 0));
    // ASC
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(202, 650, 100.5, 35), pen: PdfPens.black);
    page.graphics.drawString('Asc : ' + _controllerAscChargement.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(207, 658, 0, 0));
    // ETAGE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(100, 685, 101.5, 35), pen: PdfPens.black);
    page.graphics.drawString('Etage : ' + _controllerEtageChargement.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 693, 0, 0));
    // MM
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(202, 685, 100.5, 35), pen: PdfPens.black);
    page.graphics.drawString('MM : ' + _controllerMMChargement.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(207, 693, 0, 0));
    // END ACCES CASE CHARGEMENT

    // ACCES CASE LIVRAISON
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 650, 211, 70), pen: PdfPens.black);
    // BAT
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 650, 105.5, 35), pen: PdfPens.black);
    page.graphics.drawString('Bât. : ' + _controllerBatLivraison.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 658, 0, 0));
    // ASC
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(409, 650, 105, 35), pen: PdfPens.black);
    page.graphics.drawString('Asc : ' + _controllerAscLivraison.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(414, 658, 0, 0));
    // ETAGE
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 685, 105.5, 35), pen: PdfPens.black);
    page.graphics.drawString('Etage : ' + _controllerEtageLivraison.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 693, 0, 0));
    // MM
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(409, 685, 105, 35), pen: PdfPens.black);
    page.graphics.drawString('MM : ' + _controllerMMLivraison.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(414, 693, 0, 0));
    // END ACCES CASE LIVRAISON

    // MOYENS //
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(0, 720, 100, 45), pen: PdfPens.black);
    page.graphics.drawString('Moyens',
        PdfStandardFont(PdfFontFamily.helvetica, 19, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(14, 730, 0, 0));
    // END MOYENS //

    // Chargement Type emballage
    page.graphics.drawString(
        'Type d\'emballage : ' + _controllerMoyenPrecoChargement.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(105, 732, 0, 0));

    // Prix vente
    page.graphics.drawRectangle(
        bounds: const Rect.fromLTWH(303, 720, 211, 45), pen: PdfPens.black);
    page.graphics.drawString(
        'Prix de vente : ' + _controllerMoyenPrecoLivraison.text,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: const Rect.fromLTWH(308, 732, 0, 0));

    // Deuxième Page PDF //
    final page2 = document.pages.add();
    page2.graphics.drawImage(PdfBitmap(await _readImageData('pdflogo.png')),
        const Rect.fromLTWH(0, 0, 175, 150));

    // POSTE INFO
    page2.graphics.drawString(
        'Poste Informatique : ' + _currentPosteInfoValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(235, 0, 0, 0),
        brush: PdfBrushes.black);

    // END POSTE INFO

    // IMPRIMANTE
    page2.graphics.drawString(
        'Imprimante : ' + _currentImprimanteValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(235, 40, 0, 0),
        brush: PdfBrushes.black);
    // END IMPRIMANTE

    // CARTON/PERSONNE
    page2.graphics.drawString(
        'Carton/Personne : ' + _currentCartonValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(235, 80, 0, 0),
        brush: PdfBrushes.black);
    // END CARTON/PERSONNE

    // FOISONNEMENT/PERSONNE
    page2.graphics.drawString(
        'Foisonnement/Personne : ' + _currentfoisonnementValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(235, 120, 0, 0),
        brush: PdfBrushes.black);
    // END FOISONNEMENT/PERSONNE

    // ARMOIRES ROULANTES
    page2.graphics.drawString(
        'Armoires roulantes : ' + _currentarmoiresRoulantesValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(235, 160, 0, 0),
        brush: PdfBrushes.black);

    page2.graphics.drawString('POSTE DE TRAVAIL : ',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 200, 0, 0), brush: PdfBrushes.black);

    page2.graphics.drawString(
        '- Bureau simple : ' + _currentbureauSimpleValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 240, 0, 0),
        brush: PdfBrushes.black);
    page2.graphics.drawString('- Bench : ' + _currentbenchValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 280, 0, 0), brush: PdfBrushes.black);

    page2.graphics.drawString('ARMOIRE : ',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 320, 0, 0), brush: PdfBrushes.black);

    page2.graphics.drawString(
        '- Haute : ' + _currentarmoireHauteValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 360, 0, 0),
        brush: PdfBrushes.black);
    page2.graphics.drawString(
        '- Basse : ' + _currentarmoireBasseValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 400, 0, 0),
        brush: PdfBrushes.black);

    page2.graphics.drawString('TABLE : ' + _currenttableValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 450, 0, 0), brush: PdfBrushes.black);
    page2.graphics.drawString(
        'TABLE RONDE : ' + _currenttableRondeValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 490, 0, 0),
        brush: PdfBrushes.black);
    page2.graphics.drawString('CHAISE : ' + _currentchaiseValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 530, 0, 0), brush: PdfBrushes.black);
    page2.graphics.drawString('ETAGERE : ' + _currentetagereValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 570, 0, 0), brush: PdfBrushes.black);
    page2.graphics.drawString(
        'PHOTOCOPIEUR : ' + _currentphotocopieurValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 610, 0, 0),
        brush: PdfBrushes.black);
    page2.graphics.drawString(
        'COFFRE FORT/ARMOIRE FORTE : ' + _currentcoffrefortValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 650, 0, 0),
        brush: PdfBrushes.black);
    page2.graphics.drawString('CANAPE : ' + _currentcanapeValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 690, 0, 0), brush: PdfBrushes.black);
    page2.graphics.drawString('PLANTE : ' + _currentplanteValue.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 730, 0, 0), brush: PdfBrushes.black);
    // END ARMOIRES ROULANTES
    // End Deuxième Page PDF //

    // Sauvegarde du document pdf généré
    List<int> bytes = document.save();
    document.dispose();

    document.documentInformation.removeModificationDate();

    //saveAndLaunchFile(bytes, 'BLBDevis.pdf');

    // Nom du fichier PDF a généré
    saveAndLaunchFile(bytes, 'BLBDevis_${_controllerNomRemplisseur.text}_${_controllerNomFiche.text}_societe_${_controllerSociete.text}.pdf');
  }

  // Méthode d'importation d'image dans un PDF //
  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  // Méthode de sauvegarde et de lancement de fichiers PDF //
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    if (Platform.isAndroid) {
      final path = (await getExternalStorageDirectory())!.path;
      final file = File('$path/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open('$path/$fileName');
    }
    if (Platform.isIOS) {
      final path = (await getApplicationDocumentsDirectory()).path;
      final file = File('$path/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open('$path/$fileName');
    }
  }
}