import '../utils/export.dart';

String ErrorString(item,type){
  String text;
  try {
  dynamic data = item.get(FieldPath([type]));
    text = data;
  } on StateError catch (e) {
    text = '';
  }
  return text;
}