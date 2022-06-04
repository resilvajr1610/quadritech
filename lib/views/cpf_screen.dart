import 'package:flutter/cupertino.dart';

import '../utils/export.dart';

class CpfScreen extends StatefulWidget {
  final type;
  final time;

  CpfScreen({required this.type, required this.time});

  @override
  _CpfScreenState createState() => _CpfScreenState();
}

class _CpfScreenState extends State<CpfScreen> {

  String cpf='Digite o CPF do Aluno';


  digit(String number){
    if(cpf.length<14){
      if(cpf=='Digite o CPF do Aluno'){
        cpf="";
        setState(() {
          cpf= cpf+number;
        });
      }else{
        setState(() {
          cpf= cpf+number;
          if(cpf.length == 3){
            cpf= cpf+'.';
          }
          if(cpf.length == 7){
            cpf= cpf+'.';
          }
          if(cpf.length == 11){
            cpf= cpf+'-';
          }
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title:  Image.asset("assets/logo_main.png",height: 30),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerCpf(cpf: cpf),
            GroupNumber(
              onTap0: ()=>digit('0'),
              onTap1: ()=>digit('1'),
              onTap2: ()=>digit('2'),
              onTap3: ()=>digit('3'),
              onTap4: ()=>digit('4'),
              onTap5: ()=>digit('5'),
              onTap6: ()=>digit('6'),
              onTap7: ()=>digit('7'),
              onTap8: ()=>digit('8'),
              onTap9: ()=>digit('9'),
            )
          ],
        ),
      ),
    );
  }
}
