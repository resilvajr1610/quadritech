import '../utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int value=0;
  int selectedRadioButton=0;
  String selectedText="50 minutos";
  List titleRadio=['50 minutos','100 minutos'];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    setSelectedRadio(int value){
      setState(() {
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title:  Image.asset("assets/logo_main.png",height: 30),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadioListTile(
            value: 0,
            groupValue: selectedRadioButton,
            activeColor: PaletteColor.primaryColor,
            title: Container(
                height: 20,
                margin: const EdgeInsets.only(top: 15.0),
                child: Text('50 minutos')
            ),
            subtitle: Text(''),
            onChanged: (value){
              setSelectedRadio(int.parse(value.toString()));
            },
          ),
          RadioListTile(
            value: 1,
            groupValue: selectedRadioButton,
            activeColor: PaletteColor.primaryColor,
            title: Container(
                height: 20,
                margin: const EdgeInsets.only(top: 15.0),
                child: Text('100 minutos')
            ),
            subtitle: Text(''),
            onChanged: (value){
              setSelectedRadio(int.parse(value.toString()));
            },
          ),
          SizedBox(height: 50),
          ButtonCustom(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => CpfScreen(type: 'Aluno',time: selectedText,cpfStudent: ""))),
              text: 'Iniciar Aula',
              size: 14.0,
              colorButton:  PaletteColor.primaryColor,
              colorText:  PaletteColor.white,
              colorBorder:  PaletteColor.primaryColor,
              widthCustom: 0.7,
              heightCustom: 0.07
          )
        ],
      )
    );
  }
}
