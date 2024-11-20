import 'package:flutter/material.dart';
import 'package:green_aid/services/database.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, required this.uid});
  final String? uid;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<dynamic>? data;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    DatabaseService(uid: widget.uid).getUserData().then((snapshot) {
      if(snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>?;
      }
      // print(userData?['savedScans']);
      fetchSavedScans();
    });
    super.initState();
  }

  void fetchSavedScans() async {
    try {
      final snapshot = await DatabaseService(uid: widget.uid).getSavedScans(userData?['savedScans']);
      // print(snapshot.length);
      setState(() {
        if(snapshot.isNotEmpty) {
          data = snapshot;
        }
        else {
          data = [];
        }
      });
    } catch (e) {
      print('Error fetching saved scans: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Text(
              "Saved Scans",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: data != null ? (data!.isNotEmpty ? ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  onTap: () {},
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(image: AssetImage('assets/images/demo.jpg'),  width: 60, height: 60, fit: BoxFit.cover,),
                  ),
                  title: Text(data?[index]['diseaseName'], style: TextStyle(fontSize: 17),),
                  trailing: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: IconButton(
                      onPressed: () {  },
                      icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary,),
                    ),
                  ),
                  subtitle: Text(data?[index]['scannedDate']),
                );
              },
            ) : Center(child: const Text("No Scans Saved"))) : const Center(child: CircularProgressIndicator())
          ),
        ],
      ),
    );
  }
}