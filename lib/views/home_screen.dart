import '../models/alert_model.dart';
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
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    setSelectedRadio(int value){
      setState(() {
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
    }

    double hight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title:  Image.asset("assets/logo_main.png",height: 30),
        centerTitle: true,
        actions: [
          IconButton(
            color: PaletteColor.primaryColor,
            onPressed: ()=>AlertModel().alert('Configurações!', 'Insira a senha', PaletteColor.primaryColor, PaletteColor.grey, context, [
              SizedBox(
                height: 30,
                width: 100,
                child: ButtonCustom(
                  colorButton:  PaletteColor.primaryColor,
                  colorText:  PaletteColor.white,
                  colorBorder:  PaletteColor.primaryColor,
                  widthCustom: 0.7,
                  heightCustom: 0.07,
                  size: 15.0,
                  onPressed: (){
                    if(controller.text == 'senha123'){
                      controller.clear();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                  text: 'Entrar',
                ),
              )
            ],controller),
            icon: Icon(Icons.settings)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: hight*0.9,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: RadioListTile(
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
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.7,
                child: RadioListTile(
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
              ),
              SizedBox(height: 50),
              ButtonCustom(
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => CpfScreen(type: 'CPF do Aluno',time: selectedText,cpfStudent: ""))),
                  text: 'Iniciar Aula',
                  size: 14.0,
                  colorButton:  PaletteColor.primaryColor,
                  colorText:  PaletteColor.white,
                  colorBorder:  PaletteColor.primaryColor,
                  widthCustom: 0.7,
                  heightCustom: 0.07
              ),
              SizedBox(height: 30),
              ButtonCustom(
                  onPressed: ()=>Navigator.pushNamed(context, '/history'),
                  text: 'Histórico de Aulas',
                  size: 14.0,
                  colorButton:  PaletteColor.grey,
                  colorText:  PaletteColor.white,
                  colorBorder:  PaletteColor.grey,
                  widthCustom: 0.7,
                  heightCustom: 0.07
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      )
    );
  }
}
