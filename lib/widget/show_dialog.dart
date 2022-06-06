import '../utils/export.dart';

class ShowDialog extends StatelessWidget {
  final String title;
  final List<Widget> list;

  ShowDialog({
    required this.title,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(this.title)),
      titleTextStyle: TextStyle(color: PaletteColor.grey, fontSize: 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: this.list,
    );
  }
}
