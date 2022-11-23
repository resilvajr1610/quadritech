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
import 'package:video_thumbnail/video_thumbnail.dart';
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
  bool showCamera = false;

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
  List randomNumber=[];
  Uint8List? photoBytes;
  int timeClass=0;

  @override
  void initState() {
    super.initState();
    final splitted = widget.timer.split(' ');
    timeClass = int.parse(splitted[0]);
    duration = Duration(minutes: timeClass);
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

  createRandon(){
    Random random = new Random();

    setState(() {
      int time = (totalSecondsStart - totalSecondsFinal)*1000;

      if(timeClass==100){
        for(var i=0;i<=10;i++){
          randomNumber.add(random.nextInt(time));
        }
      }else{
        for(var i=0;i<=5;i++){
          randomNumber.add(random.nextInt(time));
        }
      }
    });
    generateSprint(0);
  }

  generateSprint(int indexPhoto)async{
      photoBytes = null;

      // await VideoCompress.getByteThumbnail(fileVideo!.path,position: randomNumber[indexPhoto]).then((value){
      //   setState(()=>photoBytes = value);
      // });

      await VideoThumbnail.thumbnailFile(video: fileVideo!.path,timeMs: randomNumber[indexPhoto],quality: 50).then((path){
        setState(() {
          photoBytes = File(path!).readAsBytesSync();
        });
        if(photoBytes!=null){
          _uploadImage(indexPhoto);
        }
      });
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
            if(timeClass==100){
              if(index==9){
                controllerObs.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,)));
              }else{
                generateSprint(index+1);
              }
            }else{
              if(index==4){
                controllerObs.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,)));
              }else{
                generateSprint(index+1);
              }
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
    cameraVideoController = CameraController(_camerasVideo[1], ResolutionPreset.low);
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
        // compressVideos();
        _uploadVideo();
      } on PlatformException catch (e) {
      }
  }

  Future _uploadVideo() async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("aulas").child('video' +"_" +DateTime.now().toString() +".mp4");
    await arquivo.putFile(fileVideo!).whenComplete(()async{
      await arquivo.getDownloadURL().then((value){
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
            height: showCamera?height:height*0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !compressVideo,
                  child: Container(
                    height: showCamera?height*0.8:height*0.72,
                    child: Column(
                      children: [
                        ButtonCustom(
                          onPressed:()=>setState(()=>showCamera?showCamera=false:showCamera=true),
                          heightCustom: 0.05,
                          size: 15.0,
                          colorBorder: PaletteColor.primaryColor,
                          colorButton: PaletteColor.white,
                          colorText: PaletteColor.primaryColor,
                          text:  showCamera?'Ocultar câmera':'Mostrar câmera',
                          widthCustom: 0.6,
                        ),
                        showCamera?Container(
                            width: width*0.5,
                            height: height*0.3,
                            child: CameraPreview(cameraVideoController!)
                        ):
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
                            onPressed:()=>duration.inSeconds > 0 ?startTimer() :stopTimer(),
                            heightCustom: 0.1,
                            size: 15.0,
                            colorBorder: duration.inSeconds > 0?Colors.green.shade400:Colors.red,
                            colorButton:  duration.inSeconds > 0?Colors.green.shade400:Colors.red,
                            colorText: PaletteColor.white,
                            text: duration.inSeconds > 0?'Pressione para\nIniciar Aula':'Pressione para\nAula Concluída',
                            widthCustom: 0.8,
                          ),
                        ) :Container(
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
                      ],
                    ),
                  )
                ),
                compressVideo==false?Container():SizedBox(height: 50,),
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