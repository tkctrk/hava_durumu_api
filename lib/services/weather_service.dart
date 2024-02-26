import 'package:dio/dio.dart';
import 'package:flutter_api_hava_durumu_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  Future<String> _getLocation() async {
    //BURADA KONUM SERVİSİNİ AÇIK OLUP OLMADIGINI KONTROL ETTIK.
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Konum Servisiniz Kapalı');
    }

    //BURADA KONUM SERVİSİ İZNİ VERMİŞ Mİ KONTROL ETTIK.
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // KONUM İZİN VERMEMİŞ İSE TEKRAR İZİN İSTEDİK
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //YİNE VERMEDİYSE HATA KODU DÖNDÜRDÜK.
        Future.error('Konum İzni Vermelisiniz.');
      }
    }
    // Kullanıcıdan pozisyon aldık
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
// Kullanıcıdan pozisyonunda yerleşim noktasını bulduk.
    final List<Placemark> placeMark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
//Şehrimizi yerleşim noktasından kaydettik.
    final String? city = placeMark[0].administrativeArea;

    if (city == null) Future.error('Bir Sorun Oluştu');

    return city!;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await _getLocation();

    final String url =
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city';
    const Map<String, dynamic> headers = {
      'authorization': "apikey your_token",
      'content-type': "application/json"
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error('Bir Sorun oluştu');
    }

    final List list = response.data['result'];

    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();
    return weatherList;
  }
}
