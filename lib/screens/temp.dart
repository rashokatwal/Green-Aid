import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ super.key, required this.firstName, required this.lastName, required this.email });
  final String? firstName;
  final String? lastName;
  final String? email;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Profile",
            //   style: TextStyle(
            //     fontSize: 17,
            //     fontWeight: FontWeight.w500
            //   ),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Column(
                  children: [
                    Image(image: AssetImage('assets/images/default_profile.png'), width: 100, height: 100),
                    SizedBox(height: 30,),
                    Text(
                      "${widget.firstName} ${widget.lastName}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        "${widget.email}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  ],
                )
              ),
            ),
            
            const Text(
              "Your Scans",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),
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
      ),
    );
  }
}