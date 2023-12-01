import 'package:e_perpus_app/database_helper.dart';

class User {
  final int? id; // Make the 'id' field optional

  final String email;
  final String password;

  User({this.id, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Pass 'id' as well, which can be null for registration
      'email': email,
      'password': password,
    };
  }
}

class UserRepository {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insertUser(User user) async {
    final db = await databaseHelper.database;
    return await db!.insert('Users', user.toMap());
  }

  Future<bool> doesUserExist(String email) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return maps
        .isNotEmpty; // Return true if user with the given email exists, false otherwise
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        email: maps[0]['email'],
        password: maps[0]['password'],
      );
    }
    return null;
  }
}

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  User? _currentUser;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<void> login(User user) async {
    // You can add any additional logic here, such as saving the user to a local storage (e.g., SharedPreferences).
    _currentUser = user;
  }

  Future<void> logout() async {
    // Clear the current user and any stored user data.
    _currentUser = null;
    // You can also clear data from local storage here.
  }
}
