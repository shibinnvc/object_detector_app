import 'package:flutter/material.dart';
import '/modules/live_camera.dart';
import 'modules/gallery_camera.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 29, 54, 42),
          title: const Text("Object Detector App"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.live_tv_outlined),
                  label: const Text('Live Camera'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LiveCamera()));
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera),
                  label: const Text('Gallery/Camera'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GalleryAndCamera()));
                  },
                ),
              )
            ],
          ),
        ));
  }
}
