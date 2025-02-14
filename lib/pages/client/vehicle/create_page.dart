import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/vehicle.dart';
import 'package:parking_project/services/temporal.dart';


class CreateVehicle extends StatefulWidget {
  const CreateVehicle({super.key});

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}



class _CreateVehicleState extends State<CreateVehicle> {

  TextEditingController placaControler = TextEditingController(text: "");
  TextEditingController colorControler = TextEditingController(text: "");
  TextEditingController marcaControler = TextEditingController(text: "");
  TextEditingController tipoControler = TextEditingController(text: "");

  TextEditingController altoControler = TextEditingController(text: "");
  TextEditingController anchoControler = TextEditingController(text: "");
  TextEditingController largoControler = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Vehículo'),
          backgroundColor:const Color.fromARGB(255, 76, 203, 218),
        ),


        
         body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children:  [
            
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    controller: placaControler,
                    decoration: const  InputDecoration(
                       labelText: 'Número de Placa',
                     
                    ),
                  ),
                ),
              

                Padding(
                 padding: const EdgeInsets.all(1.0),
                 child: TextField(
                  controller: colorControler,
                  decoration: const  InputDecoration(
                    labelText: 'Color',
                  ),
                 ),
                ),


              Padding(
                 padding: const EdgeInsets.all(1.0),
                 child: TextField(
                  controller: marcaControler,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                  ),
                ),
               ),

               //-------------------------------------------------------------------------
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dimensiones',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TextField(
                                  controller: altoControler,
                                  decoration: const InputDecoration(
                                    labelText: 'Alto',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TextField(
                                  controller: anchoControler,
                                  decoration: const InputDecoration(
                                    labelText: 'Ancho',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TextField(
                                  controller: largoControler,
                                  decoration: const InputDecoration(
                                    labelText: 'Largo',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


               //-------------------------------------------------------------------------



                  Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tipo de Vehículo',
                                style: TextStyle(
                                  fontSize: 16, // Tamaño del texto del label
                                  // Opcional: estilo del texto del label
                                ),
                              ),
                              const SizedBox(height: 8), // Espacio entre el label y los RadioListTile
                              Column(
                                children: [
                                  RadioListTile<String>(
                                    title: const Text('Automóvil'),
                                    value: 'Automovil',
                                    groupValue: tipoControler.text,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        tipoControler.text = newValue!;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Motocicleta'),
                                    value: 'Moto',
                                    groupValue: tipoControler.text,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        tipoControler.text = newValue!;
                                      });
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Otro'),
                                    value: 'Otro',
                                    groupValue: tipoControler.text,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        tipoControler.text = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                  VehicleData vehicle = sendVehicleData();
                   try {                      
                            await registerVehicle(vehicle, context).then((_) {                             
                                  Navigator.pop(context);
                                   // Mostrar un SnackBar de registro exitoso
                               ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Color.fromARGB(255, 9, 34, 92),
                                      duration: Duration(seconds: 4),
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Color.fromARGB(236, 189, 202, 206),
                                          ),
                                          SizedBox(width: 8), // Espacio entre el icono y el texto
                                          Text(
                                            'Vehículo registrado exitosamente',
                                            style: TextStyle(
                                              color: Color.fromARGB(237, 180, 213, 223),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                            });              
                          } catch (e) {                       
                            print(e);
                          }
                }, 
                 style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0), // Ajusta el tamaño aquí
                ),child: const Text("Crear Vehículo")),
              )
            ],
              ),
            ),
          ),
    );
  }


   VehicleData sendVehicleData(){

    double alto = double.tryParse(altoControler.text) ?? 0.0;
    double ancho = double.tryParse(anchoControler.text) ?? 0.0;
    double largo = double.tryParse(largoControler.text) ?? 0.0;

    VehicleData vehicleData = VehicleData(
        placa: placaControler.text,
        color: colorControler.text,
        marca: marcaControler.text,
        tipo: tipoControler.text,

        //Dimenciones
        alto: alto,
        ancho: ancho,
        largo: largo,

        );
    return vehicleData;
  }
}


