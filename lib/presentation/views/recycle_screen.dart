import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';

class RecycleScreen extends StatefulWidget {
  @override
  _RecycleScreenState createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  bool _isConnected = true;
  late Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  @override
  void dispose() {
    _connectivity.onConnectivityChanged.drain(); 
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool connected = result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;

    if (!connected && _isConnected) {
      _showNoInternetNotification(); 
    }

    setState(() {
      _isConnected = connected;
    });
  }

  void _showNoInternetNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            HeaderWidget(),
            SizedBox(height: 20),
            Text(
              'Residues:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildCategoryButton(
                  'Paper',
                  'assets/paper.png',
                  'Boxes, magazines, notepads',
                ),
                _buildCategoryButton(
                  'Plastic',
                  'assets/plastic.png',
                  'Packages, PET, bottles',
                ),
                _buildCategoryButton(
                  'Glass',
                  'assets/glass.png',
                  'Bottles, containers',
                ),
                _buildCategoryButton(
                  'Metal',
                  'assets/metal.png',
                  'Cans, utensils',
                ),
              ],
            ),
            SizedBox(height: 20),
            _isConnected ? _buildMoreInfoSection() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, String icon, String subLabel) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: SustainUColors.text,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/$label'.toLowerCase());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 60,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subLabel,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'More Information:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SustainUColors.text,
                  ),
                ),
              ),
              SizedBox(height: 15),
              _buildLinkButton(
                'How to Recycle - How2Recycle',
                'https://how2recycle.info/',
              ),
              _buildLinkButton(
                'EPA: How to Recycle Common Recyclables',
                'https://www.epa.gov/recycle/how-do-i-recycle-common-recyclables',
              ),
              _buildLinkButton(
                'Earth Day: 7 Tips to Recycle Better',
                'https://www.earthday.org/7-tips-to-recycle-better/',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkButton(String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => _launchURL(url),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
