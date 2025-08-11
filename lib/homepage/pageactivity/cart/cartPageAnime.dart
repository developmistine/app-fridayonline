import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController moveController;
  late Animation moveAnimation;

  Position? fromPosition;
  GlobalKey starKey = GlobalKey();

  @override
  void initState() {
    moveController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    moveAnimation =
        CurvedAnimation(parent: moveController, curve: Curves.easeInOut);

    moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('end of animation');
        setState(() {
          fromPosition = null;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromKey = GlobalKey();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(child: SizedBox.shrink()),
                  Container(child: Icon(Icons.weekend, key: fromKey)),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          fromPosition = getPositionByKey(fromKey);
                        });
                        moveController.reset();
                        moveController.forward();
                      },
                      child: Text('start animation')),
                ],
              ),
            ),
            Row(
              children: [
                Spacer(),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Stack(
                    children: [
                      buildFlyWidget(),
                      Container(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.all(5),
                          child:
                              Icon(Icons.shopping_cart, color: Colors.black)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFlyWidget() {
    if (fromPosition == null) {
      return SizedBox.shrink();
    }
    return Container(
      key: starKey,
      height: 24,
      width: 24,
      child: AnimatedBuilder(
        animation: moveAnimation,
        builder: (context, child) {
          Position currentPosition;
          double x = 0, y = 0;
          if (starKey.currentContext?.findRenderObject() != null) {
            currentPosition = getPositionByKey(starKey);
            x = fromPosition!.x - currentPosition.x;
            y = fromPosition!.y - currentPosition.y;
          }
          if (x == 0) return Container();
          return Transform.translate(
            offset: Offset(
                x * (1 - moveAnimation.value), y * (1 - moveAnimation.value)),
            child: Opacity(
              opacity: fromPosition == null ? 0.0 : 1.0,
              child: Icon(Icons.weekend_outlined, color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}

Position getPositionByKey(GlobalKey key) {
  final renderObject = key.currentContext!.findRenderObject()!;
  var translation = renderObject.getTransformTo(null).getTranslation();
  final rect =
      renderObject.paintBounds.shift(Offset(translation.x, translation.y));
  return Position(rect.left, rect.top, rect.size);
}

class Position {
  double x;
  double y;
  Size size;

  Position(this.x, this.y, this.size);
}
