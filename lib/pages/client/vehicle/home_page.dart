import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_project/pages/client/vehicle/create_page.dart';
import 'package:parking_project/pages/client/vehicle/update_page.dart';
import 'package:parking_project/services/temporal.dart';


class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}





class _VehicleScreenState extends State<VehicleScreen> {


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 120, 146),
        title: const Text('Lista de vehículos'),   
      ),

       //------------------------------------------------------
      body: StreamBuilder<QuerySnapshot>(
  stream: getVehicleData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    } else {
      final vehiculos = snapshot.data?.docs;
      return ListView.builder(
        itemCount: vehiculos?.length,
        itemBuilder: (context, index) {
          final vehiculo = vehiculos?[index].data() as Map<String, dynamic>;
            final idDocumento = vehiculos?[index].id; // Aquí recuperamos el ID del documento
          return Dismissible(
            key: Key(idDocumento!), // Utiliza el id del vehículo como clave
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Color.fromARGB(255, 195, 39, 28),
              child: const Icon(Icons.delete),
            ),
            confirmDismiss: (direction) async {
              final bool? result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('¿Estás seguro de querer eliminar el vehículo con la placa: ${vehiculo['placa']}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              return result ?? false;
            },
            onDismissed: (direction) async {
              await deleteVehicle(idDocumento);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 6),
                    Row(
                      children: [

                        Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: vehiculo['tipo'] == 'Automovil' ? 100 : 70,
                                    height: vehiculo['tipo'] == 'Automovil' ? 100 : 70,
                                    child: Image.asset(
                                      vehiculo['tipo'] == 'Automovil' ? 'assets/auto.png' :
                                      vehiculo['tipo'] == 'Moto' ? 'assets/moto.png' :
                                      'assets/Otro.png',
                                    ),
                                  ),
                                  Text("${vehiculo['tipo']}"), 
                                  Text("${vehiculo['alto']}m x ${vehiculo['ancho']}m"),
                                  Text("Largo: ${vehiculo['largo']}m"),
                                 
                                ],                         
                              ),
                            ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PLACA: ${vehiculo['placa']}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                               const SizedBox(height: 2),
                              Text("${vehiculo['marca']}"),                           
                              Text("${vehiculo['color']}"),
                            ],
                          ),
                        ),


                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditVehicle(IdCli: idDocumento)),
                            );
                          },
                        ),


                        IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          color: const Color.fromARGB(255, 30, 134, 198),
                          onPressed: () {
                            // Lógica para ver el detalle del vehículo
                          },
                        ),


                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  },
),

//-------------------------------------------------------------------


        floatingActionButton: FloatingActionButton(
          onPressed: (){
          //  await Navigator.pushNamed(context, 'createVehicle');
          // setState(() {});
              Navigator.push(context, MaterialPageRoute( builder: (context) => CreateVehicle()),);     
          },
           backgroundColor: Color.fromARGB(255, 8, 64, 121),
          child: const Icon(Icons.add),
        )

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

