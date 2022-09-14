import '../utils/export.dart';

Timestamp ErrorDate(item,type){
  Timestamp date;
  try {
  dynamic data = item.get(FieldPath([type]));
    date = data;
  } on StateError catch (e) {
    date = Timestamp(0,0);
  }
  return date;
}