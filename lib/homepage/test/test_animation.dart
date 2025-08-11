import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late int count;
  late AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  late double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  late bool show;
  bool add = false;

  @override
  void initState() {
    super.initState();
    count = 0;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          add = true;
          count = 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Add to cart example",
                style: TextStyle(color: Colors.blueGrey[900])),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            actions: [IconCart(count: count)]),
        bottomNavigationBar:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Instagram: @demianrc",
                  style: TextStyle(color: Colors.blueGrey[900]))),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text("Facebook: @damianrincondrc",
                  style: TextStyle(color: Colors.blueGrey[900])))
        ]),
        body: Center(
            child: Card(
                child: Container(
                    width: 220.0,
                    height: 280.0,
                    child: Stack(children: [
                      ClipPath(
                          clipper: MyCustomClipper(250),
                          child: Container(
                            color: Colors.red[800],
                            width: 250.0,
                            height: 300.0,
                          )),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                                "http://wellandgood.com/wp-content/uploads/2012/07/Nike-Free-30-Womens-Running-Shoe-511495_600_A.png'"),
                            const Text("Nike Air (Women)",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            GestureDetector(
                                onTap: () {
                                  _animationController.forward();
                                },
                                child: AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: _containerPaddingLeft,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        (!add)
                                            ? AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.fastOutSlowIn,
                                                transform:
                                                    Matrix4.translationValues(
                                                        _translateX,
                                                        _translateY,
                                                        0)
                                                      ..rotateZ(_rotate)
                                                      ..scale(_scale),
                                                child: const Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.white),
                                              )
                                            : Container(),
                                        AnimatedSize(
                                          // vsync: this,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: show
                                              ? const SizedBox(width: 10.0)
                                              : Container(),
                                        ),
                                        AnimatedSize(
                                          // vsync: this,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: show
                                              ? const Text("Add to cart",
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : Container(),
                                        ),
                                        AnimatedSize(
                                          // vsync: this,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: add
                                              ? const Icon(Icons.done,
                                                  color: Colors.white)
                                              : Container(),
                                        ),
                                        AnimatedSize(
                                          // vsync: this,
                                          alignment: Alignment.topLeft,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          child: add
                                              ? const SizedBox(width: 10.0)
                                              : Container(),
                                        ),
                                        AnimatedSize(
                                          // vsync: this,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: add
                                              ? const Text("In Cart",
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : Container(),
                                        ),
                                      ],
                                    )))
                          ])
                    ])))));
  }
}

class IconCart extends StatelessWidget {
  final int count;

  const IconCart({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Icon(Icons.shopping_cart, color: Colors.blueGrey[900]),
      Positioned(
          right: 0,
          child: Container(
              padding: const EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '$count',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              )))
    ]);
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final double clipHeight;
  MyCustomClipper(this.clipHeight);
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - clipHeight, 0.0);
    path.lineTo(size.width + 30, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
