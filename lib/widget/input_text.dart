import '../utils/export.dart';

class InputText extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final String label;
  final double fonts;
  final TextInputType keyboardType;
  final bool obscure;
  final double width;
  List<TextInputFormatter>? inputFormatters=[];

  InputText({
    required this.controller,
    required this.hint,
    this.label = '',
    required this.fonts,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    required this.width,
    this.inputFormatters
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.topCenter,
      height: height*0.07,
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: PaletteColor.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        obscureText: this.obscure,
        controller: this.controller,
        textAlign: TextAlign.start,
        keyboardType: this.keyboardType,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          color: PaletteColor.primaryColor,
          fontSize: this.fonts,
        ),
        inputFormatters:inputFormatters,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint,
            labelText: label,
            hintStyle: TextStyle(
              color: PaletteColor.primaryColor,
              fontSize: fonts,
            ),
        ),
      ),
    );
  }
}
