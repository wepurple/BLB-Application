// ignore_for_file: file_names
class MethodUser {
  String? uid;
  String? email;
  String? role;
  String? firstName;
  String? lastName;
  String? policy;

  MethodUser({this.uid, this.email, this.firstName, this.lastName, this.role, this.policy});

  // recevoir les données du serveur //
  factory MethodUser.fromMap(map) {
    return MethodUser(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      role: map['role'],
      policy: map['role'],
    );
  }

  // envoyer des données à notre serveur //
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'policy': policy
    };
  }
}
