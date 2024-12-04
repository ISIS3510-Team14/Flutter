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

    // Extract and normalize the distinct dates
    Set distinctDates = history.map((entry) => entry['date']).toSet();

    // Count the number of unique dates
    return distinctDates.length;
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
        List<User> filtered = [];
        String lowercaseQuery = query.toLowerCase();
        
        // Bucle indexado en lugar de where
        for (int i = 0; i < users.length; i++) {
          if (users[i].name.toLowerCase().contains(lowercaseQuery)) {
            filtered.add(users[i]);
          }
        }
        filteredUsers = filtered;
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
                    child: HeaderWidget(),
                  ),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: SustainUColors.limeGreen),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Scoreboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: SustainUColors.text,
                      ),
                    ),
                  ),
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
                      onChanged: _filterUsers,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (isLoading)
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filteredUsers.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  searchQuery.isEmpty ? 'No users found' : 'No results for "$searchQuery"',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final user = filteredUsers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
                  childCount: filteredUsers.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
