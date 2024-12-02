class User {
  String username;
  String? email;
  String password;
  bool enabled=false ;
  List<String>? roles ;
  int? id ;

  User(this.username,this.email,this.password , [this.id]);



  // Méthode pour afficher les informations utilisateur
  @override
  String toString() {
    return 'User(username: $username, email: $email, enabled: $enabled, roles: $roles)';
  }
}
