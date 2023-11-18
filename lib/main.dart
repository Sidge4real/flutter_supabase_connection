import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 //key + anonKey from supabase
  await Supabase.initialize(
    url: '',
    anonKey: "",
  );

  runApp(MyApp());
}

// It's handy to then extract the Supabase client in a variable for later uses
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<String>> teams;

  @override
  void initState() {
    super.initState();
    teams = fetchTeams();
  }

// teams = table, name = column
  Future<List<String>> fetchTeams() async {
    final response = await supabase.from('teams').select('name').execute();

    final List<dynamic> data = response.data!;
    return data.map((e) => e['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supabase Demo'),
      ),
      body: Center(
        child: FutureBuilder(
          future: teams,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String> teamNames = snapshot.data as List<String>;

              return DropdownButton<String>(
                value: teamNames.first, // Set default value if needed
                onChanged: (String? newValue) {
                  // Handle dropdown value change
                  // You can use the selected value (newValue) as needed
                },
                items: teamNames.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}