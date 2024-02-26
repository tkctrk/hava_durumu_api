class WeatherModel {
  final String ikon;
  final String durum;
  final String derece;
  final String min;
  final String max;
  final String gece;
  final String nem;

  WeatherModel(this.ikon, this.durum, this.derece, this.min, this.max,
      this.gece, this.nem);

  WeatherModel.fromJson(Map<String, dynamic> json)
      : ikon = json['icon'],
        durum = json['durum'],
        derece = json['derece'],
        min = json['min'],
        max = json['max'],
        gece = json['gece'],
        nem = json['nem'];
}
