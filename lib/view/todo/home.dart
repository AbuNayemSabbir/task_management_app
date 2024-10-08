import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/app_utills.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 24.0,
              // backgroundImage: NetworkImage(
              //   'https://example.com/profile.jpg', // Use actual image URL or Asset
              // ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Task Stats
                Text(
                  'Sabbir Ahmed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '5 incomplete, 5 completed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Search Icon
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              // Add search functionality
            },
          ),
        ],
      ),
      body: Container(
        // Task List can go here, currently just an empty container
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.task);
        },
        backgroundColor: AppUTills.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
