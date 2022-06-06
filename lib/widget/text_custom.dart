import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;

  TextCustom({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text.toUpperCase(),style: TextStyle(fontSize: 20,color: PaletteColor.primaryColor,fontWeight: FontWeight.bold),),
    );
  }
}
