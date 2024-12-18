import 'package:flutter/material.dart';
import '../controllers/datos_controller.dart';
import '../models/datos_model.dart';

class CrearPersonaPage extends StatefulWidget {
  final DatosApi? persona;

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
          await _controladorDatos.crearDato(nuevaPersona);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Persona creada exitosamente')),
          );
        } else {
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
        backgroundColor: const Color.fromARGB(255, 40, 80, 99),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Encabezado visual
              Icon(
                widget.persona == null ? Icons.person_add : Icons.edit,
                size: 100,
                color: const Color.fromARGB(255, 40, 80, 99),
              ),
              SizedBox(height: 10),
              Text(
                widget.persona == null ? 'Agregar Nueva Persona' : 'Editar Persona',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color.fromARGB(255, 40, 80, 99),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 40, 80, 99)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'El nombre solo debe contener letras';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Apellido
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.person_outline, color: const Color.fromARGB(255, 40, 80, 99)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un apellido';
                  }
                  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'El apellido solo debe contener letras';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone, color: const Color.fromARGB(255, 40, 80, 99)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un número de teléfono';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'El teléfono debe contener solo 10 dígitos numéricos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Botón de guardar
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _crearOActualizarPersona,
                      icon: Icon(Icons.save),
                      label: Text(widget.persona == null ? 'Guardar' : 'Actualizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 40, 80, 99),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                    ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 174, 221, 245),
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
