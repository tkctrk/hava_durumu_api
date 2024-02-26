import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_hava_durumu_app/models/weather_model.dart';
import 'package:flutter_api_hava_durumu_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];

  void _getWeatherDAta() async {
    _weathers = await WeatherService().getWeatherData();
    setState(() {});
  }

  @override
  void initState() {
    _getWeatherDAta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: _weathers.length,
          itemBuilder: (context, index) {
            final WeatherModel weather = _weathers[index];
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(children: [
                Image.network(
                  weather.ikon,
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${weather.durum.toUpperCase()} ${weather.derece}',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Min : ${weather.min}'),
                        Text('Max : ${weather.max}'),
                      ],
                    ),
                  ],
                )
              ]),
            );
          },
        ),
      ),
    );
  }
}
