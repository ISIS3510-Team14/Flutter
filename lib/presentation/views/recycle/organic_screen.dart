import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/sustainu_colors.dart';
import '../../widgets/head.dart';
import '../../widgets/bottom_navbar.dart';
import 'package:sustain_u/main.dart';

class OrganicScreen extends StatefulWidget {
  @override
  _OrganicScreenState createState() => _OrganicScreenState();
}

class _OrganicScreenState extends State<OrganicScreen> with RouteAware {
  late int _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    print("Este es el tiempo de inicio $_startTime");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    print("Route observer suscrito!");
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    print("Route observer desuscrito!");
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int duration = ((endTime - _startTime) / 1000).round();
    print("Este es el tiempo de duracion $duration");
    logScreenTimeToFirestore(duration, 'organic'); // Log the time to Firestore
    super.dispose();
  }

  Future<void> logScreenTimeToFirestore(int durationSeconds, String screenName) async {
    try {
      print("Logging screen time to Firestore...");
      CollectionReference trashTypes = FirebaseFirestore.instance.collection('trash_screen_times');
      await trashTypes.add({
        'time_spent': durationSeconds,
        'trash_type': screenName,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print("Error logging screen time to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),

            HeaderWidget(),
            
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Organic',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SustainUColors.text,
                  ),
                ),
                SizedBox(width: 5),
                Image.asset(
                  'assets/organic.png',
                  height: 30,
                  width: 30,
                ),
              ],
            ),
            
            SizedBox(height: 20),

            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Organic waste decomposes naturally, reducing landfill waste.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: SustainUColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Organic is most of the time thrown in the green trash can',
                    style: TextStyle(
                      fontSize: 16,
                      color: SustainUColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 16),
                Image.asset(
                  'assets/trash_green.png',
                  height: 100,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Additional Information
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Includes food scraps, fruit peels, coffee grounds, yard trimmings, and other biodegradable materials.',
                  style: TextStyle(
                    fontSize: 16,
                    color: SustainUColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
