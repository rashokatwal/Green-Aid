import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

List dummyData = [
  {
    "profile_picture": "default_profile.png",
    "first_name": "Rashok",
    "last_name": "Katwal",
    "post_count": "2"
  },
  {
    "profile_picture": "default_profile.png",
    "first_name": "Ashim",
    "last_name": "Raja",
    "post_count": "10"
  },
  {
    "profile_picture": "default_profile.png",
    "first_name": "Ghanshyam",
    "last_name": "Yadav",
    "post_count": "13"
  },
];

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Padding(
    //         padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
    //         child: Text(
    //           "Friends",
    //           style: TextStyle(
    //             fontSize: 17,
    //             fontWeight: FontWeight.w500
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 10),
    //       Expanded(
    //         child: ListView.builder(
    //           itemCount: dummyData.length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               contentPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
    //               onTap: () {},
    //               leading: Image(image: AssetImage('assets/images/${dummyData[index]["profile_picture"]}'), width: 50, height: 50),
    //               title: Text("${dummyData[index]["first_name"]} ${dummyData[index]["last_name"]}", style: TextStyle(fontSize: 18),),
    //               trailing: Container(
    //                 height: 40,
    //                 width: 40,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(50)
    //                 ),
    //                 child: IconButton(
    //                   onPressed: () {  },
    //                   icon: Icon(Icons.chevron_right, color: Colors.green,),
    //                 ),
    //               ),
    //               subtitle: Text("Shared ${dummyData[index]["post_count"]} posts"),
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(child: Text("Friends", style: TextStyle(fontWeight: FontWeight.w500)),),
              Tab(child: Text("Requests", style: TextStyle(fontWeight: FontWeight.w500))),
            ],
          ),
          body: TabBarView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Text(
                      "All Friends",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          onTap: () {},
                          leading: Image(image: AssetImage('assets/images/${dummyData[index]["profile_picture"]}'), width: 50, height: 50),
                          title: Text("${dummyData[index]["first_name"]} ${dummyData[index]["last_name"]}", style: TextStyle(fontSize: 18),),
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
                          subtitle: Text("Shared ${dummyData[index]["post_count"]} posts"),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Text(
                      "Friend Requests",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          onTap: () {},
                          leading: Image(image: AssetImage('assets/images/${dummyData[index]["profile_picture"]}'), width: 50, height: 50),
                          title: Text("${dummyData[index]["first_name"]} ${dummyData[index]["last_name"]}", style: TextStyle(fontSize: 18),),
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
                          subtitle: Text("Shared ${dummyData[index]["post_count"]} posts"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}