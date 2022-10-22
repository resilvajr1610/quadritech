import 'package:url_launcher/url_launcher.dart';

import '../utils/export.dart';

class ShowDialogHistory extends StatelessWidget {
  final String title;
  final List<Widget> list;
  final time;
  final video;
  final cpfStudent;
  final cpfTeacher;
  final picture_student;
  final picture_student_finish;
  final picture_teacher;
  final picture_teacher_finish;
  final startTime;
  final endTime;
  final obs;
  List photosLesson;
  String placa;
  String kmInicial;
  String kmFinal;

  ShowDialogHistory({
    required this.title,
    required this.list,
    required this.time,
    required this.cpfStudent,
    required this.cpfTeacher,
    required this.picture_student,
    required this.picture_student_finish,
    required this.picture_teacher,
    required this.picture_teacher_finish,
    required this.startTime,
    required this.endTime,
    required this.photosLesson,
    required this.video,
    required this.placa,
    required this.kmInicial,
    required this.kmFinal,
    required this.obs,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      titlePadding: EdgeInsets.symmetric(vertical: 10),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tempo aula : '+ time,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('Início : '+ startTime,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('Final : '+ endTime,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 20),
          Text('CPF Aluno : '+ cpfStudent,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('CPF Instrutor : '+ cpfTeacher,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('Placa : '+ placa,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('KM Inicial : '+ kmInicial,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 5),
          Text('KM Final : '+ kmFinal,style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          SizedBox(height: 10),
          obs==''?Container():Text('Observações :',style: TextStyle(color: PaletteColor.grey, fontSize: 15),),
          obs==''?Container():Text(obs.toString().toUpperCase(),style: TextStyle(color: PaletteColor.grey, fontSize: 15,fontWeight: FontWeight.bold),),
          SizedBox(height: 20),
          video==''?Container():Container(
            alignment: Alignment.center,
            child: ButtonCustom(
                onPressed:()async{
                  await launchUrl(Uri.parse(video));
                },
                text: 'Video',
                size: 14.0,
                colorButton: PaletteColor.primaryColor,
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor,
                widthCustom: 0.4,
                heightCustom: 0.05
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Foto Aluno\nInício',style: TextStyle(color: PaletteColor.primaryColor, fontSize: 15),textAlign: TextAlign.center,),
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(picture_student), fit: BoxFit.cover)),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Foto Instrutor\nInício',style: TextStyle(color: PaletteColor.primaryColor, fontSize: 15),textAlign: TextAlign.center),
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(picture_teacher), fit: BoxFit.cover)),
                  ),
                ],
              ),
            ],
          ),
          picture_student_finish!='' && picture_student_finish!=null?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Foto Aluno\nFinal',style: TextStyle(color: PaletteColor.primaryColor, fontSize: 15),textAlign: TextAlign.center),
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(picture_student_finish), fit: BoxFit.cover)),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Foto Instrutor\nFinal',style: TextStyle(color: PaletteColor.primaryColor, fontSize: 15),textAlign: TextAlign.center),
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(picture_teacher_finish), fit: BoxFit.cover)),
                  ),
                ],
              ),
            ],
          ):Container(),
          Text(photosLesson.length==0?'Nenhuma foto aleatória registrada':'Fotos Aleatórias',style: TextStyle(color: PaletteColor.primaryColor, fontSize: 15),textAlign: TextAlign.center),
          photosLesson.length==0?Container():Container(
            height: 300,
            child: ListView.builder(
              itemCount: photosLesson.length,
              itemBuilder: (context,index){
                return Container(
                    width: 200,
                    height: 200,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(photosLesson[index]), fit: BoxFit.cover))
                );
              },
            ),
          ),
        ],
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor, fontSize: 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: this.list,
    );
  }
}
