// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddToCartSlide extends StatefulWidget {
  const AddToCartSlide({super.key});

  @override
  State<AddToCartSlide> createState() => _AddToCartSlideState();
}

class _AddToCartSlideState extends State<AddToCartSlide>
    with TickerProviderStateMixin {
  List<AnimationController>? _controller;
  List<Animation<Offset>>? _slideAnimation;
  List<Animation<double>>? _scaleAnimation;
  List<bool> _isAddedToCart = List<bool>.generate(10, (index) => false);
  List<GlobalKey> _widgetKey = List<GlobalKey>.generate(
    10,
    (index) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();

    _controller = List<AnimationController>.generate(
      10,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      ),
    );
    _slideAnimation = List<Animation<Offset>>.generate(
      10,
      (index) => Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(5.0, -10.0),
      ).animate(CurvedAnimation(
        parent: _controller![index],
        curve: Curves.easeInOut,
      )),
    );

    _scaleAnimation = List<Animation<double>>.generate(
      10,
      (index) => Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _controller![index],
        curve: Curves.easeInOut,
      )),
    );
  }

  @override
  void dispose() {
    for (var element in _controller!) {
      element.dispose();
    }
    super.dispose();
  }

  _addToCart(index) {
    final RenderBox renderBox =
        _widgetKey[index].currentContext!.findRenderObject() as RenderBox;
    final widgetPosition = renderBox.localToGlobal(Offset.zero);
    final targetPosition = Offset(MediaQuery.of(context).size.width, 0);

    setState(() {
      _slideAnimation = List<Animation<Offset>>.generate(
        10,
        (index) => Tween<Offset>(
                begin: Offset.zero,
                end: Offset(targetPosition.dx - widgetPosition.dx,
                    targetPosition.dy - widgetPosition.dy))
            .animate(CurvedAnimation(
          parent: _controller![index],
          curve: Curves.easeInOutExpo,
        )),
      );
      _isAddedToCart[index] = true;
      _scaleAnimation![index] = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(CurvedAnimation(
          curve: Curves.easeInOut, parent: _controller![index]));
    });
    _controller![index].forward().whenComplete(() {
      setState(() {
        _slideAnimation = List<Animation<Offset>>.generate(
          10,
          (index) => Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(targetPosition.dx - widgetPosition.dx,
                      targetPosition.dy - widgetPosition.dy))
              .animate(CurvedAnimation(
            parent: _controller![index],
            curve: Curves.easeInOut,
          )),
        );
        _isAddedToCart[index] = false;
        _scaleAnimation![index] = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
            curve: Curves.easeInOut, parent: _controller![index]));
      });
      _controller![index].reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),

        // bottom: const PreferredSize(
        //   preferredSize: Size.fromHeight(4.0),
        //   child: LinearProgressIndicator(
        //     backgroundColor: Colors.white,
        //     valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        //   ),
        // ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
        title: const Text('appbar'),
      ),
      body: GridView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(child: methodsCart(index));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
      ),
    );
  }

  Center methodsCart(index) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GestureDetector(key: _widgetKey, child: const Text('appbar')),
          SlideTransition(
            position: _slideAnimation![index],
            child: ScaleTransition(
              scale: _scaleAnimation![index],
              child: !_isAddedToCart[index]
                  ? GestureDetector(
                      key: _widgetKey[index],
                      onTap: (() async {
                        await _addToCart(index);
                      }),
                      child: const CircleAvatar(
                        radius: 24,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.shopping_cart,
                          color: Colors.white, size: 16)),
            ),
          ),
          if (_isAddedToCart[index])
            const CircleAvatar(
              radius: 24,
              // backgroundColor: Colors.purple,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 28,
              ),
            )
        ],
      ),
    );
  }
}
