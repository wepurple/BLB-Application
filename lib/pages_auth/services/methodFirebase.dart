// ignore_for_file: file_names
import 'dart:io';

import 'package:blb_entreprise/pages_auth/services/methodUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MethodFirebase {

  // Instancier Firebase Authentication //
  final _authFirebase = FirebaseAuth.instance;

  // Login
  Future connexionClientToFirebase(String _email, String _motdepasse) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _motdepasse);
  }

  // Reinitialisation du mot de passe par mail
  Future resetPasswordForEmail(String _email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
  }

  Future inscriptionClientToFirebase(String _email, _password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
  }


  // Détails de l'inscription vers firestore //
  Future postInfoClientToFirestore(String _firstName, String _lastName) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    MethodUser methodUser = MethodUser();

    methodUser.uid = user!.uid;
    methodUser.email = user.email;
    methodUser.firstName = _firstName;
    methodUser.lastName = _lastName;
    methodUser.role = 'client';
    methodUser.policy = 'accepted';

    final userRef = firebaseFirestore.collection('utilisateurs_inscrit').doc(user.uid);

    await userRef.set(methodUser.toMap());
    await _saveDevice(user);
  }

  // Méthode de sauvegarde des informations mobiles de l'utilisateur //
  static _saveDevice(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    late String deviceId;
    late Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": "android",
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "platform": "ios",
        "model": deviceInfo.model,
        "device": deviceInfo.name,
      };
    }
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final deviceRef = firebaseFirestore
        .collection('utilisateurs_inscrit')
        .doc(user.uid)
        .collection("appareils_enregistré")
        .doc(deviceId);

    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMs,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "created_at": nowMs,
        "updated_at": nowMs,
        "uninstalled": false,
        "id": deviceId,
        "device_info": deviceData,
      });
    }
  }

  // Méthode de déconnexion à Firebase //
  Future signOut() async {
    try {
      await _authFirebase.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}