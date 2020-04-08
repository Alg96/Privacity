class Channel{
  String id;
  String nombre;
  String descripcion;
  String enlace;
  String propietario;
  String idchat;

 Channel(this.id, this.nombre, this.descripcion, this.enlace,this.propietario,this.idchat);

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['Oid'];
    nombre = json['Nombre'];
    descripcion = json['Descripcion'];
    enlace = json['Enlace'];
    propietario = json['Propietario'];
    idchat = json['Id'];
  }
}