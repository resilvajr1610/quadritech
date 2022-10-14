import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadritech/views/picture_finish_screen.dart';
import 'package:video_compress/video_compress.dart';
import '../models/video_compress_api.dart';
import '../utils/colors.dart';
import '../widget/buttom_custom.dart';

class CountdownScreen extends StatefulWidget {
  final timer;
  final idLesson;
  const CountdownScreen({required this.timer,required this.idLesson});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

enum WidgetState{NONE,LOADING,LOADED,ERROR}
List<CameraDescription> _camerasPhoto = [];
List<CameraDescription> _camerasVideo = [];
CameraController? cameraPhotoController;
CameraController? cameraVideoController;

class _CountdownScreenState extends State<CountdownScreen> {

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 1000;
  Duration duration = Duration();
  Timer? timer;
  bool click = true;

  WidgetState widgetState = WidgetState.NONE;
  File? picture;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  MediaInfo? compressedVideoInfo;
  File? fileVideo;
  String? _urlVideo;
  bool compressVideo=false;
  double videoTimer = 0.0;
  UploadTask? task;

  @override
  void initState() {
    super.initState();
    print(widget.timer);
    final splitted = widget.timer.split(' ');
    int conv = int.parse(splitted[0]);
    duration = Duration(minutes: conv);
    inializeCamera();
    // duration = Duration(minutes: 1);
  }
  @override
  void dispose() {
    super.dispose();
    cameraVideoController!.dispose();
    cameraPhotoController!.dispose();
  }

  takePhoto()async{
    XFile xfile = await cameraPhotoController!.takePicture();
    if(xfile!=null){
      _savePhoto('lessonPhotos',xfile);
    }
  }

  void addTime(){
    final addSeconds=1;
    if(duration.inSeconds > 0){
      setState((){
        click = false;
        final seconds = duration.inSeconds - addSeconds;
        duration = Duration(seconds: seconds);
        if(seconds==2500 || seconds==2000 || seconds == 1900 || seconds == 1600 || seconds == 900){
          takePhoto();
        }
      });
    }else{
     setState(() {
       click = true;
     });
    }
  }

  void startTimer()async{
    await cameraVideoController!.startVideoRecording().then((value) => print('video cmoecouuuuuu'));
    timer = Timer.periodic(Duration(seconds: 1), (_) =>addTime());
  }

  Future inializeCamera()async{
    widgetState = WidgetState.LOADING;
    if(mounted)setState(() {});
    _camerasPhoto = await availableCameras();
    _camerasVideo = await availableCameras();
    cameraPhotoController = CameraController(_camerasPhoto[0], ResolutionPreset.low);
    cameraVideoController = CameraController(_camerasVideo[0], ResolutionPreset.low);
    await cameraPhotoController!.initialize();
    await cameraVideoController!.initialize();

    if(cameraPhotoController!.value.hasError){
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

  stopTimer()async{
    setState((){
      compressVideo = true;
      duration = Duration(seconds: 0);
    });
    XFile videopath = await cameraVideoController!.stopVideoRecording();
    if(videopath!=null){
      _saveVideo(videopath);
    }
  }

  Future _saveVideo(XFile file) async {
      try {
        var fileAux = File(file.path);
        setState(()=> fileVideo = fileAux);
        print('aqui -1');
        compressVideos();
      } on PlatformException catch (e) {
        print('Error : $e');
      }
  }

  Future compressVideos()async{
    final info = await VideoCompressApi.compressVideo(fileVideo!).then((value){
      print('aqui 0');
      setState(()=>compressedVideoInfo = value);
    }).then((value) => _uploadVideo());
  }

  Future _uploadVideo() async {
    print('aqui 1');
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("aulas").child('video' +"_" +DateTime.now().toString() +".mp4");
    await arquivo.putFile(fileVideo!).whenComplete(()async{
      await arquivo.getDownloadURL().then((value){
        print(value);
        print('aqui 3');
        db.collection("lesson")
            .doc(widget.idLesson)
            .update({
          'video': value.toString(),
        }).then((value) {
          setState(() {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,)));
          });
        });
      });
    });
  }

  saveFirebase(UploadTask task)async{
    print('aqui 2');
      if(task!=null){


      }else{
        print('task é nullo');
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
          print('urlImage');
          print(urlImage);
        });
        _urlImageFirestore(urlImage, namePhoto);
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto) {

    Map<String, dynamic> dateUpdate = {
      'photosLesson': FieldValue.arrayUnion([url]),
    };

    db.collection("lesson")
      .doc(widget.idLesson)
      .update(dateUpdate)
      .then((value) {
        setState(() {
          print('salvo');
        });
    });
  }

  @override
  Widget build(BuildContext context) {

    final value = videoTimer==null? videoTimer : videoTimer/100;

    Widget buildTime(){
      String twoDigits(int n)=>n.toString().padLeft(2,'0');
      final hours = twoDigits(duration.inHours.remainder(23));
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      return Text('$hours : $minutes : $seconds',style: TextStyle(fontSize: 50),);
    }

    return Scaffold(
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: Image.asset("assets/logo_main.png", height: 30),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            compressVideo?Container():SizedBox(height: 50,),
            ButtonCustom(
              onPressed:(){},
              heightCustom: 0.1,
              size: 15.0,
              colorBorder: PaletteColor.primaryColor,
              colorButton: PaletteColor.primaryColor,
              colorText: PaletteColor.white,
              text: 'Processo de Captura e\nRegistro concluídos',
              widthCustom: 0.8,
            ),
            Spacer(),
            compressVideo?Container():buildTime(),
            Spacer(),
            click?Container(
              child:  compressVideo?Container():ButtonCustom(
                onPressed:()=>duration.inSeconds > 0
                    ?startTimer()
                    :stopTimer(),
                heightCustom: 0.1,
                size: 15.0,
                colorBorder: duration.inSeconds > 0?Colors.green.shade400:Colors.red,
                colorButton:  duration.inSeconds > 0?Colors.green.shade400:Colors.red,
                colorText: PaletteColor.white,
                text: duration.inSeconds > 0?'Pressione para\nIniciar Aula':'Pressione para\nAula Concluída',
                widthCustom: 0.8,
              ),
            )
            :Container(
              child:  compressVideo?Container():ButtonCustom(
                onPressed:()=>stopTimer(),
                heightCustom: 0.1,
                size: 15.0,
                colorBorder: Colors.orange,
                colorButton:  Colors.orange,
                colorText: PaletteColor.white,
                text: 'Aula em andamento',
                widthCustom: 0.8,
              ),
            ),
            compressVideo?Container():SizedBox(height: 50,),
            compressVideo==false?Container():Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Aula sendo gravada.\nAguarde finalizar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20,),
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  // ElevatedButton(onPressed: (){
                  //   VideoCompress.cancelCompression();
                  //   Navigator.push(context, MaterialPageRoute(builder: (_) => PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,)));
                  // }, child: Text('Cancelar'))
                ],
              ),
            ),
            Image.asset("assets/pratico.png", height: 60)
          ],
        ),
      ),
    );
  }
}
