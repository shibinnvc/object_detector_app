import 'package:flutter/material.dart';
import 'screens/live_camera.dart';
import 'screens/gallery_camera.dart';

const gradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 48, 21, 135),
    Color.fromARGB(255, 108, 83, 190),
    Color.fromARGB(255, 138, 119, 202)
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 42, 16, 137),
          title: const Text("Object Detector App"),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: gradient,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LiveCameraButton(),
                SizedBox(height: 10),
                GalleryCameraButton()
              ],
            ),
          ),
        ));
  }
}

class GalleryCameraButton extends StatelessWidget {
  const GalleryCameraButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.camera),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 42, 16, 137)),
        label: const Text('Gallery/Camera'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const GalleryAndCamera()));
        },
      ),
    );
  }
}

class LiveCameraButton extends StatelessWidget {
  const LiveCameraButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 42, 16, 137)),
        icon: const Icon(Icons.live_tv_outlined),
        label: const Text('Live Camera'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LiveCamera()));
        },
      ),
    );
  }
}
