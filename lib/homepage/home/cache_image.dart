import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../theme/themeimage_menu.dart';
// import '../theme/themeimage_menu.dart';

class CacheImageBanner extends StatelessWidget {
  final String url;
  const CacheImageBanner({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      var file = DefaultCacheManager().getSingleFile(url);
      return FutureBuilder<File>(
          future: file,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.file(snapshot.data!,
                  fit: BoxFit.fill,
                  // height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center);
            }
            return Container();
          });
    } else {
      print('Null image of Banner');
      return Container();
    }
  }
}

class CacheImageFavorite extends StatelessWidget {
  final String url;
  const CacheImageFavorite({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      var file = DefaultCacheManager().getSingleFile(url);
      return FutureBuilder<File>(
          future: file,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.file(
                snapshot.data!,
                height: 50,
              );
            }
            return Container();
          });
    } else {
      print('Null image of Favorite');
      return Container();
    }
  }
}

class CacheImagePromotion extends StatelessWidget {
  final String url;
  const CacheImagePromotion({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      var file = DefaultCacheManager().getSingleFile(url);
      return FutureBuilder<File>(
          future: file,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  snapshot.data!,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            }
            return Container();
          });
    } else {
      print('Null image of Promotion');
      return Container();
    }
  }
}

class CacheImageDiscount extends StatelessWidget {
  final String url;
  const CacheImageDiscount({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      var file = DefaultCacheManager().getSingleFile(url);
      return FutureBuilder<File>(
          future: file,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  snapshot.data!,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            }
            return Container();
          });
    } else {
      print('Null image of CacheImageDiscount');
      return Container();
    }
  }
}

class CacheImageProduct extends StatelessWidget {
  final String url;

  const CacheImageProduct({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      // var file = setCacheImage(url);
      return FutureBuilder<File>(
          future: DefaultCacheManager().getSingleFile(url),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Image.file(snapshot.data!);
              return FadeInImage(
                image: FileImage(snapshot.data!),
                placeholderFilterQuality: FilterQuality.low,
                placeholder: const AssetImage(imageError),
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Image(
                    image: AssetImage(imageError),
                  );
                },
              );
            }
            return Container();
          });
    } else {
      print('Null image of Discount');
      return Container();
    }
  }
}

class CacheImagePrice extends StatelessWidget {
  final String url;
  final String flagNetPrice;
  const CacheImagePrice(
      {Key? key, required this.url, required this.flagNetPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var file = DefaultCacheManager().getSingleFile(url);
    return FutureBuilder<File>(
        future: file,
        builder: (context, snapshot) {
          // print(snapshot.data!.path);
          if (snapshot.hasData) {
            return Image.file(snapshot.data!,
                height: (flagNetPrice == 'Y') ? 60 : 0);
          }
          return Container();
        });
  }
}

class CacheImageAppend extends StatelessWidget {
  final String url;
  final bool flagInstock;
  const CacheImageAppend(
      {Key? key, required this.url, required this.flagInstock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var file = DefaultCacheManager().getSingleFile(url);
    return FutureBuilder<File>(
        future: file,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(snapshot.data!,
                cacheWidth: 80,
                cacheHeight: 80,
                scale: 0.1,
                height: (flagInstock == false) ? 80 : 0);
          }
          return Container();
        });
  }
}

class CacheImageMarket extends StatelessWidget {
  final String url;
  const CacheImageMarket({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var file = DefaultCacheManager().getSingleFile(url);
    return FutureBuilder<File>(
        future: file,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(snapshot.data!, fit: BoxFit.cover);
          }
          return Container();
        });
  }
}

// product details
class CacheImageNetPriceDetails extends StatelessWidget {
  final String url;
  final bool flagNetPrice;
  const CacheImageNetPriceDetails(
      {Key? key, required this.url, required this.flagNetPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var file = DefaultCacheManager().getSingleFile(url);
    return FutureBuilder<File>(
        future: file,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (flagNetPrice) {
              return Image.file(snapshot.data!, height: 80);
            } else {
              return const SizedBox();
            }
          }
          return const SizedBox();
        });
  }
}

class CacheImageAppendDetails extends StatelessWidget {
  final String url;
  final bool flagInstock;
  const CacheImageAppendDetails(
      {Key? key, required this.url, required this.flagInstock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var file = DefaultCacheManager().getSingleFile(url);
    return FutureBuilder<File>(
        future: file,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(snapshot.data!, height: (!flagInstock) ? 120 : 0);
          }
          return Container();
        });
  }
}

class CacheImageCart extends StatelessWidget {
  final String url;
  const CacheImageCart({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      var file = DefaultCacheManager().getSingleFile(url);
      return FutureBuilder<File>(
          future: file,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.file(snapshot.data!,
                  alignment: Alignment.center, height: 75);
            }
            return const SizedBox();
          });
    } else {
      return Container();
    }
  }
}
