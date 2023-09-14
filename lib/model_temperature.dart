import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class ModelTemperature {
  ModelTemperature(
      {required this.dateTime,
      required this.temperatureCelcius,
      required this.temperatureFahrenheit});
  final String dateTime;
  final double temperatureCelcius;
  final double temperatureFahrenheit;
}

String formatDate(String rawDate) {
  final parsedDate = DateTime.parse(rawDate);
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  final formattedDate = formatter.format(parsedDate);
  return formattedDate;
}

List<ModelTemperature> parseTemperatureData(String xmlData) {
  final document = XmlDocument.parse(xmlData);
  final temperatureDataList = <ModelTemperature>[];

  final parameterNodes = document.findAllElements('parameter');
  for (final parameterNode in parameterNodes) {
    final parameterId = parameterNode.getAttribute('id');
    if (parameterId == 't') {
      final timerangeNodes = parameterNode.findElements('timerange');
      for (final timerangeNode in timerangeNodes) {
        final dateTime = timerangeNode.getAttribute('datetime');
        final celciusValue = double.parse(timerangeNode
            .findElements('value')
            .firstWhere((element) => element.getAttribute('unit') == 'C')
            .text);
        final fahrenheitValue = double.parse(timerangeNode
            .findElements('value')
            .firstWhere((element) => element.getAttribute('unit') == 'F')
            .text);

        final temperatureData = ModelTemperature(
            dateTime: dateTime!,
            temperatureCelcius: celciusValue,
            temperatureFahrenheit: fahrenheitValue);

        temperatureDataList.add(temperatureData);
      }
    }
  }
  return temperatureDataList;
}
