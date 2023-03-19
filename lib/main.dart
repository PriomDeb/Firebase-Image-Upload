import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'storage.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStorage storage = FirebaseStorage();
  bool _uploading = false;
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -74,
            left: -200,
            child: Container(
              width: 600,
              height: 400,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 101, 186, 255),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_circle,
                size: 480,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -30,
            child: Container(
              width: 200,
              height: 300,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 101, 186, 255),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wb_cloudy_outlined,
                size: 100,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 510,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 139, 218, 255),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload,
                  size: 100,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg', 'jpeg'],
                      );

                      if (results == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No file selected"),
                          ),
                        );
                        return null;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Image is uploading"),
                          ),
                        );
                      }

                      setState(() {
                        _uploading = true;
                        _uploaded = false;
                      });

                      final path = results.files.single.path!;
                      final fileName = results.files.single.name;

                      storage
                          .uploadFile(path, fileName)
                          .then((value) => print("Done"))
                          .whenComplete(() {
                        setState(() {
                          _uploading = false;
                          _uploaded = true;
                        });
                      });

                      print(path);
                      print(fileName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 66, 161, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Upload Images',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // if (_uploading) const LinearProgressIndicator(),
                  if (_uploading)
                    const CircularProgressIndicator()
                  else if (_uploaded)
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  const Text(
                    'Upload Images of Birth Info',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -300,
            right: -200,
            child: Container(
              width: 750,
              height: 500,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 101, 186, 255),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseStorage storage = FirebaseStorage();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Birth Registration Image"),
//       ),
//       body: Column(children: [
//         ElevatedButton(
//             onPressed: () async {
//               final results = await FilePicker.platform.pickFiles(
//                 allowMultiple: false,
//                 type: FileType.custom,
//                 allowedExtensions: ['png', 'jpg', 'jpeg'],
//               );

//               if (results == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("No file selected"),
//                   ),
//                 );
//                 return null;
//               }

//               final path = results.files.single.path!;
//               final fileName = results.files.single.name;

//               storage.uploadFile(path, fileName).then((value) => print("Done"));

//               print(path);
//               print(fileName);
//             },
//             child: Text("Upload Image")),
//       ]),
//     );
//   }
// }
