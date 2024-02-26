import 'package:flutter/material.dart';

class WeatherForcast extends StatelessWidget {
  final String time;
  final String temprature;
  final IconData icon;

  const WeatherForcast(
      {super.key,
      required this.time,
      required this.temprature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 8,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                temprature,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
