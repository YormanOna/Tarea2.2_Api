import 'package:flutter/material.dart';
import '../controllers/datos_controller.dart';
import '../models/datos_model.dart';

class CrearPersonaPage extends StatefulWidget {
  final DatosApi? persona; // Agregar parámetro para recibir persona

  // Modificar el constructor para aceptar la persona opcional
  CrearPersonaPage({Key? key, this.persona}) : super(key: key);

  @override
  _CrearPersonaPageState createState() => _CrearPersonaPageState();
}

class _CrearPersonaPageState extends State<CrearPersonaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();

  final ControladorDatos _controladorDatos = ControladorDatos();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.persona != null) {
      // Si hay una persona, llenar los campos con los datos existentes
      _nombreController.text = widget.persona!.nombre;
      _apellidoController.text = widget.persona!.apellido;
      _telefonoController.text = widget.persona!.telefono;
    }
  }

  void _crearOActualizarPersona() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final nuevaPersona = {
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'telefono': _telefonoController.text,
        };

        if (widget.persona == null) {
          // Si no hay persona (creación)
          await _controladorDatos.crearDato(nuevaPersona);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Persona creada exitosamente')),
          );
        } else {
          // Si hay persona (edición)
          await _controladorDatos.actualizarDato(widget.persona!.id, nuevaPersona);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Persona actualizada exitosamente')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.persona == null ? 'Crear Persona' : 'Editar Persona'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  icon: Icon(Icons.person, color: Colors.purple),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Apellido
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  icon: Icon(Icons.person_outline, color: Colors.purple),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un apellido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  icon: Icon(Icons.phone, color: Colors.purple),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un número de teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Botón de guardar
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _crearOActualizarPersona,
                      child: Text(widget.persona == null ? 'Guardar' : 'Actualizar'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
