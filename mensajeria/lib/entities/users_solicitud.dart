class Solicitud {
  String id;
  String correousuario;
  String canal;
  String correocomunicador;
  String estado;

 Solicitud(this.id, this.correousuario, this.canal, this.correocomunicador,this.estado);

  Solicitud.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    correousuario = json['correo_usuario'];
    canal = json['canal'];
    correocomunicador = json['correo_comunicador'];
    estado = json['estado'];
  }
}