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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Scans",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
              ),
              TextButton(
                onPressed: () {}, 
                child: Row(
                  children: [
                    Text("See more",  style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),),
                    Icon(Icons.chevron_right)
                  ],
                )
              )
            ],
          ),
          Container(
            height: 215,
            child: data != null ? (data!.isNotEmpty ? ListView.builder(
              itemCount: data?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.fromLTRB(0, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          height: 100,
                          width: 100,
                          image: AssetImage('assets/images/demo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${data?[index]['diseaseName']}",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "${data?[index]['scannedDate']}",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                );
              },
            ) : Center(child: const Text("No Scans Saved"))) : const Center(child: CircularProgressIndicator())
            // child: ListView.builder(
            //   itemCount: data!.length,
            //   scrollDirection: Axis.horizontal,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       height: 100,
            //       width: 130,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).colorScheme.secondary,
            //         borderRadius: BorderRadius.circular(20)
            //       ),
            //       padding: EdgeInsets.all(15),
            //       margin: EdgeInsets.fromLTRB(0, 20, 10, 20),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           ClipRRect(
            //             borderRadius: BorderRadius.circular(10),
            //             child: Image(
            //               height: 100,
            //               width: 100,
            //               image: AssetImage('assets/images/demo.jpg'),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Text(
            //             "Horse Chestnut Leaf Blotch",
            //             overflow: TextOverflow.ellipsis,
            //             style: Theme.of(context).textTheme.titleMedium,
            //           ),
            //           Text(
            //             "11/09/2024",
            //             style: TextStyle(
            //               fontSize: 12
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }
            // ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shared by Friends",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
              ),
              TextButton(
                onPressed: () {}, 
                child: Row(
                  children: [
                    Text("See more",  style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),),
                    Icon(Icons.chevron_right)
                  ],
                )
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  onTap: () {},
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(image: AssetImage('assets/images/demo.jpg'),  width: 60, height: 60, fit: BoxFit.cover,),
                  ),
                  title: Text("Horse Chestnut Leaf Blotch", style: TextStyle(fontSize: 17),),
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
                  subtitle: Text("Rashok Katwal\n11/09/2024"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}