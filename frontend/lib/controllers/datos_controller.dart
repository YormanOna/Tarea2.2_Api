import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datos_model.dart';	 

class ControladorDatos {
  final String baseUrl = 'http://localhost:5000/api/personas'; // Cambia esto por la URL de tu servidor

  // Obtener una persona por ID
  Future<DatosApi> obtenerUnDato(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DatosApi.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Persona no encontrada');
    } else {
      throw Exception('Error al cargar persona');
    }
  }

  // Obtener todas las personas con paginación
  Future<List<DatosApi>> obtenerTodosLosDatos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> datos = json.decode(response.body);
      return datos.map((json) => DatosApi.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  // Filtrar personas con parámetros de consulta
  Future<List<DatosApi>> filtrarDatos(String queryParams) async {
    final response = await http.get(Uri.parse('$baseUrl?$queryParams'));

    if (response.statusCode == 200) {
      final List<dynamic> datos = json.decode(response.body);
      return datos.map((json) => DatosApi.fromJson(json)).toList();
    } else {
      throw Exception('Error al filtrar datos');
    }
  }

  // Crear una nueva persona
  Future<DatosApi> crearDato(Map<String, dynamic> datos) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datos),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return DatosApi.fromJson(data);
    } else {
      throw Exception('Error al crear persona');
    }
  }

  // Actualizar una persona por ID
  Future<DatosApi> actualizarDato(int id, Map<String, dynamic> datos) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datos),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DatosApi.fromJson(data);
    } else {
      throw Exception('Error al actualizar persona');
    }
  }

  // Eliminar una persona por ID
  Future<void> eliminarDato(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar persona');
    }
  }
}
