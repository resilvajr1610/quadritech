import '../utils/export.dart';
import '../widget/show_dialog_alert.dart';

class AlertModel{

  alert(String title, String content,final colorTextTitle, final colorTextContent, BuildContext context, List<Widget> listActions,final controller){
    showDialog(
        context: context,
        builder: (context) {

          return ShowDialogAlert(
              controller: controller,
              title: title,
              content: content,
              colorTextContent: colorTextContent,
              colorTextTitle: colorTextTitle,
              listActions: listActions
          );
        });
  }
}