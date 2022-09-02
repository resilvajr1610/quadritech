import 'package:quadritech/models/radio_settings_model.dart';

import '../utils/export.dart';
import '../widget/group_radio_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  String selectedText="não";
  List titleRadio=['não','sim'];
  List nameRadio=['Biometria Facial','Biometria Digital','Filmagem','Percurso'];
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<RadioSettingsModel> _listModelRadio=[];

  setSelectedRadio(int value,int index){
    setState(() {
      _listModelRadio[index].select=value;
      selectedText = titleRadio[value];
      db.collection('settings').doc('settings').set({
        nameRadio[0]:_listModelRadio[0].select,
        nameRadio[1]:_listModelRadio[1].select,
        nameRadio[2]:_listModelRadio[2].select,
        nameRadio[3]:_listModelRadio[3].select,
      });
    });
  }

  _data()async{
    DocumentSnapshot snapshot = await db.collection('settings').doc('settings').get();
    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    Future.delayed(Duration(seconds: 1),(){
      _listModelRadio.clear();
      setState(() {
        _listModelRadio.add(RadioSettingsModel(select: data?[nameRadio[0]]));
        _listModelRadio.add(RadioSettingsModel(select: data?[nameRadio[1]]));
        _listModelRadio.add(RadioSettingsModel(select: data?[nameRadio[2]]));
        _listModelRadio.add(RadioSettingsModel(select: data?[nameRadio[3]]));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title:  Image.asset("assets/logo_main.png",height: 30),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(text: 'Configurações',color: PaletteColor.black,),
                    Spacer(),
                    SizedBox(width: 70, child: TextCustom(text: 'Não',color: PaletteColor.black)),
                    SizedBox(width: 55, child: TextCustom(text: 'Sim',color: PaletteColor.black)),
                  ],
                ),
                SizedBox(
                  height: _listModelRadio.length*50,
                  child: ListView.builder(
                    itemCount: _listModelRadio.length,
                    itemBuilder: (context,index){
                      return GroupRadioSettings(
                        title: nameRadio[index],
                        valueNo: 0,
                        valueYes: 1,
                        radioNo: _listModelRadio[index].select,
                        radioYes: _listModelRadio[index].select,
                        onChangedNo: (value)=> setSelectedRadio(int.parse(value.toString()),index),
                        onChangedYes: (value)=> setSelectedRadio(int.parse(value.toString()),index),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
