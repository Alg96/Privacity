class Miembro {
  String usuario;

 Miembro(this.usuario);

  Miembro.fromJson(Map<String, dynamic> json) {
    usuario = json['Usuario'];
  }
}

class NoMiembro{
  String usuario;

 NoMiembro(this.usuario);

  NoMiembro.fromJson(Map<String, dynamic> json) {
    usuario = json['Usuario'];
  }
}