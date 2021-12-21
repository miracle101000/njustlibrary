import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Scrollbar(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                child: Column(children: [
              SizedBox(
                height: height * 0.15,
              ),
              Center(
                  child: Container(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/njustlogo.png'),
                        fit: BoxFit.contain)),
              )),
              SizedBox(
                height: 16,
              ),
              Text(
                'title'.tr,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'start_end'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ])),
            SizedBox(
              height: height * 0.3,
            ),
            Text(
              ' 南京理工大学图书馆   OPAC v5.6.1.210629  © 1999-2021 Jiangsu Huiwen Software Ltd. 江苏汇文软件有限公司',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ))),
    );
  }
}
