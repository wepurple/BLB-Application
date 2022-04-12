// ignore_for_file: file_names

import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BLBDashBoardUtilisateurs extends StatefulWidget {
  const BLBDashBoardUtilisateurs({ Key? key }) : super(key: key);

  @override
  State<BLBDashBoardUtilisateurs> createState() => _BLBDashBoardUtilisateursState();
}

class _BLBDashBoardUtilisateursState extends State<BLBDashBoardUtilisateurs> {

  // Recherche
  bool searching = false;
  String searchInt = '';

  // Instance //
  User? authFirebase = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Row(
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
          title: Text(
            'Tableau de bord utilisateurs',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          centerTitle: false,
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
                  hintText: 'Rechercher un utilisateur...',
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
      body: searching ? buildResult(context) : utilisateurList(context),
    );
  }

  // Firestore
  final collection = FirebaseFirestore.instance.collection('utilisateurs_inscrit');

  // Update
  final _formKeyUpdate = GlobalKey<FormState>();
  bool update = false;

  // Catégories Rôle
  List<DropdownMenuItem<String>> get roleItems{
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Client",),value: "Client"),
      DropdownMenuItem(child: Text("Entreprise"),value: "Entreprise"),
      DropdownMenuItem(child: Text("Admin"),value: "Admin"),
    ];
    return menuItems;
  }
  String _selectedValue = 'Client';

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // Première lettre en majuscule
  String capitalizeDay(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  // ignore: override_on_non_overriding_member
  Widget utilisateurList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots().asBroadcastStream(),
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
                  final String email = data.get('email');
                  final String prenom = data['firstName'];
                  final String nom = data['lastName'];
                  final String role = data['role'];

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
                                prenom + " " + nom,
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
                          update ? Form(
                            key: _formKeyUpdate,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  DropdownButtonFormField(
                                    hint: Text(
                                      capitalizeDay(role),
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    validator: (input) {
                                      if (_selectedValue.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    items: roleItems,
                                    onChanged: (String? newValue){
                                      setState(() {
                                        _selectedValue = newValue!;
                                      });
                                    },
                                    dropdownColor: Theme.of(context).primaryColor,
                                    iconDisabledColor: Theme.of(context).hintColor,
                                    iconEnabledColor: Theme.of(context).hintColor,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18,
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
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
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
                                        iconSize: 20,
                                        icon: const Icon(Icons.arrow_back_ios),
                                        splashRadius: 20,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      const SizedBox(width: 10,),
                                      Flexible(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKeyUpdate.currentState!.validate()) {
                                              collection.doc(data.id).update({
                                                'role': _selectedValue.toLowerCase(),
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
                                                            "Modification de l'utilisateur " + data['firstName'] + " avec succès.",
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
                                              'Modifier l\'utilisateur',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context).hintColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                ],
                              ),
                            ),
                            ) : Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
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
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Prénom : ' + prenom,
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
                                      'Nom : ' + nom,
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
                                      'Rôle : ' + role,
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

  @override
  // ignore: override_on_non_overriding_member
  Widget buildResult(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots().asBroadcastStream(),
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
              (QueryDocumentSnapshot<Object?> firstName) => firstName['firstName']
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
                (QueryDocumentSnapshot<Object?> firstName) => firstName['firstName']
                .toString()
                .toLowerCase()
                .contains(searchInt.toLowerCase())).map((QueryDocumentSnapshot<Object?> data) {
                  final String email = data.get('email');
                  final String prenom = data['firstName'];
                  final String nom = data['lastName'];
                  final String role = data['role'];

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
                                prenom + " " + nom,
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
                          update ? Form(
                            key: _formKeyUpdate,
                            child: Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  DropdownButtonFormField(
                                    hint: Text(
                                      capitalizeDay(role),
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    validator: (input) {
                                      if (_selectedValue.isEmpty) {
                                        return 'Veuillez compléter ce champ.';
                                      }
                                      return null;
                                    },
                                    items: roleItems,
                                    onChanged: (String? newValue){
                                      setState(() {
                                        _selectedValue = newValue!;
                                      });
                                    },
                                    dropdownColor: Theme.of(context).primaryColor,
                                    iconDisabledColor: Theme.of(context).hintColor,
                                    iconEnabledColor: Theme.of(context).hintColor,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18,
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
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
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
                                        iconSize: 20,
                                        icon: const Icon(Icons.arrow_back_ios),
                                        splashRadius: 20,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      const SizedBox(width: 10,),
                                      Flexible(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKeyUpdate.currentState!.validate()) {
                                              collection.doc(data.id).update({
                                                'role': _selectedValue.toLowerCase(),
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
                                                            "Modification de l'utilisateur " + data['firstName'] + " avec succès.",
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
                                              'Modifier l\'utilisateur',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context).hintColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                ],
                              ),
                            ),
                            ) : Container(
                              padding: const EdgeInsets.only(right: 20, left: 20),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
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
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Prénom : ' + prenom,
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
                                      'Nom : ' + nom,
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
                                      'Rôle : ' + role,
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
}