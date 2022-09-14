import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quadritech/views/picture_finish_screen.dart';
import '../utils/colors.dart';
import '../widget/buttom_custom.dart';

class CountdownScreen extends StatefulWidget {
  final timer;
  final idLesson;
  const CountdownScreen({required this.timer,required this.idLesson});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 1000;
  Duration duration = Duration();
  Timer? timer;
  bool click = true;

  @override
  void initState() {
    super.initState();
    print(widget.timer);
    final splitted = widget.timer.split(' ');
    int conv = int.parse(splitted[0]);
    // duration = Duration(minutes: conv);
    duration = Duration(minutes: 1);
  }

  void addTime(){
    final addSeconds=1;
    if(duration.inSeconds > 0){
      setState(() {
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

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (_) =>addTime());
  }

  @override
  Widget build(BuildContext context) {

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
            SizedBox(height: 50,),
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
            buildTime(),
            Spacer(),
            click?ButtonCustom(
              onPressed:()=>duration.inSeconds > 0
                  ?startTimer()
                  :Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    PictureFinishScreen(time: widget.timer,type: "Foto do Aluno",idLesson: widget.idLesson,))),
              heightCustom: 0.1,
              size: 15.0,
              colorBorder: duration.inSeconds > 0?Colors.green.shade400:Colors.red,
              colorButton:  duration.inSeconds > 0?Colors.green.shade400:Colors.red,
              colorText: PaletteColor.white,
              text: duration.inSeconds > 0?'Pressione para\nIniciar Aula':'Pressione para\nAula Concluída',
              widthCustom: 0.8,
            )
            :ButtonCustom(
              onPressed:(){},
              heightCustom: 0.1,
              size: 15.0,
              colorBorder: Colors.orange,
              colorButton:  Colors.orange,
              colorText: PaletteColor.white,
              text: 'Aula em andamento',
              widthCustom: 0.8,
            ),
            SizedBox(height: 50,),
            Image.asset("assets/pratico.png", height: 60)
          ],
        ),
      ),
    );
  }
}
