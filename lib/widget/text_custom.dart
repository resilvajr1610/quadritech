import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final type;

  TextCustom({required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('CPF do $type'.toUpperCase(),style: TextStyle(fontSize: 20,color: PaletteColor.primaryColor,fontWeight: FontWeight.bold),),
    );
  }
}
