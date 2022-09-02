import '../Utils/export.dart';

class GroupRadioSettings extends StatelessWidget {
  final title;
  final radioNo;
  final radioYes;
  int valueNo;
  int valueYes;
  var onChangedNo;
  var onChangedYes;

  GroupRadioSettings({
    required this.title,
    required this.radioNo,
    required this.radioYes,
    required this.valueNo,
    required this.valueYes,
    required this.onChangedNo,
    required this.onChangedYes,
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(text: title,color: PaletteColor.black,fontWeight: FontWeight.normal,size: 16.0),
        Spacer(),
        SizedBox(width: 100, child: Radio(value:valueNo , groupValue: radioNo, onChanged: onChangedNo)),
        SizedBox(width: 50, child: Radio(value:valueYes , groupValue: radioYes, onChanged: onChangedYes)),
      ],
    );
  }
}
