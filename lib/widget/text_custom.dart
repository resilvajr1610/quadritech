import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;

  TextCustom({
    required this.text,
    this.size = 20.0,
    this.color = PaletteColor.primaryColor,
    this.fontWeight = FontWeight.bold
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,style: TextStyle(fontSize: size,color: color,fontWeight: fontWeight),),
    );
  }
}
