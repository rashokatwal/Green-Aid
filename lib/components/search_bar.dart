import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(image: AssetImage('assets/images/logo_without_label_green.png'), width: 45),
            SizedBox(
              width: 230,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                  hintText: "Search",
                  suffixIcon: IconButton(
                    onPressed: () {  },
                    icon: const Icon(Icons.search),
                    iconSize: 25,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(233, 233, 233, 1),
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}