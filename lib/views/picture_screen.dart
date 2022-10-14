import '../utils/export.dart';
import 'countdown_screen.dart';

class PictureScreen extends StatefulWidget {
  final time;
  final type;
  final cpfStudent;
  final cpfTeacher;
  final idLesson;

  PictureScreen({
    required this.time,
    required this.cpfStudent,
    required this.cpfTeacher,
    required this.type,
    required this.idLesson,
  });

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LessonModel _lessonModel = LessonModel();
  bool _sending = false;
  File? picture;
  String _urlPhoto = "";

  Future _savePhoto(String namePhoto) async {
    if (namePhoto != null && namePhoto != "") {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
        if (image == null) return;

        final imageTemporary = File(image.path);
        setState(() {
          this.picture = imageTemporary;
          setState(() {
            _sending = true;
          });
          _uploadImage(namePhoto);
        });

      } on PlatformException catch (e) {
        print('Error : $e');
      }
    } else {
      showSnackbar(context, 'Verifique o CPF Digitado', _scaffoldKey);
    }
  }

  Future _uploadImage(String namePhoto) async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("aulas").child(namePhoto +
        "_" +
        widget.type +
        "_" +
        DateTime.now().toString() +
        ".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 3), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          _urlPhoto = urlImage;
        });
        _urlImageFirestore(urlImage, namePhoto);
      }
    });
  }

  _urlImageFirestore(String url, String namePhoto) {
    _lessonModel = LessonModel.createId();

    Map<String, dynamic> dateUpdate = {
      namePhoto: url,
      'cpfStudent' : widget.cpfStudent,
      'cpfTeacher' : widget.cpfTeacher,
      'time'       : widget.time,
      'idLesson'   : widget.idLesson,
      'startTime'  : DateTime.now(),
    };

    if (widget.type == 'Foto do Aluno') {
      db
          .collection("lesson")
          .doc(_lessonModel.id)
          .set(dateUpdate)
          .then((value) {
        setState(() {
          _sending = false;
        });
      });
    } else {
      db
          .collection("lesson")
          .doc(widget.idLesson)
          .update(dateUpdate)
          .then((value) {
        setState(() {
          _sending = false;
        });
      });
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowDialog(
            title: 'Dados cadastrados\n com sucesso!',
            list: [
              ButtonCustom(
                text: 'OK',
                colorBorder: Colors.green,
                colorText: PaletteColor.white,
                colorButton: Colors.green,
                widthCustom: 0.2,
                heightCustom: 0.07,
                onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (_) => CountdownScreen(timer: widget.time,idLesson: widget.idLesson,))),
                size: 14.0,
              ),
            ],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: Image.asset("assets/logo_main.png", height: 30),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            TextCustom(text: widget.type),
            _urlPhoto == ""
                ? Container(
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom),
                    child: Image.asset(
                      'assets/profile.png',
                      color: PaletteColor.grey,
                      height: 100,
                    ))
                : Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: PaletteColor.greyButtom,
                        image: DecorationImage(
                            image: NetworkImage(_urlPhoto), fit: BoxFit.cover)),
                  ),
            _sending == true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: PaletteColor.primaryColor),
                      TextCustom(text: 'Enviando')
                    ],
                  )
                : ButtonCustom(
                    onPressed: () => _savePhoto(widget.type == 'Foto do Aluno'
                        ? 'picture_student'
                        : 'picture_teacher'),
                    text: 'Tirar Foto',
                    size: 14.0,
                    colorButton: PaletteColor.grey,
                    colorText: PaletteColor.white,
                    colorBorder: PaletteColor.grey,
                    widthCustom: 0.5,
                    heightCustom: 0.07),
            _sending == false? Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ButtonCustom(
                  onPressed: () {
                    if(_urlPhoto==""){
                      showSnackbar(context, 'Tire uma '+widget.type+' para avançar', _scaffoldKey);
                    }else{
                      if (widget.type == 'Foto do Aluno') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PictureScreen(
                                  time: widget.time,
                                  cpfStudent: widget.cpfStudent,
                                  cpfTeacher: widget.cpfTeacher,
                                  type: "Foto do Instrutor",
                                  idLesson: _lessonModel.id,
                                )));
                      } else {
                        _showDialog();
                      }
                    }
                  },
                  text:
                      widget.type == 'Foto do Aluno' ? 'Próximo' : 'Finalizar',
                  size: 14.0,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor,
                  widthCustom: 0.8,
                  heightCustom: 0.07),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
