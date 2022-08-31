import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _notes = [];
  final _controller = TextEditingController();
  SharedPreferences? _preferences;

  void _getData() async {
    _preferences = await SharedPreferences.getInstance();
    _notes = _preferences!.getStringList("notes") ?? [];
    setState(() {});
  }

  void _setData(String note) {
    _notes.add(note);
    _preferences!.setStringList("notes", _notes);
    setState(() {});
  }

  void _removeData(int index) {
    _notes.removeAt(index);
    _preferences?.setStringList("notes", _notes);
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade900,
          centerTitle: true,
          title: const Text('Note App shared'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _removeData(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        Spacer(),
                        Text(_notes[index]),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: _notes.length,
              ),
            ),
            SizedBox(
              height: 190,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'پیام خود را وارد کنید',
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: MaterialButton(
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            _setData(_controller.text.trim());
                            setState(() {
                              _controller.text = '';
                            });
                          }
                        },
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Text('ذخیره'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
