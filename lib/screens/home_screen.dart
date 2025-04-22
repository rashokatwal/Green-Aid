import 'package:flutter/material.dart';
import 'package:green_aid/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.uid});
  final String? uid;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic>? data;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserAndScans();
  }

  void loadUserAndScans() async {
    try {
      final snapshot = await DatabaseService(uid: widget.uid).getUserData();
      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>?;
        await fetchSavedScans();
      }
    } catch (e) {
      print('Error loading user or scans: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSavedScans() async {
    try {
      final snapshot = await DatabaseService(uid: widget.uid).getSavedScans(userData?['savedScans']);
      setState(() {
        data = snapshot.isNotEmpty ? snapshot : [];
      });
    } catch (e) {
      print('Error fetching saved scans: $e');
      setState(() {
        data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Scans",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text("See more", style: TextStyle(color: Color.fromARGB(255, 90, 90, 90))),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),

          // --- Saved Scans Section ---
          SizedBox(
            height: 215,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (data == null || data!.isEmpty)
                    ? const Center(child: Text("No Scans Saved"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          final scan = data![index];
                          return Container(
                            height: 100,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/demo.jpg',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${scan['diseaseName'] ?? 'Unknown'}",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "${scan['scannedDate'] ?? ''}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),

          // --- Shared by Friends ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shared by Friends",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text("See more", style: TextStyle(color: Color.fromARGB(255, 90, 90, 90))),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),

          // --- Shared Scans List ---
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  onTap: () {},
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/demo.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: const Text("Horse Chestnut Leaf Blotch", style: TextStyle(fontSize: 17)),
                  subtitle: const Text("Rashok Katwal\n11/09/2024"),
                  trailing: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
