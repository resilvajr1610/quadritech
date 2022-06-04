import '../utils/export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _show=false;

  _mockCheckForSession(){
    Future.delayed(Duration(milliseconds: 3000),(){

      setState(() {
        _show=true;
      });

      Future.delayed(Duration(milliseconds: 2000),(){

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: ( BuildContext context) => HomeScreen()
            )
        );
      });
    });
  }



  @override
  void initState() {
    super.initState();
    _mockCheckForSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PaletteColor.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset("assets/logo_main.png",width: 200,),
              Visibility(
                  visible: _show,
                  child: Image.asset("assets/logo_class.png",width: 150,)),
            ],
          ),
        ));
  }
}
