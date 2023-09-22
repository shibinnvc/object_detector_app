import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import '../home_page.dart';
import '/widget/gallery_cam_object_painter.dart';

class GalleryAndCamera extends StatefulWidget {
  const GalleryAndCamera({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _GalleryAndCameraState createState() => _GalleryAndCameraState();
}

class _GalleryAndCameraState extends State<GalleryAndCamera> {
  late ImagePicker _imagePicker;
  File? _imageFile;
  // ignore: prefer_typing_uninitialized_variables
  var image;
  dynamic objectDetector;
  @override
  void initState() {
    _imagePicker = ImagePicker();
    createObjectDetector();
    super.initState();
  }

  Future<void> pickImage({bool cameraSource = true}) async {
    XFile? pickedFile = await _imagePicker.pickImage(
        source: cameraSource ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      performObjectDetection();
    }
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<void> createObjectDetector() async {
    final modelPath = await getModelPath('assets/kitchen.tflite');
    // here study the model by using object detector
    final options = LocalObjectDetectorOptions(
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: true,
        mode: DetectionMode.single);
    objectDetector = ObjectDetector(options: options);
  }

  late List<DetectedObject> objects;
  void performObjectDetection() async {
    InputImage inputImage = InputImage.fromFile(_imageFile!);
    objects = await objectDetector.processImage(inputImage);
    drawRectanglesAroundObjects();
  }

  Future<void> drawRectanglesAroundObjects() async {
    final ByteData data = await _imageFile!
        .readAsBytes()
        .then((byteData) => ByteData.sublistView(byteData));
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.sublistView(data), (ui.Image img) {
      completer.complete(img);
    });
    image = await completer.future;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 42, 16, 137),
          title: const Text("Object Detector"),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: gradient,
          ),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 350,
                        height: 350,
                        margin: const EdgeInsets.only(
                          top: 45,
                        ),
                        child: image != null
                            ? ImageLabeledSection(
                                image: image, objects: objects)
                            : const EmptySection(),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 42, 16, 137)),
                      icon: const Icon(Icons.image),
                      label: const Text('Camera'),
                      onPressed: pickImage,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 42, 16, 137)),
                        icon: const Icon(Icons.camera),
                        label: const Text('Gallery'),
                        onPressed: () => pickImage(cameraSource: false))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class ImageLabeledSection extends StatelessWidget {
  const ImageLabeledSection({
    super.key,
    required this.image,
    required this.objects,
  });

  final image;
  final List<DetectedObject> objects;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: SizedBox(
          width: image.width.toDouble(),
          height: image.height.toDouble(),
          child: CustomPaint(
            painter: GalleryCameraObjectPainter(
                objectList: objects, imageFile: image),
          ),
        ),
      ),
    );
  }
}

class EmptySection extends StatelessWidget {
  const EmptySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 42, 16, 137),
      width: double.infinity,
      height: 400,
      child: const Icon(
        Icons.camera_alt,
        color: Colors.white,
        size: 53,
      ),
    );
  }
}
