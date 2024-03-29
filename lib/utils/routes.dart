import 'package:quadritech/views/countdown_screen.dart';

import 'export.dart';

class Routes{
    static Route<dynamic>? generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/home" :
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case "/splash" :
          return MaterialPageRoute(
              builder: (_) => SplashScreen()
          );
        case "/history" :
          return MaterialPageRoute(
              builder: (_) => HistoryScreen()
          );
        case "/settings" :
          return MaterialPageRoute(
              builder: (_) => SettingsScreen()
          );
        default :
          _erroRota();
      }
    }
    static  Route <dynamic> _erroRota(){
      return MaterialPageRoute(
          builder:(_){
            return Scaffold(
              appBar: AppBar(
                title: Text("Tela em desenvolvimento"),
              ),
              body: Center(
                child: Text("Tela em desenvolvimento"),
              ),
            );
          });
    }
  }