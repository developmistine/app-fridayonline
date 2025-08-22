import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'dart:io';

class CacheImageContentShop extends StatefulWidget {
  final String url;
  final double? height;
  final BoxFit? fit;

  const CacheImageContentShop(
      {super.key, required this.url, this.height, this.fit});

  @override
  State<CacheImageContentShop> createState() => _CacheImageContentShopState();
}

class _CacheImageContentShopState extends State<CacheImageContentShop>
    with AutomaticKeepAliveClientMixin {
  // 🔥 สำคัญ: ไม่เก็บ state เมื่อออกจาก viewport
  @override
  bool get wantKeepAlive => false;

  // ตัวแปรสำหรับเก็บ Future และติดตาม state
  Future<File>? _imageFuture;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    //print('📸 CacheImageContentShop created: ${widget.url}');
  }

  void _loadImage() {
    if (widget.url.isNotEmpty && !_disposed) {
      // 🔥 สร้าง Future แค่ครั้งเดียว
      _imageFuture = DefaultCacheManager()
          .getSingleFile(widget.url)
          .timeout(const Duration(seconds: 10)); // เพิ่ม timeout
    }
  }

  @override
  void didUpdateWidget(CacheImageContentShop oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print('remove from didUpdate');
    // ถ้า URL เปลี่ยน ให้ลบรูปเก่าและโหลดใหม่
    if (oldWidget.url != widget.url) {
      if (oldWidget.url.isNotEmpty) {
        //DefaultCacheManager().removeFile(oldWidget.url);
        //print('🗑️ Removed old image: ${oldWidget.url}');
      }
      _loadImage();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    //print('remove from dispose');
    // 🔥 สำคัญที่สุด: ลบรูปออกจาก cache เมื่อ dispose
    if (widget.url.isNotEmpty) {
      //DefaultCacheManager().removeFile(widget.url);
      //print('🗑️ CacheImageProducts disposed: ${widget.url}');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // สำคัญสำหรับ AutomaticKeepAliveClientMixin

    if (widget.url.isEmpty || _disposed) {
      return const SizedBox();
    }

    return FutureBuilder<File>(
      future: _imageFuture, // ใช้ Future ที่สร้างไว้แล้ว
      builder: (context, snapshot) {
        // ตรวจสอบว่า widget ยัง mount อยู่หรือไม่
        if (_disposed || !mounted) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // แสดง loading placeholder
          return const SizedBox();
        }

        if (snapshot.hasError) {
          // ถ้า error ให้ลบออกจาก cache
          //DefaultCacheManager().removeFile(widget.url);
          return SizedBox(
            width: Get.width,
            height: widget.height ?? 176,
            child: Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey.shade200,
              size: 50,
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            fit: widget.fit,
            snapshot.data!,
            width: Get.width,
            cacheWidth: Get.width.toInt() + 440,
            errorBuilder: (context, error, stackTrace) {
              // ถ้า error ในการแสดงรูป ให้ลบออกจาก cache
              //DefaultCacheManager().removeFile(widget.url);
              return SizedBox(
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade200,
                  size: 50,
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CacheImageBannerShop extends StatefulWidget {
  final String url;
  final double? height;

  const CacheImageBannerShop({super.key, required this.url, this.height});

  @override
  State<CacheImageBannerShop> createState() => _CacheImageBannerShopState();
}

class _CacheImageBannerShopState extends State<CacheImageBannerShop>
    with AutomaticKeepAliveClientMixin {
  // 🔥 สำคัญ: ไม่เก็บ state เมื่อออกจาก viewport
  @override
  bool get wantKeepAlive => false;

  // ตัวแปรสำหรับเก็บ Future และติดตาม state
  Future<File>? _imageFuture;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    //print('📸 CacheImageBannerShop created: ${widget.url}');
  }

  void _loadImage() {
    if (widget.url.isNotEmpty && !_disposed) {
      // 🔥 สร้าง Future แค่ครั้งเดียว
      _imageFuture = DefaultCacheManager()
          .getSingleFile(widget.url)
          .timeout(const Duration(seconds: 10)); // เพิ่ม timeout
    }
  }

  @override
  void didUpdateWidget(CacheImageBannerShop oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print('remove from didUpdate');
    // ถ้า URL เปลี่ยน ให้ลบรูปเก่าและโหลดใหม่
    if (oldWidget.url != widget.url) {
      if (oldWidget.url.isNotEmpty) {
        //DefaultCacheManager().removeFile(oldWidget.url);
        //print('🗑️ Removed old image: ${oldWidget.url}');
      }
      _loadImage();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    //print('remove from dispose');
    // 🔥 สำคัญที่สุด: ลบรูปออกจาก cache เมื่อ dispose
    if (widget.url.isNotEmpty) {
      //DefaultCacheManager().removeFile(widget.url);
      //print('🗑️ CacheImageProducts disposed: ${widget.url}');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // สำคัญสำหรับ AutomaticKeepAliveClientMixin

    if (widget.url.isEmpty || _disposed) {
      return const SizedBox();
    }

    return FutureBuilder<File>(
      future: _imageFuture, // ใช้ Future ที่สร้างไว้แล้ว
      builder: (context, snapshot) {
        // ตรวจสอบว่า widget ยัง mount อยู่หรือไม่
        if (_disposed || !mounted) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // แสดง loading placeholder
          return const SizedBox();
        }

        if (snapshot.hasError) {
          // ถ้า error ให้ลบออกจาก cache
          //DefaultCacheManager().removeFile(widget.url);
          return SizedBox(
            width: Get.width,
            height: widget.height ?? 176,
            child: Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey.shade200,
              size: 50,
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            width: Get.width,
            cacheWidth: Get.width.toInt() + 120,
            errorBuilder: (context, error, stackTrace) {
              // ถ้า error ในการแสดงรูป ให้ลบออกจาก cache
              //DefaultCacheManager().removeFile(widget.url);
              return SizedBox(
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade200,
                  size: 50,
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

// ปรับปรุง CacheImageLoadMore
class CacheImageProducts extends StatefulWidget {
  final String url;
  final double? height;
  final bool? setHeight;

  const CacheImageProducts(
      {super.key, required this.url, this.height, this.setHeight});

  @override
  State<CacheImageProducts> createState() => _CacheImageProductsState();
}

class _CacheImageProductsState extends State<CacheImageProducts>
    with AutomaticKeepAliveClientMixin {
  // 🔥 สำคัญ: ไม่เก็บ state เมื่อออกจาก viewport
  @override
  bool get wantKeepAlive => false;

  // ตัวแปรสำหรับเก็บ Future และติดตาม state
  Future<File>? _imageFuture;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    //print('📸 CacheImageProducts created: ${widget.url}');
  }

  void _loadImage() {
    if (widget.url.isNotEmpty && !_disposed) {
      // 🔥 สร้าง Future แค่ครั้งเดียว
      _imageFuture = DefaultCacheManager()
          .getSingleFile(widget.url)
          .timeout(const Duration(seconds: 10)); // เพิ่ม timeout
    }
  }

  @override
  void didUpdateWidget(CacheImageProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print('remove from didUpdateWidget');
    // ถ้า URL เปลี่ยน ให้ลบรูปเก่าและโหลดใหม่
    if (oldWidget.url != widget.url) {
      if (oldWidget.url.isNotEmpty) {
        // //DefaultCacheManager().removeFile(oldWidget.url);
        //print('🗑️ Removed old image: ${oldWidget.url}');
      }
      _loadImage();
    }
  }

  @override
  void dispose() {
    //print('remove from dispose');
    _disposed = true;

    // 🔥 สำคัญที่สุด: ลบรูปออกจาก cache เมื่อ dispose
    if (widget.url.isNotEmpty) {
      //DefaultCacheManager().removeFile(widget.url);
      //print('🗑️ CacheImageProducts disposed: ${widget.url}');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // สำคัญสำหรับ AutomaticKeepAliveClientMixin

    if (widget.url.isEmpty || _disposed) {
      return const SizedBox();
    }

    return FutureBuilder<File>(
      future: _imageFuture, // ใช้ Future ที่สร้างไว้แล้ว
      builder: (context, snapshot) {
        // ตรวจสอบว่า widget ยัง mount อยู่หรือไม่
        if (_disposed || !mounted) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // แสดง loading placeholder
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: widget.height ?? 176,
                width: Get.width,
              ),
              Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: Colors.grey.shade100,
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          // ถ้า error ให้ลบออกจาก cache
          //DefaultCacheManager().removeFile(widget.url);
          return SizedBox(
            width: Get.width,
            height: widget.height ?? 176,
            child: Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey.shade200,
              size: 50,
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            width: double.infinity,
            // height: widget.height ?? 176,
            height: widget.setHeight != null ? null : (widget.height ?? 176),
            fit: BoxFit.cover,
            cacheWidth: 300,
            cacheHeight: 300,
            errorBuilder: (context, error, stackTrace) {
              // ถ้า error ในการแสดงรูป ให้ลบออกจาก cache
              //DefaultCacheManager().removeFile(widget.url);
              return SizedBox(
                width: Get.width,
                height: widget.height ?? 176,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade200,
                  size: 50,
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

// ปรับปรุง CacheImageBannerB2C
class CacheImageBannerB2C extends StatefulWidget {
  final String url;
  const CacheImageBannerB2C({super.key, required this.url});

  @override
  State<CacheImageBannerB2C> createState() => _CacheImageBannerB2CState();
}

class _CacheImageBannerB2CState extends State<CacheImageBannerB2C>
    with AutomaticKeepAliveClientMixin {
  // 🔥 สำคัญ: ไม่เก็บ state เมื่อออกจาก viewport
  @override
  bool get wantKeepAlive => false;

  // ตัวแปรสำหรับเก็บ Future และติดตาม state
  Future<File>? _imageFuture;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    //print('📸 CacheImageProducts created: ${widget.url}');
  }

  void _loadImage() {
    if (widget.url.isNotEmpty && !_disposed) {
      // 🔥 สร้าง Future แค่ครั้งเดียว
      _imageFuture = DefaultCacheManager()
          .getSingleFile(widget.url)
          .timeout(const Duration(seconds: 10)); // เพิ่ม timeout
    }
  }

  @override
  void didUpdateWidget(CacheImageBannerB2C oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ถ้า URL เปลี่ยน ให้ลบรูปเก่าและโหลดใหม่
    if (oldWidget.url != widget.url) {
      if (oldWidget.url.isNotEmpty) {
        //DefaultCacheManager().removeFile(oldWidget.url);
        //print('🗑️ Removed old image: ${oldWidget.url}');
      }
      _loadImage();
    }
  }

  @override
  void dispose() {
    _disposed = true;

    // 🔥 สำคัญที่สุด: ลบรูปออกจาก cache เมื่อ dispose
    if (widget.url.isNotEmpty) {
      //DefaultCacheManager().removeFile(widget.url);
      //print('🗑️ CacheImageProducts disposed: ${widget.url}');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.url.isEmpty || _disposed) {
      return const SizedBox();
    }

    return FutureBuilder<File>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            'assets/images/b2c/logo/friday_online_loading.png',
            scale: 6,
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade400,
                ),
              );
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: child,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

// ปรับปรุง CacheImageLogoShop
class CacheImageLogoShop extends StatefulWidget {
  final String url;
  const CacheImageLogoShop({super.key, required this.url});

  @override
  State<CacheImageLogoShop> createState() => _CacheImageLogoShopState();
}

class _CacheImageLogoShopState extends State<CacheImageLogoShop> {
  Future<File>? _imageFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
    }
  }

  @override
  void didUpdateWidget(CacheImageLogoShop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      if (widget.url.isNotEmpty) {
        _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
      } else {
        _imageFuture = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return Container();
    }

    return FutureBuilder<File>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            fit: BoxFit.contain,
            cacheHeight: 100,
            snapshot.data!,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.store,
                color: Colors.grey.shade400,
                size: 16,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

// ปรับปรุง CacheImageOverlay
class CacheImageOverlay extends StatefulWidget {
  final String url;
  const CacheImageOverlay({super.key, required this.url});

  @override
  State<CacheImageOverlay> createState() => _CacheImageOverlayState();
}

class _CacheImageOverlayState extends State<CacheImageOverlay> {
  Future<File>? _imageFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
    }
  }

  @override
  void didUpdateWidget(CacheImageOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      if (widget.url.isNotEmpty) {
        _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
      } else {
        _imageFuture = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return Container();
    }

    return FutureBuilder<File>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}

// Custom Cache Manager ที่ปรับแต่งสำหรับ Memory Management
class OptimizedCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'optimizedCache';

  static OptimizedCacheManager? _instance;

  factory OptimizedCacheManager() {
    _instance ??= OptimizedCacheManager._();
    return _instance!;
  }

  OptimizedCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 200, // จำกัดจำนวน cache objects
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
        );
}

// favorite
class CacheFavoriteIcons extends StatefulWidget {
  final String url;
  const CacheFavoriteIcons({super.key, required this.url});

  @override
  State<CacheFavoriteIcons> createState() => _CacheFavoriteIconsState();
}

class _CacheFavoriteIconsState extends State<CacheFavoriteIcons> {
  Future<File>? _imageFuture;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
    }
  }

  @override
  void didUpdateWidget(CacheFavoriteIcons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      if (widget.url.isNotEmpty) {
        _imageFuture = DefaultCacheManager().getSingleFile(widget.url);
      } else {
        _imageFuture = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return const SizedBox();
    }
    return FutureBuilder<File>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            'assets/images/b2c/logo/friday_online_loading.png',
            width: 40,
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            fit: BoxFit.contain,
            width: 40,
            height: 40,
            cacheWidth: 120,
            cacheHeight: 120,
            snapshot.data!,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.store,
                color: Colors.grey.shade400,
                size: 16,
              );
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: child,
              );
            },
          );
        }
        return Image.asset(
          'assets/images/b2c/logo/friday_online_loading.png',
          width: 40,
        );
      },
    );
  }
}
