import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class CreditaskVersion extends StatelessWidget {
  final TextStyle style;

  CreditaskVersion({this.style});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            String version = snapshot.data.version;
            return Text('v$version', style: this.style);
          } else {
            return Text('', style: this.style);
          }
        });
  }
}
