import '../utils/export.dart';

class CpfScreen extends StatefulWidget {
  final type;
  final time;
  final cpfStudent;

  CpfScreen({required this.type, required this.time, required this.cpfStudent});

  @override
  _CpfScreenState createState() => _CpfScreenState();
}

class _CpfScreenState extends State<CpfScreen> {
  String cpf = 'Digite o CPF';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  digit(String number) {
    if (cpf == 'Digite o CPF') {
      cpf = "";
      setState(() {
        cpf = cpf + number;
      });
    } else {
      if (cpf.length < 14) {
        if (cpf.length == 3) {
          setState(() {
            cpf = cpf + '.';
          });
        }
        if (cpf.length == 7) {
          setState(() {
            cpf = cpf + '.';
          });
        }
        if (cpf.length == 11) {
          setState(() {
            cpf = cpf + '-';
          });
        }
        setState(() {
          cpf = cpf + number;
        });
      }
    }
  }

  delete() {
    if (cpf.length != 0) {
      setState(() {
        cpf = cpf.substring(0, cpf.length - 1);
      });
      if (cpf.length == 12) {
        setState(() {
          cpf = cpf.substring(0, cpf.length - 1);
        });
      }
      if (cpf.length == 8) {
        setState(() {
          cpf = cpf.substring(0, cpf.length - 1);
        });
      }
      if (cpf.length == 4) {
        setState(() {
          cpf = cpf.substring(0, cpf.length - 1);
        });
      }
    }
  }

  verification(){
    if(cpf.length == 14){
     if(widget.type=='CPF do Aluno'){
       Navigator.push(context, MaterialPageRoute(builder: (_) => CpfScreen(type: 'CPF do Instrutor',time: widget.time,cpfStudent: cpf)));
     }else{
       Navigator.push(context, MaterialPageRoute(builder: (_) => PictureScreen(time: widget.time,cpfStudent: widget.cpfStudent,cpfTeacher: cpf,type: "Foto do Aluno",idLesson: "",)));
     }
    }else{
      showSnackbar(context, 'Verifique o CPF Digitado', _scaffoldKey);
    }
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextCustom(text: widget.type),
            SizedBox(height: 10),
            ContainerCpf(cpf: cpf),
            SizedBox(height: 10),
            GroupNumber(
              onTap0: () => digit('0'),
              onTap1: () => digit('1'),
              onTap2: () => digit('2'),
              onTap3: () => digit('3'),
              onTap4: () => digit('4'),
              onTap5: () => digit('5'),
              onTap6: () => digit('6'),
              onTap7: () => digit('7'),
              onTap8: () => digit('8'),
              onTap9: () => digit('9'),
              onTapDelete: () => delete(),
            ),
            SizedBox(height: 20),
            ButtonCustom(
                onPressed: ()=>verification(),
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
