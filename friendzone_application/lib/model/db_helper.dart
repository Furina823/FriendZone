import 'package:mysql1/mysql1.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  final _settings = ConnectionSettings(
    host: '10.0.2.2',
    port: 3306,
    user: 'root',
    db: 'friendzone',
  );

  Future<MySqlConnection> _getConnection() async {
    try {
      final conn = await MySqlConnection.connect(_settings);
      print('Database connected successfully');
      return conn;
    } catch (e) {
      print('Error connecting to database: $e');
      rethrow;
    }
  }

  Future<List<String>> getSchools() async {
    final conn = await _getConnection();
    try {
      final results = await conn.query('SELECT school FROM user');
      Set<String> schoolsSet = {};

      for (var row in results) {
        var school = row['school'];

        // Check if school is null and skip it if so
        if (school == null) {
          continue;
        }

        if (school is Blob) {
          // Convert Blob to String
          school = school.toString();
        }

        // Add to Set to remove duplicates and ignore blank values
        String schoolString = school.toString().trim();
        if (schoolString.isNotEmpty) {
          schoolsSet.add(schoolString);
        }
      }

      List<String> schools = schoolsSet.toList(); // Convert Set to List

      // Return an empty list if no schools are found
      if (schools.isEmpty) {
        print('No schools found');
      } else {
        print('Schools fetched: $schools');
      }

      return schools;
    } catch (e) {
      print('Error fetching schools: $e');
      return []; // Return an empty list on error
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, dynamic>>> getFilteredEvents() async {
    final conn = await _getConnection();
    try {
      print('Executing fixed query for status: upcoming');
      final results = await conn.query('''
        SELECT event.*, business.industry 
        FROM event 
        JOIN business ON event.business_id = business.business_id 
        WHERE event.status = ?
        ''', ['upcoming'] // Fixed value for testing
          );

      List<Map<String, dynamic>> events = [];
      for (var row in results) {
        var event = row.fields;
        // Convert Blob fields to String if necessary
        event.forEach((key, value) {
          if (value is Blob) {
            event[key] = String.fromCharCodes(value.toBytes());
          }
        });
        events.add(event);
      }
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, dynamic>>> getFilteredUsers(String userId) async {
    final conn = await _getConnection();
    try {
      final results = await conn.query('''
      SELECT user.*
      FROM user
      JOIN friend ON user.user_id = friend.user_id_2
      WHERE friend.user_id = ?
      ''', [userId]);
      List<Map<String, dynamic>> friends = [];
      for (var row in results) {
        var user = row.fields;
        // Convert Blob fields to String if necessary
        user.forEach((key, value) {
          if (value is Blob) {
            user[key] = String.fromCharCodes(value.toBytes());
          }
        });
        friends.add(user);
      }
      return friends;
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    } finally {
      await conn.close();
    }
  }
}
