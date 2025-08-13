import 'package:appfridayecommerce/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  static Future<void> init() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

// Event click handler
  static void sendAnalyticsEvent(eventName, repCode, repSeq, repType) async {
    // print(eventName);
    return _instance.logEvent(
      name: eventName,
      parameters: {
        'rep_code': repCode,
        'rep_seq': repSeq,
        'rep_type': repType,
      },
    );
  }

  // Event click bwpoint
  static void sendAnalyticsEventBWpoint(
      eventName, categoryName, repCode, repSeq, repType) async {
    return _instance.logEvent(
      name: eventName,
      parameters: {
        'category_name': categoryName,
        'rep_code': repCode,
        'rep_seq': repSeq,
        'rep_type': repType,
      },
    );
  }

// Event click enduser
  static void sendAnalyticsEventEndUser(
      eventName, userId, repCode, repSeq, repType) async {
    return _instance.logEvent(
      name: eventName,
      parameters: {
        'user_id': userId,
        'rep_code': repCode,
        'rep_seq': repSeq,
        'rep_type': repType,
      },
    );
  }

  static void sendAnalyticsMemberProject(
      eventName, pCode, pName, repCode, repSeq, repType) async {
    // print(eventName);
    return _instance.logEvent(
      name: eventName,
      parameters: {
        'project_code': pCode,
        'project_name': pName,
        'rep_code': repCode,
        'rep_seq': repSeq,
        'rep_type': repType,
      },
    );
  }

  static void sendAnalyticsEventCategory(
      eventName, cateId, repCode, repSeq, repType) async {
    // print(eventName);
    return _instance.logEvent(
      name: eventName,
      parameters: {
        'category_id': cateId,
        'rep_code': repCode,
        'rep_seq': repSeq,
        'rep_type': repType,
      },
    );
  }

  static void addItemToCart(String itemId, int cost) async {
    return _instance.logAddToCart(
      items: [
        AnalyticsEventItem(itemId: itemId, price: cost),
      ],
    );
  }
}
