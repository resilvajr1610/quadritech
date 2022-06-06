import '../utils/export.dart';

class PictureScreen extends StatefulWidget {
  final time;
  final cpfStudent;
  final cpfTeacher;

  PictureScreen({required this.time, required this.cpfStudent, this.cpfTeacher});

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ButtonCustom(
                onPressed: (){},
                text: 'Próximo',
                size: 14.0,
                colorButton: PaletteColor.primaryColor,
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor,
                widthCustom: 0.8,
                heightCustom: 0.07)
          ],
        ),
      ),
    );
  }
}
