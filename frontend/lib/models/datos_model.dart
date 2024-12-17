class DatosApi {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final DateTime createdAt;
  final DateTime updatedAt;

  DatosApi({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.createdAt,
    required this.updatedAt,
  });

   // Método para crear una instancia de DatosApi desde un JSON
  factory DatosApi.fromJson(Map<String, dynamic> json) {
    return DatosApi(
      id: json['_id'] ?? '', // Manejo de valores nulos
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      telefono: json['telefono'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Método para convertir una instancia de DatosApi a JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
