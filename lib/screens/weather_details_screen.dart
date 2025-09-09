// lib/screens/weather_details_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({super.key});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  String? _cityName;
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // You might want to fetch weather for a default city or user's last known location
    // Example: Fetch weather for Delhi on startup
    // _cityController.text = 'Delhi';
    // _fetchWeather(_cityController.text);
  }

  Future<void> _fetchWeather(String cityName) async {
    if (cityName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name.';
        _weatherData = null; // Clear previous data
        _isLoading = false; // Stop loading if input is empty
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weatherData = null;
    });

    const String apiKey = 'you_api_key'; // Your OpenWeatherMap API key
    // Add ',IN' to ensure results are prioritized for India
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,IN&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
          // OpenWeatherMap API returns the actual city name, use that for display
          _cityName = _weatherData!['name'] + ', ' + _weatherData!['sys']['country'];
        });
      } else {
        // OpenWeatherMap error response often includes a 'message' field
        final errorBody = json.decode(response.body);
        setState(() {
          _errorMessage = errorBody['message'] ?? 'Failed to load weather data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name (e.g., Mumbai, Delhi, Bengaluru)', // Hint for Indian cities
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // No need to check .isNotEmpty here, _fetchWeather handles it
                    _fetchWeather(_cityController.text.trim());
                  },
                ),
              ),
              onSubmitted: (value) {
                _fetchWeather(value.trim()); // Trim whitespace
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 30.0,
              )
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else if (_weatherData != null)
              Expanded(child: _buildWeatherDisplay(context)) // Wrap with Expanded
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'Enter a city to see weather details.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay(BuildContext context) {
    final main = _weatherData!['main'];
    final weather = _weatherData!['weather'][0];
    final wind = _weatherData!['wind'];
    final sys = _weatherData!['sys']; // For sunrise/sunset

    // Get weather icon URL
    // OpenWeatherMap icons: https://openweathermap.org/weather-conditions#How-to-get-icon-URL
    final String iconCode = weather['icon'];
    final String iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';


    return SingleChildScrollView( // Changed to SingleChildScrollView for potentially long content
      child: Column(
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _cityName ?? 'Unknown City', // Use the resolved city name
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(iconUrl, width: 80, height: 80), // Display weather icon
                      Text(
                        '${main['temp'].toStringAsFixed(1)}°C',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    weather['description'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 15),
                  // Group items for better layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherInfoItem(Icons.thermostat_outlined, 'Feels Like', '${main['feels_like'].toStringAsFixed(1)}°C'),
                      _buildWeatherInfoItem(Icons.compress, 'Pressure', '${main['pressure']} hPa'),
                      _buildWeatherInfoItem(Icons.water_drop_outlined, 'Humidity', '${main['humidity']}%'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherInfoItem(Icons.air, 'Wind Speed', '${wind['speed']} m/s'),
                      _buildWeatherInfoItem(Icons.visibility_outlined, 'Visibility', '${_weatherData!['visibility'] / 1000} km'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Using alternative icons for Sunrise/Sunset
                      _buildWeatherInfoItem(Icons.wb_sunny_outlined, 'Sunrise', DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000, isUtc: true).toLocal())),
                      _buildWeatherInfoItem(Icons.nightlight_round, 'Sunset', DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000, isUtc: true).toLocal())),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.green.shade700),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center,),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}



// lib/screens/weather_details_screen.dart


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';

// class WeatherDetailsScreen extends StatefulWidget {
//   const WeatherDetailsScreen({super.key});

//   @override
//   State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
// }

// class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
//   String? _cityName;
//   Map<String, dynamic>? _weatherData;
//   bool _isLoading = false;
//   String? _errorMessage;

//   final TextEditingController _cityController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Optionally fetch for a default city on startup
//     // _cityController.text = 'Delhi'; // Example default city
//     // _fetchWeather(_cityController.text);
//   }

//   Future<void> _fetchWeather(String cityName) async {
//     if (cityName.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter a city name.';
//         _weatherData = null;
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _weatherData = null;
//     });

//     const String apiKey = '0f02a7c368944b7bbaa150015250909'; // <--- REPLACE WITH YOUR WEATHERAPI.COM KEY
//     final String currentUrl =
//         'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=3&aqi=no&alerts=no';

//     try {
//       final response = await http.get(Uri.parse(currentUrl));

//       if (response.statusCode == 200) {
//         setState(() {
//           _weatherData = json.decode(response.body);
//           _cityName = cityName;
//         });
//       } else {
//         setState(() {
//           final errorBody = json.decode(response.body);
//           _errorMessage = errorBody['error']['message'] ?? 'Failed to load weather data: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching weather: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Weather Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _cityController,
//               decoration: InputDecoration(
//                 labelText: 'Enter City Name (e.g., Mumbai, Delhi, Bengaluru)',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     _fetchWeather(_cityController.text);
//                   },
//                 ),
//               ),
//               onSubmitted: (value) {
//                 _fetchWeather(value);
//               },
//             ),
//             const SizedBox(height: 20),
//             if (_isLoading)
//               SpinKitThreeBounce(
//                 color: Theme.of(context).primaryColor,
//                 size: 30.0,
//               )
//             else if (_errorMessage != null)
//               Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//                 textAlign: TextAlign.center,
//               )
//             else if (_weatherData != null)
//               Expanded(child: _buildWeatherDisplay(context))
//             else
//               const Expanded(
//                 child: Center(
//                   child: Text(
//                     'Enter a city to see current and 3-day forecast details.',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeatherDisplay(BuildContext context) {
//     final location = _weatherData!['location'];
//     final current = _weatherData!['current'];
//     final forecast = _weatherData!['forecast']['forecastday'];

//     return ListView(
//       children: [
//         Card(
//           elevation: 6,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//           margin: const EdgeInsets.only(bottom: 20),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   '${location['name']}, ${location['region']}',
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 Text(
//                   'Last Updated: ${DateFormat('h:mm a, d MMM').format(DateTime.parse(current['last_updated']))}',
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network('http:${current['condition']['icon']}', scale: 0.8),
//                     const SizedBox(width: 10),
//                     Text(
//                       '${current['temp_c'].toStringAsFixed(0)}°C',
//                       style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   current['condition']['text'],
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade700),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Divider(color: Colors.grey.shade300),
//                 const SizedBox(height: 10),
//                 _buildCurrentWeatherDetails(context, current),
//               ],
//             ),
//           ),
//         ),
//         _buildForecastSection(context, forecast),
//       ],
//     );
//   }

//   Widget _buildCurrentWeatherDetails(BuildContext context, Map<String, dynamic> current) {
//     return Column(
//       children: [
//         _buildInfoRow(context, Icons.thermostat_outlined, 'Feels Like', '${current['feelslike_c'].toStringAsFixed(0)}°C'),
//         _buildInfoRow(context, Icons.compress, 'Pressure', '${current['pressure_mb']} hPa'),
//         _buildInfoRow(context, Icons.water_drop_outlined, 'Humidity', '${current['humidity']}%'),
//         _buildInfoRow(context, Icons.air, 'Wind Speed', '${current['wind_kph']} km/h'),
//         _buildInfoRow(context, Icons.navigation, 'Wind Direction', current['wind_dir']),
//         _buildInfoRow(context, Icons.visibility_outlined, 'Visibility', '${current['vis_km']} km'),
//         _buildInfoRow(context, Icons.cloud, 'Cloud Cover', '${current['cloud']}%'),
//         _buildInfoRow(context, Icons.waves, 'UV Index', current['uv'].toString()),
//       ],
//     );
//   }

//   Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.green.shade700, size: 24),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Text(
//               label,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForecastSection(BuildContext context, List<dynamic> forecast) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10.0),
//           child: Text(
//             '3-Day Forecast',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade800),
//           ),
//         ),
//         ...forecast.map((day) {
//           final date = DateTime.parse(day['date']);
//           final dayData = day['day'];
//           return Card(
//             elevation: 4,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           DateFormat('EEE, MMM d').format(date),
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           dayData['condition']['text'],
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Image.network('http:${dayData['condition']['icon']}', scale: 1.0),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '${dayData['maxtemp_c'].toStringAsFixed(0)}°C / ${dayData['mintemp_c'].toStringAsFixed(0)}°C',
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.red.shade700),
//                         ),
//                         Text(
//                           'Avg: ${dayData['avgtemp_c'].toStringAsFixed(0)}°C',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                         Text(
//                           'Chance of rain: ${dayData['daily_chance_of_rain']}%',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }
