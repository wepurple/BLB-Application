import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBAccount extends StatefulWidget {
  const BLBAccount({ Key? key }) : super(key: key);

  @override
  _BLBAccountState createState() => _BLBAccountState();
}

class _BLBAccountState extends State<BLBAccount> {

  // Instance de l'auth
  final User? userAuth = FirebaseAuth.instance.currentUser;

  // Booléen d'affichage update form
  bool updateInformationsWidget = false;
  bool updatePasswordWidget = false;
  bool updateEmailBool = false;

  // Icon de dévérouillage désactivé
  bool iconLockUpdateMail = false;
  bool iconLockUpdateInfoPerso = false;
  bool iconLockPassword = false;

  // Controller Update Informations Personnelles
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // Controller Update mot de passe
  TextEditingController motdepasseController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  // Clé globales des formulaires
  final keyFormUpdateInfo = GlobalKey<FormState>();
  final keyFormUpdatePassword = GlobalKey<FormState>();
  final keyFormUpdateMail = GlobalKey<FormState>();

  // Visibilité du mot de passe
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // Firebase Auth
  final auth = FirebaseAuth.instance;

  // Première lettre en majuscule
  String capitalizeDay(String s) => s[0].toUpperCase() + s.substring(1);

  // Fonction de modification de données personnelles
  void updatePerso() async {
    final formState = keyFormUpdateInfo.currentState;
    if(formState!.validate()) {
      formState.save();
      try {
        if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty) {
          await FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(userAuth!.uid).update({
              "firstName": firstNameController.text,
              "lastName": lastNameController.text,
            }).then((value) async {
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
                          "Les informations relatives à votre compte ont été modifiées avec succès.",
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
              formState.reset();
            }).catchError((onError) async {
              // Erreur d'interruption d'authentification
            if(onError.hashCode == 277133790) {
              await MethodFirebase().signOut().whenComplete(() {
                    Navigator.pushNamedAndRemoveUntil(context, 'LoginPage', ModalRoute.withName('/'));
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
                                "Vous avez été déconnecté suite à une erreur d'authentification, veuillez réessayer.",
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
                  });
              // Erreur d'interruption de connexion
            } else if(onError.hashCode == 271948972) {
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
                          "En raison d'une connexion instable, la modification a échoué.",
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
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  // Fonction de modification du mot de passe
  void updatePassword() async {
    final formState = keyFormUpdatePassword.currentState;
    if(formState!.validate()) {
      formState.save();
      try {
        if(motdepasseController.text.isNotEmpty && confirmPassword.text.isNotEmpty && confirmPassword.text == motdepasseController.text) {
          await userAuth!.updatePassword(motdepasseController.text).then((value){
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
                        "Votre mot de passe a été modifiée avec succès.",
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
            formState.reset();
          }).catchError((onError) {
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
                          "En raison d'une connexion instable, la modification a échoué.",
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
            } else {
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
                          "En raison d'une erreur non identifiable, la modification a échoué.",
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
        } else {
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
                      "Vos mots de passe ne correspondent pas.",
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
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                      color: Theme.of(context).hintColor,
                    ),
                    splashRadius: 15,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      child: Image.asset(
                        'assets/iconSignIn.png',
                        height: MediaQuery.of(context).size.height * 0.15,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).hintColor,
                  size: 35,
                ),
                title: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(userAuth!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Chargement des données...",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                    if(snapshot.connectionState == ConnectionState.none) {
                      return  Text(
                        "Aucune donnée n'a été saisie.",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    } else {
                      return  Text(
                        'Nom : ' + snapshot.data!['lastName'],
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                  },
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).hintColor,
                  size: 35,
                ),
                title: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(userAuth!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Chargement des données...",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                    if(snapshot.connectionState == ConnectionState.none) {
                      return  Text(
                        "Aucune donnée n'a été saisie.",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    } else {
                      return  Text(
                        'Prénom : ' + snapshot.data!['firstName'],
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                  },
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                leading: Icon(
                  Icons.email,
                  color: Theme.of(context).hintColor,
                  size: 35,
                ),
                title: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(userAuth!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Chargement des données...",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                    if(snapshot.connectionState == ConnectionState.none) {
                      return  Text(
                        "Aucune donnée n'a été saisie.",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    } else {
                      return  Text(
                        'Email : ' + snapshot.data!['email'],
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                  },
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              ListTile(
                tileColor: Colors.grey.withOpacity(0.1),
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).hintColor,
                  size: 35,
                ),
                title: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('utilisateurs_inscrit').doc(userAuth!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Chargement des données...",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                    if(snapshot.connectionState == ConnectionState.none) {
                      return  Text(
                        "Aucune donnée n'a été saisie.",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    } else {
                      return  Text(
                        'Statut : ' + capitalizeDay(snapshot.data!['role']),
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18
                        ),
                      );
                    }
                  },
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Activation de l'affichage du formulaire des données personnelles.
                    if(updateInformationsWidget == false){
                      updateInformationsWidget = true;
                      // Désactivation de l'affichage du formulaire de modification d'adresse mail
                      updateEmailBool = false;
                      // Icon de dévérouillage désactivé
                      iconLockUpdateMail = false;
                      // Icon de dévérouillage désactivé
                      iconLockPassword = false;
                      // Icon de dévérouillage activé
                      iconLockUpdateInfoPerso = true;
                      // Désactivation de l'affichage du formulaire de modification mot de passe.
                      updatePasswordWidget = false;
                    } else {
                      // Icon de dévérouillage activé
                      iconLockUpdateInfoPerso = false;
                      // Désactivation de l'affichage du formulaire des données personnelles
                      updateInformationsWidget = false;
                    }
                  });
                },
                child: ListTile(
                  tileColor: Colors.grey.withOpacity(0.1),
                  leading: iconLockUpdateInfoPerso ? const Icon(
                    Icons.lock_open,
                    color: Colors.green,
                    size: 35,
                  ): const Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 35,
                  ),
                  title: Text(
                    'Modifier mes informations personnelles',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              updateInformationsWidget ? Container(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Divider(
                    color: Theme.of(context).hintColor,
                    height: 1,
                    thickness: 1,
                    indent: 50,
                    endIndent: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Formulaire de modification de données personnelles',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Form(
                      key: keyFormUpdateInfo,
                      child: Container(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1, left: MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez saisir un prénom';
                                  }
                                  return null;
                                },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-éàçè]+$'))
                              ],
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onSaved: (input) => firstNameController.text = input!,
                              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                contentPadding: const EdgeInsets.all(18),
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
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).hintColor,
                                ),
                                labelText: 'Prénom',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                ),
                                hintText: 'Exemple : Corentin',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            TextFormField(
                              validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez saisir un nom';
                                  }
                                  return null;
                                },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-éàçè]+$'))
                              ],
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              onSaved: (input) => lastNameController.text = input!,
                              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                contentPadding: const EdgeInsets.all(18),
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
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).hintColor,
                                ),
                                labelText: 'Nom',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                ),
                                hintText: 'Exemple : Scott',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            ElevatedButton(
                                  onPressed: () async {
                                    if (keyFormUpdateInfo.currentState!.validate()) {
                                      return updatePerso();
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Theme.of(context).primaryColor
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
                                      'Modifier mes informations',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                              ),
                          ],
                        ),
                      )
                    )
                  ],
                )
              ) : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Activation de l'affichage du formulaire des données personnelles.
                    if(updatePasswordWidget == false){
                      // Désactivation de l'affichage du formulaire de modification d'adresse mail
                      updateEmailBool = false;
                      // Désactivation de l'affichage du formulaire des données personnelles
                      updateInformationsWidget = false;
                      // Icon de dévérouillage désactivé
                      iconLockUpdateMail = false;
                      // Icon de dévérouillage activé
                      iconLockPassword = true;
                      // Icon de dévérouillage désactivé
                      iconLockUpdateInfoPerso = false;
                      // Activation de l'affichage du formulaire de modification mot de passe.
                      updatePasswordWidget = true;
                    } else {
                      // Icon de dévérouillage désactivé
                      iconLockPassword = false;
                      // Désactivation de l'affichage du formulaire de modification mot de passe.
                      updatePasswordWidget = false;
                    }
                  });
                },
                child: ListTile(
                  tileColor: Colors.grey.withOpacity(0.1),
                  leading: iconLockPassword ? const Icon(
                    Icons.lock_open,
                    color: Colors.green,
                    size: 35,
                  ) : const Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 35,
                  ),
                  title: Text(
                    'Modifier mon mot de passe',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              updatePasswordWidget ? Container() : SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              updatePasswordWidget ? Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Divider(
                    color: Theme.of(context).hintColor,
                    height: 1,
                    thickness: 1,
                    indent: 50,
                    endIndent: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Text(
                      'Formulaire de modification de mot de passe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Form(
                      key: keyFormUpdatePassword,
                      child: Container(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1, left: MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez saisir un mot de passe';
                                  }
                                  if(input.isNotEmpty && input.length < 6) {
                                    return 'Votre mot de passe fait moins de 6 caractères';
                                  }
                                  return null;
                                },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-=@,\.;<>?/:=+%*()!#&§%]+$'))
                              ],
                              obscureText: !passwordVisibility,
                              textInputAction: TextInputAction.next,
                              onSaved: (input) => motdepasseController.text = input!,
                              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                contentPadding: const EdgeInsets.all(18),
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
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  color: Theme.of(context).hintColor,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(
                                    () => passwordVisibility = !passwordVisibility,
                                  ),
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                                labelText: 'Nouveau mot de passe',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                ),
                                hintText: 'Exemple : 19poIuy78',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            TextFormField(
                              validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez saisir une deuxième fois votre mot de passe';
                                  }
                                  if(input.isNotEmpty && input.length < 6) {
                                    return 'Votre mot de passe fait moins de 6 caractères';
                                  }
                                  return null;
                                },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-=@,\.;<>?/:=+%*()!#&§%]+$'))
                              ],
                              obscureText: !confirmPasswordVisibility,
                              textInputAction: TextInputAction.done,
                              onSaved: (input) => confirmPassword.text = input!,
                              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
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
                                contentPadding: const EdgeInsets.all(18),
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
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  color: Theme.of(context).hintColor,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(
                                    () => confirmPasswordVisibility = !confirmPasswordVisibility,
                                  ),
                                  child: Icon(
                                    confirmPasswordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                                labelText: 'Confirmation du mot de passe',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                ),
                                hintText: 'Identique au précédent',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            ElevatedButton(
                                  onPressed: () async {
                                    if (keyFormUpdatePassword.currentState!.validate()) {
                                      return updatePassword();
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Theme.of(context).primaryColor
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
                                      'Modifier mon mot de passe',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                          ],
                        ),
                      )
                    )
                  ],
                )
              ) : Container(),
            ],
          )
        ),
      )
    );
  }
}