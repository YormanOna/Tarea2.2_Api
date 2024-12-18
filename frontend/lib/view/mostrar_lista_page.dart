import 'package:flutter/material.dart';
import '../controllers/datos_controller.dart';
import '../models/datos_model.dart';
import 'crear_persona_page.dart';

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
      await Future.forEach<DatosApi>(
        await _controladorDatos.obtenerTodosLosDatos(),
        (persona) async => await _controladorDatos.eliminarDato(persona.id),
      );
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
        backgroundColor: const Color.fromARGB(255, 40, 80, 99),
        centerTitle: true,
        elevation: 5,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 174, 221, 245), Color.fromARGB(255, 120, 156, 186)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<DatosApi>>(
          future: _datosFuturos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 50, color: Colors.red),
                    SizedBox(height: 10),
                    Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 80, color: Colors.white),
                    SizedBox(height: 10),
                    Text('No se encontraron personas.', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              );
            } else {
              final datos = snapshot.data!;
              return ListView.builder(
                itemCount: datos.length,
                itemBuilder: (context, index) {
                  final persona = datos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(
                          persona.nombre[0],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        backgroundColor: const Color.fromARGB(255, 40, 80, 99),
                      ),
                      title: Text('${persona.nombre} ${persona.apellido}', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Teléfono: ${persona.telefono}'),
                      trailing: Wrap(
                        spacing: 10,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CrearPersonaPage(persona: persona),
                                ),
                              ).then((_) => _cargarDatos());
                            },
                          ),
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
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
