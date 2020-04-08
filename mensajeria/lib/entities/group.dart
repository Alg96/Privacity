class Group {
  String id;
  String nombre;
  String descripcion;
  String propietario;

  Group(this.id, this.nombre, this.descripcion,this.propietario);

  Group.fromJson(Map<String, dynamic> json) {
    id = json['Oid'];
    nombre = json['Nombre'];
    descripcion = json['Descripcion'];
    propietario = json['Propietario'];
  }
}