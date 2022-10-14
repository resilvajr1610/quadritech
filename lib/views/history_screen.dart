import 'package:intl/intl.dart';
import '../models/ErrorDate.dart';
import '../models/error_list.dart';
import '../utils/export.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  var _controllerItems = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _resultsList = [];

  _showDialog(String startTime,String endTime,String time,String picture_student, String picture_teacher, String cpfStudent,
      String cpfTeacher,String picture_student_finish,String picture_teacher_finish,List photosLesson,String video) {
    showDialog(
        context: context,
        builder: (context) {
          return ShowDialogHistory(
            title: 'Aula',
            time: time,
            video: video,
            picture_student: picture_student,
            picture_teacher: picture_teacher,
            picture_student_finish: picture_student_finish,
            picture_teacher_finish: picture_teacher_finish,
            startTime: startTime,
            endTime: endTime,
            cpfStudent: cpfStudent,
            cpfTeacher: cpfTeacher,
            photosLesson: photosLesson,
            list: [
              ButtonCustom(
                text: 'Fechar',
                colorBorder: Colors.green,
                colorText: PaletteColor.white,
                colorButton: Colors.green,
                widthCustom: 0.2,
                heightCustom: 0.07,
                onPressed: () =>Navigator.pop(context),
                size: 14.0,
              ),
            ],
          );
        });
  }

  _data() async {

    var data = await db.collection("lesson").orderBy('startTime',descending: true).get();

    setState(() {
      _resultsList = data.docs;
    });
    return "complete";
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: PaletteColor.primaryColor
        ),
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title:  Image.asset("assets/logo_main.png",height: 30),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: TextCustom(text: 'Histórico de aulas',)),
            Container(
              height: height*0.75,
              child: StreamBuilder(
                stream: _controllerItems.stream,
                builder: (context, snapshot) {

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(_resultsList.length == 0){
                        return Center(
                            child: Text('Aulas não cadastradas',
                              style: TextStyle(fontSize: 20,color: PaletteColor.primaryColor),)
                        );
                      }else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Scrollbar(
                            showTrackOnHover: true,
                            radius: Radius.circular(5),
                            thickness: 5,
                            isAlwaysShown: true,
                            child: ListView.builder(
                                itemCount: _resultsList.length,
                                itemBuilder: (BuildContext context, index) {
                                  DocumentSnapshot item = _resultsList[index];

                                  DateTime startTime = (item['startTime'] as Timestamp).toDate();
                                  var convStart = DateFormat('dd/MM/yyyy HH:mm').format(startTime);
                                  var convFinish='';
                                  if(ErrorDate(item,'finishTime')!=Timestamp(0,0)){
                                    DateTime finishTime = (item['finishTime'] as Timestamp).toDate();
                                    convFinish = DateFormat('dd/MM/yyyy HH:mm').format(finishTime);
                                  }

                                  final time            = ErrorString(item,'time');
                                  final video            = ErrorString(item,'video');
                                  final cpfStudent      = ErrorString(item,'cpfStudent');
                                  final cpfTeacher      = ErrorString(item,'cpfTeacher');
                                  final picture_student = ErrorString(item,'picture_student');
                                  final picture_teacher = ErrorString(item,'picture_teacher');
                                  final picture_teacher_finish = ErrorString(item,'picture_teacher_finish');
                                  final picture_student_finish = ErrorString(item,'picture_student_finish');
                                  List photosLesson = ErrorList(item,'photosLesson');

                                  return GestureDetector(
                                    onTap: ()=>_showDialog(convStart,convFinish,time,picture_student, picture_teacher, cpfStudent, cpfTeacher,picture_student_finish,picture_teacher_finish,photosLesson,video),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                      child: Center(
                                          child: Card(
                                            elevation: 2,
                                            color: PaletteColor.greyButtom,
                                            child: Container(
                                              width: width,
                                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 20),
                                              child: Text('Data da aula registrada : '+ convStart.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 12),),
                                            )
                                          )
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
      ),
    );
  }
}
