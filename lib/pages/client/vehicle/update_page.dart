import 'package:flutter/material.dart';
import 'package:parking_project/models/to_use/vehicle.dart';
import 'package:parking_project/services/temporal.dart';


class EditVehicle extends StatefulWidget {
  final String IdCli;
  const EditVehicle({super.key, required this.IdCli});

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}


class _EditVehicleState extends State<EditVehicle> {
  TextEditingController placaControler = TextEditingController(text: "");
  TextEditingController colorControler = TextEditingController(text: "");
  TextEditingController marcaControler = TextEditingController(text: "");
  TextEditingController tipoControler = TextEditingController();
  TextEditingController idClienteControler = TextEditingController();

  //Dimenciones
  TextEditingController altoControler = TextEditingController(text: "");
  TextEditingController anchoControler = TextEditingController(text: "");
  TextEditingController largoControler = TextEditingController(text: "");




  //para recuperar el id del Documento
  TextEditingController IDDocument = TextEditingController(text: "");
  late String tipoSeleccionado; // Nuevo

  @override
  void initState() {
    super.initState();

  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  initializePage();
}

 Future<void> initializePage() async {
          VehicleData? data = await getVehicleDataById(widget.IdCli);
            if (data != null) {
              placaControler.text = data.placa;
              colorControler.text = data.color;
              marcaControler.text = data.marca;

                //Dimenciones
               altoControler.text =  data.alto.toString();
               anchoControler.text = data.ancho.toString();
               largoControler.text = data.largo.toString();

              idClienteControler.text = data.idCliente;

              //para el id del Documento del Vehiculo
              IDDocument.text = data.id;

               // Establecer la selección del radio button
                setState(() {
                  tipoControler.text = data.tipo;
                });
            
            } else {
              print('No se pudo obtener los datos del vehículo');
            }
}







  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Vehículo'),
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
                      labelText: 'Numero de Placa',                
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
                    labelText: 'Marca de Vehículo:',              
                  ),
                ),
               ),


                //---------------------------------------------------------------------
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



                //---------------------------------------------------------------------
                              
             Padding(
                    padding: const EdgeInsets.symmetric(vertical:15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo de Vehículo:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 16, 64, 124) // Tamaño del texto del label
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
                          try {         
                           // ProgressDialog.show(context, 'Registrando usuario...');
                            await updateVehicle(sendVehicleData() ,  IDDocument.text ).then((_) {
                                  Navigator.pop(context); 

                               ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Color.fromARGB(255, 26, 73, 17),
                                        duration: Duration(seconds: 3),
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Color.fromARGB(237, 179, 204, 176),
                                            ),
                                            SizedBox(width: 8), // Espacio entre el icono y el texto
                                            Text(
                                              'Vehículo editado exitosamente',
                                              style: TextStyle(
                                                color: Color.fromARGB(237, 203, 222, 190),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );


                            });              

                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            print(e);
                          }
                }, 
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0), // Ajusta el tamaño aquí
                ),
                 child: const Text("Guardar Cambios"),
                ),
                
              )
            ],
              ),
            ),
       


        // body:  Padding(
        //   padding: const EdgeInsets.symmetric(horizontal:25.0),
        //   child: Column(
        //     children:  [
        //         Padding(
        //           padding: const EdgeInsets.all(1.0),
        //           child: TextField(
        //             controller: placaControler,
        //             decoration: const  InputDecoration(
        //               labelText: 'Numero de Placa',                
        //             ),
        //           ),
        //         ),
              

        //         Padding(
        //          padding: const EdgeInsets.all(1.0),
        //          child: TextField(
        //           controller: colorControler,
        //           decoration: const  InputDecoration(
        //             labelText: 'Color',                  
        //           ),
        //          ),
        //         ),


        //       Padding(
        //          padding: const EdgeInsets.all(1.0),
        //          child: TextField(
        //           controller: marcaControler,
        //           decoration: const InputDecoration(
        //             labelText: 'Marca de Vehículo:',              
        //           ),
        //         ),
        //        ),


        //         //---------------------------------------------------------------------
        //             Padding(
        //          padding: const EdgeInsets.all(1.0),
        //          child: TextField(
        //           controller: altoControler,
        //           decoration: const InputDecoration(
        //             labelText: 'Alto',
        //           ),
        //         ),
        //        ),

        //         Padding(
        //          padding: const EdgeInsets.all(1.0),
        //          child: TextField(
        //           controller: anchoControler,
        //           decoration: const InputDecoration(
        //             labelText: 'Ancho',
        //           ),
        //         ),
        //        ),

        //         Padding(
        //          padding: const EdgeInsets.all(1.0),
        //          child: TextField(
        //           controller: largoControler,
        //           decoration: const InputDecoration(
        //             labelText: 'Largo',
        //           ),
        //         ),
        //        ),



        //         //---------------------------------------------------------------------
                              
        //      Padding(
        //             padding: const EdgeInsets.symmetric(vertical:15.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 const Text(
        //                   'Tipo de Vehículo:',
        //                   style: TextStyle(
        //                     fontSize: 16,
        //                     color: Color.fromARGB(255, 16, 64, 124) // Tamaño del texto del label
        //                     // Opcional: estilo del texto del label
        //                   ),
        //                 ),
        //                 const SizedBox(height: 8), // Espacio entre el label y los RadioListTile
        //                 Column(
        //                   children: [
        //                     RadioListTile<String>(
        //                       title: const Text('Automóvil'),
        //                       value: 'Automóvil',
        //                       groupValue: tipoControler.text,
        //                       onChanged: (String? newValue) {
        //                         setState(() {
        //                           tipoControler.text = newValue!;
        //                         });
        //                       },
        //                     ),
        //                     RadioListTile<String>(
        //                       title: const Text('Motocicleta'),
        //                       value: 'Motocicleta',
        //                       groupValue: tipoControler.text,
        //                       onChanged: (String? newValue) {
        //                         setState(() {
        //                           tipoControler.text = newValue!;
        //                         });
        //                       },
        //                     ),
        //                     RadioListTile<String>(
        //                       title: const Text('Otro'),
        //                       value: 'Otro',
        //                       groupValue: tipoControler.text,
        //                       onChanged: (String? newValue) {
        //                         setState(() {
        //                           tipoControler.text = newValue!;
        //                         });
        //                       },
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),






        //       Padding(
        //         padding: const EdgeInsets.only(top: 10.0),
                
        //         child: ElevatedButton(
        //           onPressed: () async {
        //                   try {         
        //                    // ProgressDialog.show(context, 'Registrando usuario...');
        //                     await updateVehicle(sendVehicleData() ,  IDDocument.text ).then((_) {
        //                           Navigator.pop(context); 

        //                        ScaffoldMessenger.of(context).showSnackBar(
        //                             const SnackBar(
        //                                 backgroundColor: Color.fromARGB(255, 26, 73, 17),
        //                                 duration: Duration(seconds: 3),
        //                                 content: Row(
        //                                   children: [
        //                                     Icon(
        //                                       Icons.check_circle,
        //                                       color: Color.fromARGB(237, 179, 204, 176),
        //                                     ),
        //                                     SizedBox(width: 8), // Espacio entre el icono y el texto
        //                                     Text(
        //                                       'Vehículo editado exitosamente',
        //                                       style: TextStyle(
        //                                         color: Color.fromARGB(237, 203, 222, 190),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             );


        //                     });              

        //                   } catch (e) {
        //                     // ignore: use_build_context_synchronously
        //                     print(e);
        //                   }
        //         }, 
        //         style: ElevatedButton.styleFrom(
        //             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0), // Ajusta el tamaño aquí
        //         ),
        //          child: const Text("Guardar Cambios"),
        //         ),
                
        //       )
        //     ],
        //   ),


        )
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




        idCliente: idClienteControler.text,
        );
    return vehicleData;
  }
}




