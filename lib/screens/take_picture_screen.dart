import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:green_aid/services/database.dart';
import 'package:uuid/uuid.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.uid
  });

  final CameraDescription camera;
  final String? uid;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.ultraHigh,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white, width: 5.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        // print(widget.uid);
                        await _initializeControllerFuture;

                        final image = await _controller.takePicture();

                        if (!context.mounted) return;

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              imagePath: image.path,
                              uid: widget.uid
                            ),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text(""),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String? uid;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.uid
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Future<Map<String, dynamic>> response;
  bool isSaved = false;
  final scanId = const Uuid().v4();
  bool buttonsDisabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState, but run async code in a separate method
    _fetchDiseaseData();
  }

  Future<Map<String, dynamic>> identifyDisease(String imagepath) async {
    const apiKey = "AIzaSyAW04aRSdlNJQSKtDrmqfcjB3c4derCTeY";

    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 100000,
        responseMimeType: 'application/json',
      ),
    );

    // Load the image into bytes
    final imageBytes = await File(imagepath).readAsBytes();

    // Generate a prompt for the images
    final prompt = TextPart(
        'Given this image of suspected plant disease, identify the disease if any and provide the name of the disease, details, symptoms, and preventive measures in JSON format. Please keep symptoms and preventive measures in arrays. The JSON format should be as: \n {"disease":"","details":"","symptoms":"","preventive_measures":""}');

    // Convert the bytes into a DataPart
    final imagePart = DataPart('image/jpeg', imageBytes);

    // Fetch response using the pro model
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    // Parse and return the JSON response
    print(response.text);
    enableButtons();
    return json.decode(response.text!);
  }

  void _fetchDiseaseData() {
    setState(() {
      response = identifyDisease(widget.imagePath);
    });
  }

  void enableButtons() {
    setState(() {
      buttonsDisabled = false;
    });
  }

  String getDate() {
    DateTime now = new DateTime.now();
    var date = "${now.day}/${now.month}/${now.year}";
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero
            ),
            // icon: ,
            onPressed: buttonsDisabled ? null : () async{
              if(!isSaved) {
                try {
                  final data = await response; // Ensure the response is fetched
                  
                  await DatabaseService(uid: widget.uid, sid: scanId).saveScan(
                    data["disease"] ?? "Unknown Disease",
                    getDate(),
                    data["details"] ?? "No Details Available",
                    List<String>.from(data["symptoms"] ?? []),
                    List<String>.from(data["preventive_measures"] ?? []),
                    widget.imagePath
                    // 'description': 
                    // 'symptoms': 
                    // 'preventiveMeasures': 
                    // 'scannedDate': ,
                    // 'userId':,
                    // 'imagePath': ,
                  );
                  setState(() {
                    isSaved = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Scan saved successfully!")),
                  );
                } catch (e) {
                  print("Error saving scan: $e");
                }
              } else {
                // Unsave scan from database (you may need a scan ID)
                try {
                  // Assume you fetch scanId somehow
                  // final scanId = "unique-scan-id"; // Replace with actual logic
                  await DatabaseService(uid: widget.uid, sid: scanId).removeScan();
                  setState(() {
                    isSaved = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Scan removed successfully!")),
                  );
                } catch (e) {
                  print("Error removing scan: $e");
                }
              }
                // if(!isSaved) {
                //   // await DatabaseService(uid: widget.uid).updateScanData(response., user.lastName, user.email);
                //   final data = await response;
                // }
                // setState(() {
                //   isSaved = !isSaved;
                // });
            }, 
            child: isSaved ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_outline)
          ),
          TextButton(onPressed: buttonsDisabled ? null : () {}, child: const Icon(Icons.share),style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero
            ),)
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              // print(response);
              if (snapshot.connectionState == ConnectionState.done) {
                // enableButtons();
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(widget.imagePath),
                          width: MediaQuery.sizeOf(context).width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data["disease"] ?? "Unknown Disease",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(data["details"] ?? "No Details Available"),
                      const SizedBox(height: 10),
                      const Text(
                        "Symptoms",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (data["symptoms"] != null && data["symptoms"] is List && data["symptoms"].isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true, // Important to prevent infinite height
                          physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within the ListView
                          itemCount: data["symptoms"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '- ${data["symptoms"][index]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Text("No symptoms listed"),
                      const SizedBox(height: 10),
                      const Text(
                        "Preventive Measures",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (data["preventive_measures"] != null && data["preventive_measures"] is List && data["preventive_measures"].isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true, // Important to prevent infinite height
                          physics: const NeverScrollableScrollPhysics(), // Prevent scrolling within the ListView
                          itemCount: data["preventive_measures"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '- ${data["preventive_measures"][index]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Text("No preventive measures listed"),
                    ],
                  );
                } else {
                  return const Center(child: Text("Error fetching data"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
