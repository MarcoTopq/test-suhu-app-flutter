import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suhuapp/model_temperature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ModelTemperature> temperaturDataList = <ModelTemperature>[];

  void getData() async {
    final r = await http.get(Uri.parse(
        'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-Lampung.xml'));

    temperaturDataList = parseTemperatureData(r.body);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Suhu Kota Lampung',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: temperaturDataList
                    .map(
                      (e) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDate(e.dateTime.substring(0, 8)),
                                  ),
                                  Text(
                                    e.temperatureCelcius > 30
                                        ? 'Suhu diatas standard'
                                        : e.temperatureCelcius == 30
                                            ? 'Suhu standard'
                                            : 'Suhu dibawah standard',
                                    style: TextStyle(
                                        color: e.temperatureCelcius > 30
                                            ? Colors.red
                                            : e.temperatureCelcius == 30
                                                ? Colors.black
                                                : Colors.blue),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Celcius'),
                                      Text(e.temperatureCelcius.toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text('Fahrenheit'),
                                      Text(e.temperatureFahrenheit.toString())
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
