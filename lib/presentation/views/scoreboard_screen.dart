import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class User {
  final String name;
  final int points;
  final int days;

  User({
    required this.name,
    required this.points,
    required this.days,
  });

  static int _calculateStreakDays(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return 0;

    int streak = 1;
    if (history.last['date'].toString().split('-').length != 3) return 0;
    DateTime lastDate = DateTime.parse(history.last['date']);

    for (int i = history.length - 2; i >= 0; i--) {
      if (history[i]['date'].toString().split('-').length != 3) continue;
      DateTime currentDate = DateTime.parse(history[i]['date']);

      if (currentDate.isBefore(lastDate.subtract(Duration(days: 1)))) {
        break;
      } else if (currentDate
          .isAtSameMomentAs(lastDate.subtract(Duration(days: 1)))) {
        streak++;
      }
      lastDate = currentDate;
    }
    return streak;
  }

  factory User.fromFirestore(Map<String, dynamic> data) {
    final points = data['points'] ?? {};
    final history = List<Map<String, dynamic>>.from(points['history'] ?? []);
    return User(
      name: data['user_id']?.replaceAll('@uniandes.edu.co', '') ?? 'Usuario',
      points: (points['total'] ?? 0) as int,
      days: (_calculateStreakDays(history)),
    );
  }
}


class ScoreboardScreen extends StatefulWidget {
  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;
  String searchQuery = '';
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _loadUsers();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnection();
    });
  }

  // Método para filtrar usuarios
  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users
            .where((user) =>
                user.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
    });
  }

  Future<void> _loadUsers() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('points.total', descending: true)
                  .get(GetOptions(source: Source.cache));
      print("cargando usuario desde cache");
      if (_isConnected)
      {
        querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('points.total', descending: true)
                  .get(GetOptions(source: Source.server));
        print("cargando usuario desde server");
      }

      final loadedUsers = querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data()))
          .toList();

      setState(() {
        users = loadedUsers;
        filteredUsers = loadedUsers; // Inicialmente muestra todos
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando usuarios: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              child: HeaderWidget(),
            ),
            SizedBox(height: 20),

            // Title
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
                  'Scoreboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: SustainUColors.text,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: SustainUColors.limeGreen),
                  hintText: "Enter a name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SustainUColors.limeGreen),
                  ),
                ),
                onChanged: _filterUsers, // Añadir onChanged
              ),
            ),
            SizedBox(height: 10),

            // Scoreboard List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredUsers.isEmpty
                      ? Center(
                          child: Text(
                            searchQuery.isEmpty
                                ? 'No users found'
                                : 'No results for "$searchQuery"',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: SustainUColors.limeGreen,
                                    backgroundImage: NetworkImage('https://picsum.photos/seed/${user.name}/${100}'),
                                  ),
                                  title: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: SustainUColors.text,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${user.days} Days',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: SustainUColors.text.withOpacity(0.6),
                                    ),
                                  ),
                                  trailing: Text(
                                    '${user.points} Points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: SustainUColors.limeGreen,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
