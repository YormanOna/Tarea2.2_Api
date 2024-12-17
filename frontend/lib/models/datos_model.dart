class DatosApi{
  final int? id;
  final String nombre;
  final String apellido;
  final String telefono;

  //Constructor
  DatosApi({
  required this.id,
  required this.nombre,
  required this.apellido,
  required this.telefono,
  });

  factory DatosApi.fromJson(Map<String, dynamic> json) {
    return DatosApi(
      id: json['id'],
      nombre: json['name'] ?? 'Unknown',
      apellido: json['lastname'] ?? 'Unknown',
      telefono: json['phone'] ?? 'Unknown',
    );
  }
}

class Persona{
  final int id;
  String nombre;  // Removed 'final' and 'late'
  String apellido;
  String telefono;

  Persona({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
  });
}