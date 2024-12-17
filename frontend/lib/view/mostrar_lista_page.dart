import 'package:flutter/material.dart';
import './crear_persona_page.dart'; // Asegúrate de importar la página de creación
import '../controllers/datos_controller.dart';
import '../models/datos_model.dart';

class MostrarListaPage extends StatefulWidget {
  @override
  _MostrarListaPageState createState() => _MostrarListaPageState();
}

class _MostrarListaPageState extends State<MostrarListaPage> {
  final ControladorDatos _controladorDatos = ControladorDatos();
  late Future<List<DatosApi>> _datosFuturos;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    setState(() {
      _datosFuturos = _controladorDatos.obtenerTodosLosDatos();
    });
  }

  Future<void> _eliminarTodos() async {
    try {
      await Future.forEach<DatosApi>(await _controladorDatos.obtenerTodosLosDatos(),
          (persona) async => await _controladorDatos.eliminarDato(persona.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todas las personas han sido eliminadas.')),
      );
      _cargarDatos();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar todos: $error')),
      );
    }
  }

  Future<void> _eliminarPorId(String id) async {
    try {
      await _controladorDatos.eliminarDato(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Persona eliminada exitosamente.')),
      );
      _cargarDatos();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar persona: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Personas'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: 'Eliminar Todos',
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar eliminación'),
                  content: Text('¿Estás seguro de que deseas eliminar todas las personas?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: Text('Eliminar'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );
              if (confirmar == true) {
                await _eliminarTodos();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DatosApi>>(
        future: _datosFuturos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron personas.'));
          } else {
            final datos = snapshot.data!;
            return ListView.builder(
              itemCount: datos.length,
              itemBuilder: (context, index) {
                final persona = datos[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(persona.nombre[0]),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  title: Text('${persona.nombre} ${persona.apellido}'),
                  subtitle: Text('Teléfono: ${persona.telefono}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón para editar
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navegar a la página de crear/editar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearPersonaPage(persona: persona), // Pasa la persona para editarla
                            ),
                          );
                        },
                      ),

                      // Botón para eliminar
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que deseas eliminar a esta persona?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: Text('Eliminar'),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );
                          if (confirmar == true) {
                            await _eliminarPorId(persona.id);
                          }
                        },
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    ],
                  ),
                  onTap: () {
                    // Aquí puedes implementar la navegación a una página de detalles si lo necesitas
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
