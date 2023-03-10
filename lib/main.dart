import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home:const HomePage(),
    );
  }
}

enum City {
  kathmandu,
  pokhara,
  biratnagar,
  bharatpur,
  butwal,
  dharan,
  hetauda,
  janakpur,
  kirtipur,
  lalitpur,
  nepalganj,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeatherEmoji(City city) async {
  return Future.delayed(
    const Duration(seconds: 2),
    () =>
        {
          City.bharatpur: 'π¦οΈ',
          City.biratnagar: 'β',
          City.butwal: 'π',
          City.dharan: 'βοΈ',
          City.hetauda: 'π',
          City.janakpur: 'π€£',
          City.kathmandu: 'π€¦ββοΈ',
          City.kirtipur: 'π',
          City.lalitpur: 'πππ',
          City.nepalganj: 'βοΈ',
          City.pokhara: ' π₯Ίπ₯Ήπ₯Ή',
        }[city] ??
        "π€·ββοΈ",
  );
}
  
const unKnownWeather = "π€·ββοΈ";

final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) { 
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeatherEmoji(city);
  } else {
    return unKnownWeather;
  }
});

// Consumer Widget
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(data, style: const TextStyle(fontSize: 50)),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) =>  const Center(child:  Text("Error: π₯²")),
          ),
          Expanded(
            child: ListView.builder(
            itemCount: City.values.length,
            itemBuilder: (context, index) {
              final city = City.values[index];
              final isSelected = city == ref.watch(currentCityProvider);
              return ListTile(
                title: Text(city.toString().split('.').last),
                onTap: () =>  ref.read(currentCityProvider.notifier).state = city,
                trailing: isSelected ? const Icon(Icons.check) : null,
              );
            },
          )),
        ],
      ),
    );
  }
}