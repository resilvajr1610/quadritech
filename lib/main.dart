import 'utils/export.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    initialRoute: "/splash",
    onGenerateRoute: Routes.generateRoute,
  ));
}