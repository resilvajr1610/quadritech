import '../utils/export.dart';

class ContainerDelete extends StatelessWidget {
  final onTapDelete;

  ContainerDelete({required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapDelete,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 27),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: PaletteColor.greyButtom
        ),
        child: Icon(Icons.keyboard_backspace)),
    );
  }
}
