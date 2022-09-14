import '../utils/export.dart';

class ShowDialogHistory extends StatelessWidget {
  final String title;
  final List<Widget> list;
  final time;
  final cpfStudent;
  final cpfTeacher;
  final picture_student;
  final picture_student_finish;
  final picture_teacher;
  final picture_teacher_finish;
  final startTime;
  final endTime;

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
          SizedBox(height: 20),
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
        ],
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor, fontSize: 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: this.list,
    );
  }
}
