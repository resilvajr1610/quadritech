import '../utils/export.dart';

class ContainerCpf extends StatelessWidget {
  final cpf;

  ContainerCpf({required this.cpf});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: PaletteColor.grey)
      ),
      width: width*0.7,
      child: Text(cpf,textAlign: TextAlign.center),
    );
  }
}
