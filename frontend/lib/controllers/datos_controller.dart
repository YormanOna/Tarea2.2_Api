import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datos_model.dart';

class ControladorDatos {
  final String baseUrl = 'http://localhost:5000/api/personas'; // Cambia a tu URL pública si usas un servidor remoto

  // Obtener una persona por ID
  Future<DatosApi> obtenerUnDato(String id) async { // Cambié int a String
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

  // Obtener todas las personas
  Future<List<DatosApi>> obtenerTodosLosDatos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> datos = json.decode(response.body);
      if (datos.isNotEmpty) {
        return datos.map((json) => DatosApi.fromJson(json)).toList();
      } else {
        return []; // Retorna una lista vacía si no hay datos
      }
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  // Filtrar personas con parámetros de consulta
  Future<List<DatosApi>> filtrarDatos(String queryParams) async {
    final response = await http.get(Uri.parse('$baseUrl?$queryParams'));

    if (response.statusCode == 200) {
      final List<dynamic> datos = json.decode(response.body);
      if (datos.isNotEmpty) {
        return datos.map((json) => DatosApi.fromJson(json)).toList();
      } else {
        return []; // Manejo de respuesta vacía
      }
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
  Future<DatosApi> actualizarDato(String id, Map<String, dynamic> datos) async { // Cambié int a String
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
  Future<void> eliminarDato(String id) async { // Cambié int a String
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar persona');
    }
  }
}
