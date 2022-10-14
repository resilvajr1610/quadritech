import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

enum WidgetState{NONE,LOADING,LOADED,ERROR}
List<CameraDescription> _cameras = [];
CameraController? cameraController;

class _TesteState extends State<Teste> {

  WidgetState widgetState = WidgetState.NONE;
  File? picture;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

 Future inializeCamera()async{
    widgetState = WidgetState.LOADING;
    if(mounted)setState(() {});
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await cameraController!.initialize();

    if(cameraController!.value.hasError){
      widgetState = WidgetState.ERROR;
      if(mounted)setState(() {});
    }else{
      widgetState = WidgetState.LOADED;
      if(mounted)setState(() {});
    }
  }

  Future _savePhoto(String namePhoto,XFile file) async {
    if (namePhoto != null && namePhoto != "") {
      try {
        final imageTemporary = File(file.path);
        setState(() {
          this.picture = imageTemporary;
          _uploadImage(namePhoto);
        });
      } on PlatformException catch (e) {
        print('Error : $e');
      }
    }
  }

  Future _uploadImage(String namePhoto) async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("aulas").child(namePhoto +DateTime.now().toString() +".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 3), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          String _urlPhoto = urlImage;
          print('urlImage');
          print(urlImage);
        });
        _urlImageFirestore(urlImage, namePhoto);
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto) {

    Map<String, dynamic> dateUpdate = {
      namePhoto: url,
      'cpfStudent' : 'teste',
      'cpfTeacher' : 'teste',
      'time'       : '00',
      'idLesson'   : '00',
      'startTime'  : DateTime.now(),
    };

      db
          .collection("lesson")
          .doc('teste')
          .update(dateUpdate)
          .then((value) {
        setState(() {
            print('fire');
        });
      });

  }

  @override
  void initState() {
    super.initState();
    inializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    switch(widgetState){
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(context,Center(child: CircularProgressIndicator()));
        break;
      case WidgetState.LOADED:
        return _buildScaffold(context, Container(width:100,height:100,child: CameraPreview(cameraController!)));
      case WidgetState.ERROR:
      return _buildScaffold(context,Center(child: Text('Câmera não iniciou')));
    }
  }
  Widget _buildScaffold(BuildContext context,Widget body){
   return Scaffold(
     body: body,
     floatingActionButton: FloatingActionButton(
       onPressed: ()async{
        XFile xfile = await cameraController!.takePicture();
        print(xfile.path);
          if(xfile!=null){
            _savePhoto('teste',xfile);
          }
       },
       child: Icon(Icons.camera),
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
   );
  }
}
