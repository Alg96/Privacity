class Usuarios {

String usuario;
String estatus;
String nivel;

Usuarios(this.usuario, this.estatus, this.nivel);

Usuarios.fromJson(Map<String, dynamic> json) {
  usuario = json['Usuario'];
  estatus = json['Estatus'];
  nivel = json['Nivel'];
}

}