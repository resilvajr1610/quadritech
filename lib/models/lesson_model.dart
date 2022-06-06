import '../utils/export.dart';

class LessonModel{

  String _id="";

  LessonModel();

  LessonModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
  }

  LessonModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference parts = db.collection("lesson");
    this.id = parts.doc().id;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}