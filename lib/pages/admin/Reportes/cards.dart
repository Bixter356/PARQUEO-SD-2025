import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parking_project/pages/admin/Reportes/calculo_total.dart';
import 'package:parking_project/pages/admin/Reportes/reporte_reserva.dart';
import 'package:parking_project/pages/admin/Reportes/top.dart';
import 'package:parking_project/pages/admin/Reportes/top_clientes_reservas.dart';
import 'package:parking_project/pages/admin/Reportes/top_parqueos_reservas.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedGlassCard(
              text: 'Duración promedio de reserva de clientes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreen()),
                );
              },
            ),
            AnimatedGlassCard(
              text: 'Promedio de Pago',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreenTotal()),
                );
              },
            ),
            AnimatedGlassCard(
              text: 'Ranking',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
            ),
            AnimatedGlassCard(
              text: 'Top clientes con más reservas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreenRankingReserves()),
                );
              },
            ),
            AnimatedGlassCard(
              text: 'Top parqueos con más reservas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreenParkingReserves()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}

class AnimatedGlassCard extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const AnimatedGlassCard({super.key, required this.text, this.onTap});

  @override
  AnimatedGlassCardState createState() => AnimatedGlassCardState();
}

class AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _controller.forward(),
      onTapUp: (details) => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: GlassCard(text: widget.text),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class GlassCard extends StatelessWidget {
  final String text;

  const GlassCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 150,
          width: 300,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.pinkAccent,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
