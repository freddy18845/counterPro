// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Returns the subscription end date if:
///   - internet is available
///   - company document exists
///   - subscriptionEndDate field exists and is valid
///
///
class OnlineChecker {
/// Returns null in all other cases (no internet, no doc, error, missing field, etc.)
Future<DateTime?> getCompanySubscriptionEndDate(String companyId) async {
  try {
    // Step 1: Quick connectivity check
    final connectivityResult = await Connectivity().checkConnectivity();

    // On most platforms this is enough for a fast "probably online" check
    if (connectivityResult == ConnectivityResult.none) {
      return null; // definitely offline
    }

    // Optional: more strict check (especially useful on desktop/web)
    // You can skip this part if you want faster response
    final hasInternet = await _hasActualInternet();
    if (!hasInternet) {
      return null;
    }

    // // Step 2: Try to read from Firestore
    // final docRef = FirebaseFirestore.instance
    //     .collection('companies')
    //     .doc(companyId);
    //
    // final snapshot = await docRef.get();
    //
    // if (!snapshot.exists || snapshot.data() == null) {
    //   return null;
    // }
    //
    // final data = snapshot.data()!;
    //
    // // Assuming you store it as Timestamp in Firestore
    // final timestamp = data['subscriptionEndDate'] as Timestamp?;
    //
    // if (timestamp == null) {
    //   return null;
    // }

    //return timestamp.toDate();

  } catch (e) {
    // Network error, permission denied, timeout, etc.
    debugPrint('Error checking subscription: $e');
    return null;
  }
}

/// Lightweight real internet check (tries to reach a known reliable endpoint)
/// Returns true if we can actually reach the internet
Future<bool> _hasActualInternet() async {
  //try {
    // You can also use 'https://clients3.google.com/generate_204' or your own ping endpoint
    // final response = await FirebaseFirestore.instance
    //     .collection('_health') // dummy collection or use .doc('ping').get()
    //     .limit(1)
    //     .get(const GetOptions(source: Source.serverAndCache));

    //return response.metadata.isFromCache == false;

  // } catch (_) {
     return false;
  // }
}}