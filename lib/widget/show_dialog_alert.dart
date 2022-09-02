
import '../Utils/export.dart';

class ShowDialogAlert extends StatelessWidget {

  final String title;
  final colorTextTitle;
  final colorTextContent;
  final controller;
  final String content;
  List<Widget> listActions;

  ShowDialogAlert({
    required this.title,
    required this.controller,
    required this.content,
    required this.listActions,
    this.colorTextTitle = Colors.red,
    this.colorTextContent = Colors.red,
});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: width*0.4,
            height: height*0.07,
            child: TextCustom(
              text: title,
              color: PaletteColor.grey,
              size: 16.0,
            )
          ),
        ],
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor,fontSize: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: width*0.4,
            height: height*0.07,
            child: TextCustom(
              text: content,
              color: PaletteColor.grey,
              size: 16.0,
            ),
          ),
          InputText(
              controller: controller,
              hint: '****',
              label: 'senha',
              fonts: 16.0,
              keyboardType: TextInputType.text,
              obscure: true,
              width: width
          ),
          SizedBox(
            height: height*0.1*listActions.length,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: listActions,
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      // actions: listActions,
    );
  }
}
