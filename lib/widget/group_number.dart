import '../utils/export.dart';

class GroupNumber extends StatelessWidget {
  final onTap1;
  final onTap2;
  final onTap3;
  final onTap4;
  final onTap5;
  final onTap6;
  final onTap7;
  final onTap8;
  final onTap9;
  final onTap0;

  GroupNumber({
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.onTap4,
    required this.onTap5,
    required this.onTap6,
    required this.onTap7,
    required this.onTap8,
    required this.onTap9,
    required this.onTap0,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: onTap1,child: ContainerNumber(number: 1)),
              GestureDetector(onTap: onTap2,child: ContainerNumber(number: 2)),
              GestureDetector(onTap: onTap3,child: ContainerNumber(number: 3)),
              GestureDetector(onTap: onTap4,child: ContainerNumber(number: 4)),
              GestureDetector(onTap: onTap5,child: ContainerNumber(number: 5)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: onTap6,child: ContainerNumber(number: 6)),
              GestureDetector(onTap: onTap7,child: ContainerNumber(number: 7)),
              GestureDetector(onTap: onTap8,child: ContainerNumber(number: 8)),
              GestureDetector(onTap: onTap9,child: ContainerNumber(number: 9)),
              GestureDetector(onTap: onTap0,child: ContainerNumber(number: 0)),
            ],
          )
        ],
      ),
    );
  }
}
