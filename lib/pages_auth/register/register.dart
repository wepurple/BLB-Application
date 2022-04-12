
import 'package:blb_entreprise/pages_auth/services/methodFirebase.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class BLBRegisterPage extends StatefulWidget {
  const BLBRegisterPage({ Key? key }) : super(key: key);

  @override
  _BLBRegisterPageState createState() => _BLBRegisterPageState();
}

class _BLBRegisterPageState extends State<BLBRegisterPage> {

  final _registerFormKey = GlobalKey<FormState>();

  // Variable de modification du formulaire //
  // ignore: unused_field
  late String _email, _motdepasse, _firstName, _lastName;

  // Affichage du mot de passe //
  bool passwordVisibility = false;
  bool passwordConfirmVisibility = false;

  // Toast Message
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  // Méthode d'inscription à Firebase //
  void register() {
    final formState = _registerFormKey.currentState;
    if(formState!.validate()) {
      formState.save();
      try {
        if(_email.isNotEmpty && _motdepasse.isNotEmpty && _motdepasse.length > 6 && EmailValidator.validate(_email) && _firstName.isNotEmpty && _lastName.isNotEmpty) {
          MethodFirebase().inscriptionClientToFirebase(_email, _motdepasse).then((value) {
            MethodFirebase().postInfoClientToFirestore(_firstName, _lastName).whenComplete(() {
              formState.reset();
              // Message d'inscription effectué avec succès //
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
                          "L'inscription a été effectué avec succès.",
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
              // Redirection //
              Navigator.pushNamedAndRemoveUntil(context, 'LoginPage', ModalRoute.withName('/'));
            });
          }).catchError((onError){
            // Message d'erreur lors de l'inscription//
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
                        "L'inscription a échoué, veuillez réessayer.",
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
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }
  // CheckBox politique de confidentialité
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
            child: Form(
              key: _registerFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/iconSignIn.png',
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    TextFormField(
                      validator: (input) {
                        if(input!.isEmpty) {
                          return 'Veuillez saisir un prénom';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-éàçè]+$'))
                      ],
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onSaved: (input) => _firstName = input!,
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
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        labelText: 'Prénom',
                        labelStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                        ),
                        hintText: 'Exemple : Lucas',
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
                          return 'Veuillez saisir un nom';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-éàçè]+$'))
                      ],
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onSaved: (input) => _lastName = input!,
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
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        labelText: 'Nom',
                        labelStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                        ),
                        hintText: 'Exemple : Felo',
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-@.]+$'))
                      ],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (input) => _email = input!,
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
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        labelText: 'Adresse Mail',
                        labelStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                        ),
                        hintText: 'exemple@gmail.com',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    TextFormField(
                      obscureText: !passwordVisibility,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Veuillez saisir un mot de passe';
                          } else if (input.isNotEmpty && input.length < 6) {
                            return 'Veuillez saisir un mot de passe plus long';
                          }
                          return null;
                        },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-=@,\.;<>?/:=+%*()!#&§%]+$'))
                      ],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSaved: (input) => _motdepasse = input!,
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
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 18,
                          ),
                          hintText: 'Minimum 6 caractères',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                        ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:() {
                              // TODO CHANGING ICON AND EDIT COLLECTION FOR ADD POLICY : ACCEPTED OR NOT
                              if(checkBox == false) {
                                setState(() {
                                  checkBox = true;
                                });
                              } else {
                                setState(() {
                                  checkBox = false;
                                  // Message d'erreur lors de l'acceptation de l'engagement de confidentialité //
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
                                              "Vous n'avez pas accepté notre engagement de confidentialité.",
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
                              }
                            },
                            child: checkBox ? Icon(
                              Icons.check_box,
                              color: Theme.of(context).hintColor,
                            ) : Icon(
                              Icons.check_box_outline_blank,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              "En cochant cette case, vous acceptez l'engagement de confidentialité jointe ci-dessous.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunch('https://blb-fr.com/engagement-de-confidentialite/')) {
                          await launch('https://blb-fr.com/engagement-de-confidentialite/');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(context).hintColor,
                          )
                        ),
                        child: Text(
                          'Engagement de confidentialité',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    ElevatedButton(
                          onPressed: () async {
                            if (_registerFormKey.currentState!.validate() && checkBox == true) {
                              return register();
                            }
                            if(checkBox == false) {
                              // Message d'erreur lors de l'acceptation de l'engagement de confidentialité //
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
                                            "Vous n'avez pas accepté notre engagement de confidentialité.",
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
                              'Confirmer l\'inscription',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18,
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      'Vous n\'êtes pas encore connecté ?',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                                  context, 'LoginPage', ModalRoute.withName('/'));
                      },
                      child: Text(
                        'Connectez-vous ici',
                        style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}