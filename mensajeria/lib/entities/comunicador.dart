class Comunicador {
  String usuario;
  String password;
  String estatus;
  String nivel;

 Comunicador(this.usuario, this.password, this.estatus,this.nivel);

  Comunicador.fromJson(Map<String, dynamic> json) {
    usuario = json['Usuario'];
    password = json['Password'];
    estatus = json['Estatus'];
    nivel = json['Nivel'];
  }
}