import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quadritech/Utils/export.dart';
import 'package:quadritech/views/picture_finish_screen.dart';
import 'package:video_compress/video_compress.dart';
import '../models/video_compress_api.dart';
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
var controllerObs = TextEditingController();

class _CountdownScreenState extends State<CountdownScreen> {

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 1000;
  Duration duration = Duration();
  Timer? timer;
  bool click = true;
  int totalSecondsFinal = 0;
  int totalSecondsStart = 0;

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
  int randomNumber1 = 0;
  int randomNumber2 = 0;
  int randomNumber3 = 0;
  int randomNumber4 = 0;
  int randomNumber5 = 0;
  Uint8List? photoBytes;

  @override
  void initState() {
    super.initState();
    print(widget.timer);
    final splitted = widget.timer.split(' ');
    int conv = int.parse(splitted[0]);
    duration = Duration(minutes: conv);
    // duration = Duration(minutes: 2);
    setState(() {
      totalSecondsStart = duration.inSeconds;
    });
    inializeCamera();
  }
  @override
  void dispose() {
    super.dispose();
    cameraVideoController!.dispose();
  }

  stopTimer()async{
    XFile videopath = await cameraVideoController!.stopVideoRecording();
    if(videopath!=null){
      _saveVideo(videopath);
    }else{
      stopTimer();
    }
  }

  void addTime(){
    final addSeconds=1;
    if(duration.inSeconds > 0){
      setState((){
        click = false;
        final seconds = duration.inSeconds - addSeconds;
        duration = Duration(seconds: seconds);
      });
    }else{
     setState(() {
       click = true;
     });
    }
  }

  Future createVideo()async{
    XFile videopath = await cameraVideoController!.stopVideoRecording();
    if(videopath!=null){
      final file = File(videopath.path);
      print('file do video');
      print(file);
      _saveVideo(videopath);
    }
  }
  createRandon(){
    Random random = new Random();

    setState(() {
      int time = totalSecondsStart - totalSecondsFinal;

      randomNumber1 = random.nextInt(time);
      randomNumber2 = random.nextInt(time);
      randomNumber3 = random.nextInt(time);
      randomNumber4 = random.nextInt(time);
      randomNumber5 = random.nextInt(time);
    });
    generateSprint(1);
  }

  generateSprint(int indexPhoto)async{
      photoBytes = null;
      switch (indexPhoto){
        case 1:
          await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber1).then((value){
            setState(()=>photoBytes = value);
          });
          break;
        case 2:
          await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber2).then((value){
            setState(()=>photoBytes = value);
          });
          break;
        case 3:
          await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber3).then((value){
            setState(()=>photoBytes = value);
          });
          break;
        case 4:
          await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber4).then((value){
            setState(()=>photoBytes = value);
          });
          break;
        case 5:
          await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber5).then((value){
            setState(()=>photoBytes = value);
          });
          break;
      }
      if(photoBytes!=null){
        _uploadImage(indexPhoto);
      }
  }

  Future _uploadImage(int index) async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("aulas").child('lessonPhotos' +DateTime.now().toString() +".jpg");
    var photo = XFile.fromData(photoBytes!);
    Uint8List arquivoSelecionado = await photo.readAsBytes();

    await arquivo.putData(arquivoSelecionado).whenComplete(()async{
      await arquivo.getDownloadURL().then((value){
        db.collection("lesson")
            .doc(widget.idLesson)
            .update({
          'photosLesson': FieldValue.arrayUnion([value.toString()]),
        }).then((_) {
          setState(() {
            print('salvo: $index');
            if(index==5){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,)));
            }else{
              generateSprint(index+1);
            }
          });
        });
      });
    });
  }

  void startTimer()async{
    await cameraVideoController!.startVideoRecording().whenComplete(() => timer = Timer.periodic(Duration(seconds: 1), (_) =>addTime()));
  }

  Future inializeCamera()async{
    widgetState = WidgetState.LOADING;
    if(mounted)setState(() {});
    // _camerasPhoto = await availableCameras();
    _camerasVideo = await availableCameras();
    // cameraPhotoController = CameraController(_camerasPhoto[0], ResolutionPreset.low);
    cameraVideoController = CameraController(_camerasVideo[0], ResolutionPreset.low);
    // await cameraPhotoController!.initialize();
    await cameraVideoController!.initialize();

    if(cameraVideoController!.value.hasError){
      widgetState = WidgetState.ERROR;
      if(mounted)setState(() {});
    }else{
      widgetState = WidgetState.LOADED;
      if(mounted)setState(() {});
    }
  }

  Future _saveVideo(XFile file) async {

    setState((){
      compressVideo = true;
      totalSecondsFinal = duration.inSeconds;
      if(totalSecondsFinal!=0){
        duration = Duration(seconds: 0);
      }
    });

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
          'videos': value.toString(),
          'obs':controllerObs.text.isNotEmpty?controllerObs.text:''
        }).then((value) async{
          createRandon();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final value = videoTimer==null? videoTimer : videoTimer/100;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
      body: ListView(
        children: [
          Container(
            width: width,
            height: height*0.85,
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
                InputText(controller: controllerObs, hint: 'Observações',label: 'Observações', fonts: 12.0,width:width* 0.8),
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
                        'Aula sendo registrada.\nAguarde finalizar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5,),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
                Image.asset("assets/pratico.png", height: 60)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
