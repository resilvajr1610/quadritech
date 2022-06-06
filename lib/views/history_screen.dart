import 'package:intl/intl.dart';

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

  _showDialog(String startTime,String endTime,String time,String picture_student, String picture_teacher, String cpfStudent, String cpfTeacher ) {
    showDialog(
        context: context,
        builder: (context) {
          return ShowDialogHistory(
            title: 'Aula',
            time: time,
            picture_student: picture_student,
            picture_teacher: picture_teacher,
            startTime: startTime,
            endTime: endTime,
            cpfStudent: cpfStudent,
            cpfTeacher: cpfTeacher,
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

    var data = await db.collection("lesson").orderBy('startTime').get();

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
              height: height*0.5,
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
                        return ListView.builder(
                            itemCount: _resultsList.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _resultsList[index];

                              DateTime dt = (item['startTime'] as Timestamp).toDate();
                              var output = DateFormat('dd/MM/yyyy HH:mm').format(dt);

                              final time            = ErrorList(item,'time');
                              final cpfStudent      = ErrorList(item,'cpfStudent');
                              final cpfTeacher      = ErrorList(item,'cpfTeacher');
                              final picture_student = ErrorList(item,'picture_student');
                              final picture_teacher = ErrorList(item,'picture_teacher');

                              final endTime = dt.add(Duration(minutes: time=='50 minutos'?50:100));
                              var end = DateFormat('dd/MM/yyyy HH:mm').format(endTime);

                              return GestureDetector(
                                onTap: ()=>_showDialog(output,end,time,picture_student, picture_teacher, cpfStudent, cpfTeacher ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  child: Center(
                                      child: Card(
                                        elevation: 2,
                                        color: PaletteColor.greyButtom,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 20),
                                          child: Text('Data da aula registrada : '+ output.toString()),
                                        )
                                      )
                                  ),
                                ),
                              );
                            }
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
