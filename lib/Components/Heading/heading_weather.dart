import 'package:flutter/material.dart';

class HeadingWeather extends StatelessWidget {
  final String temprature;
  final String title;
  final IconData icon;
  const HeadingWeather(
      {super.key,
      required this.temprature,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                temprature,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}
