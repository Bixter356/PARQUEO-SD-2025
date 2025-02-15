import 'package:flutter/material.dart';
import 'package:app_3_27_4/pages/client/Vehicle/home_page.dart';
import 'package:app_3_27_4/pages/client/chatCliente/home_client.dart';
import 'package:app_3_27_4/pages/client/reservas_realizadas/reservation_ended.dart';
import 'package:app_3_27_4/pages/client/home_client_page.dart';
import 'package:app_3_27_4/pages/profile.dart';

class MenuClient extends StatefulWidget {
  const MenuClient({super.key});

  @override
  State<MenuClient> createState() => _MenuClientState();
}

class _MenuClientState extends State<MenuClient> {
  int selectedIndex = 0;

  final List<Widget> pages = <Widget>[
    const HomeClient(),
    //const TicketsList(),
    const ReservasFinalizadasCliente(),
    const VehicleScreen(),
    const HomeChatClientScreen(),
    //const ProfilePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            onTap: (index) => setState(() => selectedIndex = index),
            currentIndex: selectedIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_rounded), label: 'Reservas Finalizadas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.car_crash), label: 'Vehiculos'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
            ]),
      );
  }
}
