import '../utils/export.dart';

List ErrorList(item,type){
  List list;
  try {
  dynamic data = item.get(FieldPath([type]));
    list = data;
  } on StateError catch (e) {
    list = [];
  }
  return list;
}