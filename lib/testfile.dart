import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClickLimitScreen extends StatefulWidget {
  @override
  _ClickLimitScreenState createState() => _ClickLimitScreenState();
}

class _ClickLimitScreenState extends State<ClickLimitScreen> {
  int dailyClickCount = 0;
  bool paidSubscription = false; // Initially, the user doesn't have a paid subscription

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String getUserId() => auth.currentUser?.uid ?? 'unknown';

  Future<void> getDailyClickCount() async {
    final userId = getUserId();
    final userDoc = firestore.collection('clickCounts').doc(userId);
    final userData = await userDoc.get();

    if (userData.exists) {
      final data = userData.data() as Map<String, dynamic>;
      final lastUpdated = data['lastUpdated'] as Timestamp;
      final count = data['count'] as int;
      final subscription = data['paidSubscription'] as bool;

      final now = DateTime.now();
      if (lastUpdated.toDate().day != now.day) {
        // Reset the count for a new day
        await userDoc.set({
          'lastUpdated': Timestamp.now(),
          'count': 0,
          'paidSubscription': subscription,
        });
        setState(() {
          dailyClickCount = 0;
          paidSubscription = subscription;
        });
      } else {
        setState(() {
          dailyClickCount = count;
          paidSubscription = subscription;
        });
      }
    } else {
      // Initialize the count and paidSubscription for a new user
      await userDoc.set({
        'lastUpdated': Timestamp.now(),
        'count': 0,
        'paidSubscription': paidSubscription,
      });
    }
  }

  void incrementClickCount() {
    if (paidSubscription) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Premium User'),
          content: Text('You have a paid subscription with unlimited clicks.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (dailyClickCount < 5) {
        setState(() => dailyClickCount++);
        final userId = getUserId();
        final userDoc = firestore.collection('clickCounts').doc(userId);
        userDoc.set({
          'lastUpdated': Timestamp.now(),
          'count': dailyClickCount,
          'paidSubscription': paidSubscription,
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Click Limit Exceeded'),
            content: Text('You have exceeded the daily click limit.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDailyClickCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Click Limit App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!paidSubscription)
              Text('Daily Click Count: $dailyClickCount'),
            ElevatedButton(
              onPressed: incrementClickCount,
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
