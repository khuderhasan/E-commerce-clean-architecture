import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthPage extends StatelessWidget {
  static const routeName = '/auth';

  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BackgroundGradientContainer(),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const MyShopTextWidget(),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyShopTextWidget extends StatelessWidget {
  const MyShopTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
        transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
        // ..translate(-10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepOrange.shade900,
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: const Text(
          'MyShop',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 50,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class BackgroundGradientContainer extends StatelessWidget {
  const BackgroundGradientContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 1],
        ),
      ),
    );
  }
}
