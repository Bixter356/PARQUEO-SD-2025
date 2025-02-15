import 'package:flutter/material.dart';
import 'package:app_3_27_4/services/temporal.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _ordenAscendente = true;
  bool _mostrarClientes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ranking"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dueños"),
                  Switch(
                    value: _mostrarClientes,
                    onChanged: (value) {
                      setState(() {
                        _mostrarClientes = value;
                      });
                    },
                  ),
                  const Text("Clientes"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Mayor a menor"),
                  Switch(
                    value: _ordenAscendente,
                    onChanged: (value) {
                      setState(() {
                        _ordenAscendente = value;
                      });
                    },
                  ),
                  const Text("Menor a mayor"),
                ],
              ),
            ],
          ),
          
          
          
          
          FutureBuilder(
            future: getPeople(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final List<dynamic> people = snapshot.data as List<dynamic>;
                List<dynamic> filteredPeople = List.from(people);
                if (!_mostrarClientes) {
                  filteredPeople = filteredPeople
                      .where((person) => person['tipo'] == 'Dueño')
                      .toList();
                }

                if (_ordenAscendente) {
                  filteredPeople.sort((a, b) =>
                      (a['puntaje'] ?? 0).compareTo(b['puntaje'] ?? 0));
                } else {
                  filteredPeople.sort((a, b) =>
                      (b['puntaje'] ?? 0).compareTo(a['puntaje'] ?? 0));
                }

                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        dataRowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        columns: const [
                          DataColumn(
                              label: Text('Nombre',
                                  style: TextStyle(color: Colors.black))),
                          DataColumn(
                              label: Text('Puntaje',
                                  style: TextStyle(color: Colors.black))),
                        ],
                        rows: filteredPeople.map<DataRow>((person) {
                          return DataRow(cells: [
                            DataCell(Text(person['nombre'] ?? 'Desconocido')),
                            DataCell(Text((person['puntaje'] ?? 0).toString())),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('No hay datos'));
              }
            },
          ),
        ],
      ),
    );
  }
}
