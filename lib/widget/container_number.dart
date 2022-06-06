import '../utils/export.dart';

class ContainerNumber extends StatelessWidget {
  final number;

  ContainerNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: PaletteColor.greyButtom
      ),
      child: Text(number.toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
    );
  }
}
