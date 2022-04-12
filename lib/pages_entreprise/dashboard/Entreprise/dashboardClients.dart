// ignore_for_file: file_names

import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BLBDashboardClient extends StatefulWidget {
  const BLBDashboardClient({ Key? key }) : super(key: key);

  @override
  _BLBDashboardClientState createState() => _BLBDashboardClientState();
}

class _BLBDashboardClientState extends State<BLBDashboardClient> {

  // Recherche
  bool searching = false;
  String searchInt = '';

  // Ajout
  bool formOpenAjout = false;
  final _formKeyAjout = GlobalKey<FormState>();
  // Contrôleur de formulaire ajout
  final _controllerNomPrenom = TextEditingController();
  final _controllerNomEntreprise = TextEditingController();
  final _controllerVille = TextEditingController();
  final _controllerDP = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerTelephone = TextEditingController();

  // Update
  final _formKeyUpdate = GlobalKey<FormState>();
  bool update = false;
  // Contrôleur de formulaire update
  final _controllerNomPrenomUpdate = TextEditingController();
  final _controllerNomEntrepriseUpdate = TextEditingController();
  final _controllerVilleUpdate = TextEditingController();
  final _controllerDPUpdate = TextEditingController();
  final _controllerEmailUpdate = TextEditingController();
  final _controllerTelephoneUpdate = TextEditingController();

  // Firestore
  final collection = FirebaseFirestore.instance.collection('clients');

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // Fonction ajout nouveau client
  void addClient() {
    try {
      collection.add(
        {
          'nom_prenom': _controllerNomPrenom.text,
          'nom_entreprise': _controllerNomEntreprise.text,
          'ville': _controllerVille.text,
          'dp': _controllerDP.text,
          'email': _controllerEmail.text,
          'telephone': _controllerTelephone.text
        }
      ).whenComplete(() => {
        _formKeyAjout.currentState!.reset(),
       fToast.showToast(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Theme.of(context).shadowColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Theme.of(context).hintColor,),
                const SizedBox(
                  width: 12.0,
                ),
                Flexible(
                  child: Text(
                    "Client ajouté avec succès !",
                    style: TextStyle(
                      color: Theme.of(context).hintColor
                    ),
                  ),
                )
              ],
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 4)
        )
      }).catchError((onError) {
        // Error connexion
        if(onError.hashCode == 271948972) {
          fToast.showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Theme.of(context).errorColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close, color: Theme.of(context).hintColor,),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Flexible(
                    child: Text(
                      "L'enregistrement a échoué en raison d'une erreur réseau, veuillez réessayer avec une connexion stable.",
                      style: TextStyle(
                        color: Theme.of(context).hintColor
                      ),
                    ),
                  )
                ],
              ),
            ),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 4)
          );
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

    // Client //
    User? user = FirebaseAuth.instance.currentUser;

  @override
  // ignore: override_on_non_overriding_member
  Widget buildResult(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Si la collection charge
        if(!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
              Flexible(
                child: Text(
                  'Chargement de données en cours...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18
                  ),
                ),
              )
            ],
          );
        } else {
          // Si la recherche n'a rien réussi à trouvé
          if(snapshot.data!.docs.where(
              (QueryDocumentSnapshot<Object?> element) => element['nom_prenom']
              .toString()
              .toLowerCase()
              .contains(searchInt.toLowerCase())).isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      "Aucun résultat n'a été trouvé.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                )
              ],
            );
          } else {
            // Si la recherche a réussi à trouvé
            return ListView(
              children: [
                ...snapshot.data!.docs.where(
                (QueryDocumentSnapshot<Object?> element) => element['nom_prenom']
                .toString()
                .toLowerCase()
                .contains(searchInt.toLowerCase())).map((QueryDocumentSnapshot<Object?> data) {
                  final String nomPrenom = data.get('nom_prenom');
                  final String nomEntreprise = data['nom_entreprise'];
                  final String ville = data['ville'];
                  final String dp = data['dp'];
                  final String email = data['email'];
                  final String telephone = data['telephone'];

                  return Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ExpansionTileCard(
                        baseColor: Theme.of(context).primaryColor,
                        expandedColor: Theme.of(context).primaryColor,
                        expandedTextColor: Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(22),
                        contentPadding: const EdgeInsets.all(12),
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/iconSignIn.png',
                              height: 50,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                            Expanded(
                              child: Text(
                                nomPrenom,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              right: 20,
                              left: 20
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).hintColor
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if(update == false) {
                                  setState(() {
                                    update = true;
                                  });
                                } else {
                                  setState(() {
                                    update = false;
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit),
                              splashRadius: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          update ? Form(
                            key: _formKeyUpdate,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    controller: _controllerNomPrenomUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerNomPrenomUpdate != null) {
                                            _controllerNomPrenomUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Nom et prénom du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['nom_prenom'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _controllerNomEntrepriseUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerNomEntrepriseUpdate != null) {
                                            _controllerNomEntrepriseUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.business_center,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Entreprise du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['nom_entreprise'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _controllerVilleUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerVilleUpdate != null) {
                                            _controllerVilleUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.villa,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Ville du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['ville'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: _controllerDPUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerDPUpdate != null) {
                                            _controllerDPUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.domain,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Département du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['dp'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isNotEmpty) {
                                        return EmailValidator.validate(input)
                                            // ignore: unnecessary_statements
                                            ? null
                                            : "Veuillez saisir une adresse mail valide";
                                      }
                                      if (input.isEmpty) {
                                      return 'Veuillez saisir une adresse mail';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _controllerEmailUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerEmailUpdate != null) {
                                            _controllerEmailUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Adresse mail du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['email'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    controller: _controllerTelephoneUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerTelephoneUpdate != null) {
                                            _controllerTelephoneUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Téléphone du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['telephone'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_formKeyUpdate.currentState!.validate()) {
                                          collection.doc(data.id).update({
                                            'nom_prenom': _controllerNomPrenomUpdate.text,
                                            'nom_entreprise': _controllerNomEntrepriseUpdate.text,
                                            'ville': _controllerVilleUpdate.text,
                                            'dp': _controllerDPUpdate.text,
                                            'email': _controllerEmailUpdate.text,
                                            'telephone': _controllerTelephoneUpdate.text
                                          }).whenComplete(() {
                                            _formKeyUpdate.currentState!.reset();
                                            fToast.showToast(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: Theme.of(context).shadowColor,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.check, color: Theme.of(context).hintColor,),
                                                    const SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "Modification du client " + data['nom_prenom'] + " avec succès.",
                                                        style: TextStyle(
                                                          color: Theme.of(context).hintColor
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              gravity: ToastGravity.BOTTOM,
                                              toastDuration: const Duration(seconds: 4)
                                            );
                                          }).catchError((onError) {
                                            // Erreur réseau
                                            if(onError.hashCode == 271948972) {
                                              fToast.showToast(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  color: Theme.of(context).errorColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.close, color: Theme.of(context).hintColor,),
                                                      const SizedBox(
                                                        width: 12.0,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "La modification a échoué en raison d'une erreur réseau, veuillez réessayer avec une connexion stable.",
                                                          style: TextStyle(
                                                            color: Theme.of(context).hintColor
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                gravity: ToastGravity.BOTTOM,
                                                toastDuration: const Duration(seconds: 4)
                                              );
                                            }
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.transparent
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(
                                              color: Theme.of(context).hintColor,
                                            )
                                          )
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Text(
                                          'Modifier le client',
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                ],
                              ),
                            ),
                            ) : Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                right: 20,
                                left: 20
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Entreprise : ' + nomEntreprise,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Ville : ' + ville,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Département : ' + dp,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Email : ' + email,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Téléphone : ' + telephone,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                ],
                              ),
                            )
                        ],
                      )
                    )
                  );
                })
              ],
            );
          }
        }
      },
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Widget clientList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Si la collection charge
        if(!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
              Flexible(
                child: Text(
                  'Chargement de données en cours...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18
                  ),
                ),
              )
            ],
          );
        } else {
          // Si les documents de la collection sont null
          if(snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Center(
                    child: Text(
                      "Aucun résultat n'a été trouvé.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                )
              ],
            );
          } else {
            // Si les documents de la collection ne sont pas null
            return ListView(
              children: [
                ...snapshot.data!.docs.map((QueryDocumentSnapshot<Object?> data) {
                  final String nomPrenom = data.get('nom_prenom');
                  final String nomEntreprise = data['nom_entreprise'];
                  final String ville = data['ville'];
                  final String dp = data['dp'];
                  final String email = data['email'];
                  final String telephone = data['telephone'];

                  return Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ExpansionTileCard(
                        baseColor: Theme.of(context).primaryColor,
                        expandedColor: Theme.of(context).primaryColor,
                        expandedTextColor: Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(22),
                        contentPadding: const EdgeInsets.all(12),
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/iconSignIn.png',
                              height: 50,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                            Expanded(
                              child: Text(
                                nomPrenom,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              right: 20,
                              left: 20
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).hintColor
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if(update == false) {
                                  setState(() {
                                    update = true;
                                  });
                                } else {
                                  setState(() {
                                    update = false;
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit),
                              splashRadius: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          update ? Form(
                            key: _formKeyUpdate,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    controller: _controllerNomPrenomUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerNomPrenomUpdate != null) {
                                            _controllerNomPrenomUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Nom et prénom du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['nom_prenom'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _controllerNomEntrepriseUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerNomEntrepriseUpdate != null) {
                                            _controllerNomEntrepriseUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.business_center,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Entreprise du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['nom_entreprise'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _controllerVilleUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerVilleUpdate != null) {
                                            _controllerVilleUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.villa,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Ville du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['ville'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: _controllerDPUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerDPUpdate != null) {
                                            _controllerDPUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.domain,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Département du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['dp'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isNotEmpty) {
                                        return EmailValidator.validate(input)
                                            // ignore: unnecessary_statements
                                            ? null
                                            : "Veuillez saisir une adresse mail valide";
                                      }
                                      if (input.isEmpty) {
                                      return 'Veuillez saisir une adresse mail';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _controllerEmailUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerEmailUpdate != null) {
                                            _controllerEmailUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Adresse mail du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['email'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.phone,
                                    controller: _controllerTelephoneUpdate,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor
                                    ),
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
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context).hintColor,
                                          size: 22,
                                        ),
                                        splashRadius: 15,
                                        tooltip: "Effacer le texte",
                                        onPressed: () {
                                          // ignore: unnecessary_null_comparison
                                          if (_controllerTelephoneUpdate != null) {
                                            _controllerTelephoneUpdate.clear();
                                          }
                                          return;
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      labelText: 'Téléphone du client',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                      hintText: data['telephone'],
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_formKeyUpdate.currentState!.validate()) {
                                          collection.doc(data.id).update({
                                            'nom_prenom': _controllerNomPrenomUpdate.text,
                                            'nom_entreprise': _controllerNomEntrepriseUpdate.text,
                                            'ville': _controllerVilleUpdate.text,
                                            'dp': _controllerDPUpdate.text,
                                            'email': _controllerEmailUpdate.text,
                                            'telephone': _controllerTelephoneUpdate.text
                                          }).whenComplete(() {
                                            _formKeyUpdate.currentState!.reset();
                                            fToast.showToast(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: Theme.of(context).shadowColor,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.check, color: Theme.of(context).hintColor,),
                                                    const SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "Modification du client " + data['nom_prenom'] + " avec succès.",
                                                        style: TextStyle(
                                                          color: Theme.of(context).hintColor
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              gravity: ToastGravity.BOTTOM,
                                              toastDuration: const Duration(seconds: 4)
                                            );
                                          }).catchError((onError) {
                                            // Erreur réseau
                                            if(onError.hashCode == 271948972) {
                                              fToast.showToast(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  color: Theme.of(context).errorColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.close, color: Theme.of(context).hintColor,),
                                                      const SizedBox(
                                                        width: 12.0,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "La modification a échoué en raison d'une erreur réseau, veuillez réessayer avec une connexion stable.",
                                                          style: TextStyle(
                                                            color: Theme.of(context).hintColor
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                gravity: ToastGravity.BOTTOM,
                                                toastDuration: const Duration(seconds: 4)
                                              );
                                            }
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.transparent
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(
                                              color: Theme.of(context).hintColor,
                                            )
                                          )
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Text(
                                          'Modifier le client',
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                ],
                              ),
                            ),
                            ) : Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                right: 20,
                                left: 20
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Entreprise : ' + nomEntreprise,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Ville : ' + ville,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Département : ' + dp,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Email : ' + email,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Téléphone : ' + telephone,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                ],
                              ),
                            )
                        ],
                      )
                    )
                  );
                })
              ],
            );
          }
        }
      }
    );
  }

  // Instance //
  User? authFirebase = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
          formOpenAjout ? Container() : Row(
            children: [
              GestureDetector(
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
          )
        ],
          title: formOpenAjout ? Text(
            'Ajout de nouveaux clients',
            style: TextStyle(color: Theme.of(context).hintColor),
          ) : Text(
            'Tableau de bord clients',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          centerTitle: formOpenAjout ? true : false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: (val) {
                  setState(
                    () {
                      // si la valeur entrée n'est pas null alors activé la recherche et afficher les données
                      if (val.isNotEmpty) {
                        searching = true;
                        searchInt = val;
                      }
                      // si la valeur entrée est null alors désactivé la recherche
                      if (val.isEmpty) {
                        searching = false;
                      }
                    },
                  );
                },
                cursorColor: Theme.of(context).hintColor,
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 18),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  fillColor: Theme.of(context).hintColor,
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).hintColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).hintColor,
                    size: 25,
                  ),
                  hintText: 'Rechercher un client...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(130),
      ),
      floatingActionButton: FloatingActionButton(
        child: formOpenAjout ? Icon(
          Icons.close,
          size: 25,
          color: Theme.of(context).hintColor,
        ) : Icon(
          Icons.person_add_outlined,
          size: 25,
          color: Theme.of(context).hintColor,
        ),
        onPressed: () {
          if(formOpenAjout == false) {
            setState(() {
              // Activation du formulaire d'ajout clients
              formOpenAjout = true;
              // Désactivation de l'options de recherche
              searching = false;
            });
          } else {
            setState(() {
              // Activation de l'options de recherche
              searching = true;
              // Désactivation du formulaire d'ajout clients
              formOpenAjout = false;
            });
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColor,
      ),
      body: searching ? buildResult(context) : formOpenAjout ? SingleChildScrollView(
        reverse: true,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
            bottom: MediaQuery.of(context).size.height * 0.03,
          ),
          child: Form(
            key: _formKeyAjout,
            child: Column(
              children: [
                TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez compléter ce champ.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    controller: _controllerNomPrenom,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        splashRadius: 15,
                        tooltip: "Effacer le texte",
                        onPressed: () {
                          // ignore: unnecessary_null_comparison
                          if (_controllerNomPrenom != null) {
                            _controllerNomPrenom.clear();
                          }
                          return;
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Nom et prénom du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer le nom et prénom du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez compléter ce champ.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: _controllerNomEntreprise,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        splashRadius: 15,
                        tooltip: "Effacer le texte",
                        onPressed: () {
                          // ignore: unnecessary_null_comparison
                          if (_controllerNomEntreprise != null) {
                            _controllerNomEntreprise.clear();
                          }
                          return;
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.business_center,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Entreprise du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer l\'entreprise du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez compléter ce champ.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: _controllerVille,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        splashRadius: 15,
                        tooltip: "Effacer le texte",
                        onPressed: () {
                          // ignore: unnecessary_null_comparison
                          if (_controllerVille != null) {
                            _controllerVille.clear();
                          }
                          return;
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.villa,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Ville du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer la ville du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez compléter ce champ.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: _controllerDP,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        splashRadius: 15,
                        tooltip: "Effacer le texte",
                        onPressed: () {
                          // ignore: unnecessary_null_comparison
                          if (_controllerDP != null) {
                            _controllerDP.clear();
                          }
                          return;
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.domain,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Département du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer le département du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    validator: (input) {
                      if (input!.isNotEmpty) {
                        return EmailValidator.validate(input)
                            // ignore: unnecessary_statements
                            ? null
                            : "Veuillez saisir une adresse mail valide";
                      }
                      if (input.isEmpty) {
                      return 'Veuillez saisir une adresse mail';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
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
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Adresse mail du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer l\'adresse mail du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez compléter ce champ.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    controller: _controllerTelephone,
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
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).primaryColor,
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
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Téléphone du client',
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                      hintText: 'Entrer le téléphone du client',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKeyAjout.currentState!.validate()) {
                        return addClient();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).hintColor
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          )
                        )
                      ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Text(
                        'Ajouter un nouveau client',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ) ,
      ): clientList(context),
    );
  }
}