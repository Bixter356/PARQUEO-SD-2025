import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:app_3_27_4/models/coleccion/collection_field.dart';
import 'package:app_3_27_4/models/coleccion/collections.dart';
import 'package:app_3_27_4/models/user.dart';

class AccountRequestScreen extends StatelessWidget {
  static const routeName = '/create-place-srceen';

  const AccountRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Solicitudes de cuentas'),
            backgroundColor: const Color.fromARGB(255, 5, 126, 225)),
        body: const RequestListScreen(),
      );
  }
}

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  RequestListScreenState createState() => RequestListScreenState();
}

class RequestListScreenState extends State<RequestListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getRequests(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Obtén la lista de plazas
          List<UserData> users =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            //DocumentReference idDocumento = document.reference; // Obtener

            return UserData(
              nombre: data[AccountRequestCollection.nombre],
              apellidos: data[AccountRequestCollection.apellido],
              telefono: data[AccountRequestCollection.telefono],
              correoElectronico: data[AccountRequestCollection.correo],
              genero: 'M',
              typeUser: data[AccountRequestCollection.tipo],
              contrasena: data[AccountRequestCollection.detalle],
              id: document.id,
            );
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userRequest = users[index];
              return InkWell(
                onTap: () {
                  // Implementa aquí la lógica que se realizará al hacer clic en el elemento.
                  // Por ejemplo, puedes abrir una pantalla de detalles de la plaza.
                },
                child: Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      userRequest.nombre,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userRequest.correoElectronico,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.read_more, color: Colors.blue),
                      onPressed: () {
                        // Implementa aquí la lógica para abrir la pantalla de edición.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestDetailScreen(idRequest: userRequest.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // // Función para editar la plaza
  // void editarPlaza(Plaza plaza) {
  //   // Implementa aquí la lógica para editar la plaza.
  //   // Puedes navegar a la pantalla de edición y pasar la plaza como argumento.
  // }
}

class RequestDetailScreen extends StatefulWidget {
  final String idRequest; // Recibe el ID de la plaza

  const RequestDetailScreen({super.key, required this.idRequest});

  @override
  RequestDetailScreenState createState() => RequestDetailScreenState();
}

class RequestDetailScreenState extends State<RequestDetailScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  String tipoVehiculo = '';
  bool tieneCobertura = false;
  String genero = 'Masculino';
  String descripcion = '';

  @override
  void initState() {
    super.initState();
    getRequestData(); // Carga los datos de la plaza en initState
  }

  Future<void> getRequestData() async {
    try {
      // DocumentSnapshot<Map<String, dynamic>> plazaDoc = await FirebaseFirestore
      //     .instance
      //     .collection('parqueo')
      //     .doc('ID-PARQUEO-3')
      //     .collection('pisos')
      //     .doc('ID-PISO-1')
      //     .collection('filas')
      //     .doc('ID-FILA-1')
      //     .collection('plazas')
      //     .doc(widget.idPlaza) // Usa el ID de la plaza pasado como argumento
      //     .get();
      String idRequest = widget.idRequest;
      DocumentSnapshot<Map<String, dynamic>> requestDoc =
          await FirebaseFirestore.instance
              .collection(Collection.ownerAccount)
              .doc(idRequest)
              .get();

      if (requestDoc.exists) {
        Map<String, dynamic> data = requestDoc.data() as Map<String, dynamic>;
        setState(() {
          nombreController.text = data[AccountRequestCollection.nombre];
          apellidoController.text = data[AccountRequestCollection.apellido];
          telefonoController.text = data[AccountRequestCollection.telefono];
          correoController.text = data[AccountRequestCollection.correo];
          descripcionController.text = data[AccountRequestCollection.detalle];
          tipoVehiculo = data['tipoVehiculo'];
          tieneCobertura = data['tieneCobertura'];
        });
      }
    } catch (e) {
      log('Error al cargar los datos de la plaza: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido(s)',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // TextFormField(
              //   controller: correoController,
              //   decoration: const InputDecoration(
              //     labelText: 'Correo',
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue, width: 2.0),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20.0),
              // TextFormField(
              //   controller: telefonoController,
              //   decoration: const InputDecoration(
              //     labelText: 'Teléfono',
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue, width: 2.0),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20.0),
              // const Text(
              //   'Genero',
              //   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              // ),
              // Row(
              //   children: <Widget>[
              //     Radio(
              //       value: 'Masculino',
              //       groupValue: genero,
              //       onChanged: (val) {
              //         setState(() {
              //           genero = val!;
              //         });
              //       },
              //     ),
              //     const Text('Masculino'),
              //     Radio(
              //       value: 'Femenino',
              //       groupValue: genero,
              //       onChanged: (val) {
              //         setState(() {
              //           genero = val!;
              //         });
              //       },
              //     ),
              //     const Text('Femenino'),
              //   ],
              // ),
              //const SizedBox(height: 20.0),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await setRejectRequest(widget.idRequest);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Rechazar Solicitud',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await setEnabledRequest(widget.idRequest);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Aprobar Solicitud',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> setEnabledRequest(String idRequest) async {
  try {
    // Obtén una referencia al documento de la solicitud que deseas editar
    final DocumentReference requestRef = FirebaseFirestore.instance
        .collection(Collection.ownerAccount)
        .doc(idRequest);

    final DocumentSnapshot<Map<String, dynamic>> requestDoc =
        await FirebaseFirestore.instance
            .collection(Collection.ownerAccount)
            .doc(idRequest)
            .get();
    final Map<String, dynamic> datos =
        requestDoc.data() as Map<String, dynamic>;

    // Actualiza el estado en el documento de la solicitud
    await requestRef.update({UsersCollection.estado: 'habilitado'});

    // Crea un documento de usuario habilitado con los datos de la solicitud
    await FirebaseFirestore.instance
        .collection(Collection.usuarios)
        .doc(idRequest)
        .set({
      UsersCollection.nombre: datos[UsersCollection.nombre],
      UsersCollection.apellido: datos[UsersCollection.apellido],
      UsersCollection.telefono: datos[UsersCollection.telefono],
      UsersCollection.correo: datos[UsersCollection.correo],
      UsersCollection.tipo: 'Dueño',
      UsersCollection.estado: 'habilitado',
      'puntaje':5,
      'sumaPuntos':5,
      'cantidadResenias':1
      // Agrega otros campos de datos aquí
    });
    sendEmail(datos[UsersCollection.correo]);
  } catch (e) {
    log('Error al editar la solicitud: $e');
  }
}

Future<void> setRejectRequest(String idRequest) async {
  try {
    // Obtén una referencia al documento de la solicitud que deseas editar
    final DocumentReference requestRef = FirebaseFirestore.instance
        .collection(Collection.ownerAccount)
        .doc(idRequest);

    final DocumentSnapshot<Map<String, dynamic>> requestDoc =
        await FirebaseFirestore.instance
            .collection(Collection.ownerAccount)
            .doc(idRequest)
            .get();
    final Map<String, dynamic> datos =
        requestDoc.data() as Map<String, dynamic>;

    // Actualiza el estado en el documento de la solicitud
    await requestRef.update({UsersCollection.estado: 'Denegado'});
    // Obtén una referencia al documento de la plaza que deseas editar
    sendEmailReject(datos[UsersCollection.correo]);
    // Utiliza update para modificar campos existentes o set con merge: true
  } catch (e) {
    log('Error al editar la plaza: $e');
  }
}

Stream<QuerySnapshot> getRequests() {
  try {
    CollectionReference plazasCollection =
        FirebaseFirestore.instance.collection(Collection.ownerAccount);
    return plazasCollection
        .where('estado', isEqualTo: 'pendiente')
        .snapshots(); // Filtra documentos donde 'estado' sea 'habilitado'
  } catch (e) {
    log('Error al obtener el Stream de plazas: $e');
    rethrow;
  }
}

void sendEmail(String mail) async {
  final smtpServer = gmail('rishe356@gmail.com', 'uypaszbvbzuohbxv');

  final message = Message()
    ..from = const Address('rishe356@gmail.com')
    ..recipients.add(mail)
    ..subject = 'Estado de Cuenta'
    ..html = """
      <!DOCTYPE html>
      <html>
      <head>
          <title>BIENVENIDO</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
              }
              h1 {
                  color: #333333;
              }
              p {
                  color: #666666;
              }
              .message {
                  background-color: #f2f2f2;
                  padding: 10px;
                  margin-bottom: 20px;
              }
          </style>
      </head>
      <body>
          <h1>Solicitud de Cuenta</h1>
          <p>Estimado Usuario.</p>
          <p>Su cuenta ha sido Aprobada</p>
          <div class="message">
              <p>Ahora forma parte de la comunidad de parqueos Project-Park.</p>
          </div>
          <p>Atte: Equipo de Desarrollo Project-Park</p>
      </body>
      </html>
    """;

  try {
    final sendReport = await send(message, smtpServer);
    log('Mensaje enviado: ${sendReport.mail}');
  } on MailerException catch (e) {
    log('Error al enviar el correo: $e');
  }
}

void sendEmailReject(String mail) async {
  final smtpServer = gmail('rishe356@gmail.com', 'uypaszbvbzuohbxv');

  final message = Message()
    ..from = const Address('rishe356@gmail.com')
    ..recipients.add(mail)
    ..subject = 'Estado de Cuenta'
    ..html = """
      <!DOCTYPE html>
      <html>
      <head>
          <title>ProJect-Park</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
              }
              h1 {
                  color: #333333;
              }
              p {
                  color: #666666;
              }
              .message {
                  background-color: #f2f2f2;
                  padding: 10px;
                  margin-bottom: 20px;
              }
          </style>
      </head>
      <body>
          <h1>Solicitud de Cuenta</h1>
          <p>Estimado Usuario.</p>
          <p>Su solicitud de cuenta ha sido Denegada</p>
          <div class="message">
              <p>La petición que realizo no cuenta con los requerimientos necesarios para formar parte de la comunidad de parqueos Project-Park.</p>
          </div>
          <p>Atte: Equipo de Desarrollo Project-Park</p>
      </body>
      </html>
    """;

  try {
    final sendReport = await send(message, smtpServer);
    log('Mensaje enviado: ${sendReport.mail}');
  } on MailerException catch (e) {
    log('Error al enviar el correo: $e');
  }
}
