import '../Utils/export.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {

  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((progress)=> this.progress = progress);
  }

  @override
  void dispose() {
    super.dispose();
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {

    final value = progress==null? progress : progress!/100;

  return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Finalizando a aula\nAguarde...',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20,),
          LinearProgressIndicator(value: value,minHeight: 12,),
          SizedBox(height: 15),
          ElevatedButton(onPressed: (){
            VideoCompress.cancelCompression();
            Navigator.of(context).pop();
          }, child: Text('Cancelar'))
        ],
      ),
    );
  }
}
