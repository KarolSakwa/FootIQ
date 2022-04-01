import 'package:flutter/material.dart';
import 'package:footix/contants.dart';

class DashboardCard extends StatelessWidget {
  final Widget? child;
  const DashboardCard({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: kMainCardColor,
        elevation: 1,
        shadowColor: Colors.black,
        child: child);
  }
}
