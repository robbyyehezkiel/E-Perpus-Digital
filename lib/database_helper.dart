import 'package:e_perpus_app/data/member.dart';
import 'package:e_perpus_app/data/order.dart';
import 'package:e_perpus_app/data/user.dart';
import 'package:e_perpus_app/data/worker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:e_perpus_app/data/book.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'your_database_name.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idBook TEXT,
            title TEXT,
            category TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Members (
            nim TEXT,
            name TEXT,
            handphone TEXT,
            classField TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Workers (
            nip TEXT,
            name TEXT,
            handphone TEXT,
            address TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Orders (
            orderId INTEGER PRIMARY KEY AUTOINCREMENT,
            memberNIM TEXT,
            workerNIP TEXT,
            bookId TEXT,
            orderTime TEXT,
            returnTime TEXT
          )
        ''');
      },
    );
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Books');
    return List.generate(maps.length, (i) {
      return Book(
        idBook: maps[i]['idBook'],
        title: maps[i]['title'],
        category: maps[i]['category'],
      );
    });
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db!.insert('Books', book.toMap());
  }

  Future<bool> isDuplicateId(String idBook) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db!
        .rawQuery('SELECT COUNT(*) FROM Books WHERE idBook = ?', [idBook]));
    return count! > 0;
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db!.update(
      'Books',
      book.toMap(),
      where: 'idBook = ?',
      whereArgs: [book.idBook],
    );
  }

  Future<int> deleteBook(String idBook) async {
    final db = await database;
    return await db!.delete(
      'Books',
      where: 'idBook = ?',
      whereArgs: [idBook],
    );
  }

  Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Members');
    return List.generate(maps.length, (i) {
      return Member(
        nim: maps[i]['nim'],
        name: maps[i]['name'],
        handphone: maps[i]['handphone'],
        classField: maps[i]['classField'],
      );
    });
  }

  Future<int> insertMember(Member member) async {
    final db = await database;
    return await db!.insert('Members', member.toMap());
  }

  Future<bool> isDuplicateMemberId(String nim) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db!
        .rawQuery('SELECT COUNT(*) FROM Members WHERE nim = ?', [nim]));
    return count! > 0;
  }

  Future<int> updateMember(Member member) async {
    final db = await database;
    return await db!.update(
      'Members',
      member.toMap(),
      where: 'nim = ?',
      whereArgs: [member.nim],
    );
  }

  Future<int> deleteMember(String nim) async {
    final db = await database;
    return await db!.delete(
      'Members',
      where: 'nim = ?',
      whereArgs: [nim],
    );
  }

  Future<List<Worker>> getWorkers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Workers');
    return List.generate(maps.length, (i) {
      return Worker(
        nip: maps[i]['nip'],
        name: maps[i]['name'],
        handphone: maps[i]['handphone'],
        address: maps[i]['address'],
      );
    });
  }

  Future<int> insertWorker(Worker worker) async {
    final db = await database;
    return await db!.insert('Workers', worker.toMap());
  }

  Future<bool> isDuplicateNipWorker(String nip) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db!
        .rawQuery('SELECT COUNT(*) FROM Workers WHERE nip = ?', [nip]));
    return count! > 0;
  }

  Future<int> updateWorker(Worker worker) async {
    final db = await database;
    return await db!.update(
      'Workers',
      worker.toMap(),
      where: 'nip = ?',
      whereArgs: [worker.nip],
    );
  }

  Future<int> deleteWorker(String nip) async {
    final db = await database;
    return await db!.delete(
      'Workers',
      where: 'nip = ?',
      whereArgs: [nip],
    );
  }

  Future<int> insertOrder(Order order) async {
    final db = await database;
    return await db!.insert('Orders', order.toMap());
  }

  Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Orders');
    return List.generate(maps.length, (i) {
      return Order(
        orderId: maps[i]['orderId'],
        memberNIM: maps[i]['memberNIM'],
        workerNIP: maps[i]['workerNIP'],
        bookId: maps[i]['bookId'],
        orderTime: DateTime.parse(maps[i]['orderTime']),
        returnTime: DateTime.parse(maps[i]['returnTime']),
      );
    });
  }

  Future<int> deleteOrder(int? orderId) async {
    final db = await database;
    return await db!.delete(
      'Orders',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  Future<String?> getMemberNameByNIM(String? memberNIM) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Members',
      where: 'nim = ?',
      whereArgs: [memberNIM],
    );

    if (maps.isNotEmpty) {
      return maps[0]['name'];
    }

    return null;
  }

  Future<String?> getWorkerNameByNIP(String? workerNIP) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Workers',
      where: 'nip = ?',
      whereArgs: [workerNIP],
    );

    if (maps.isNotEmpty) {
      return maps[0]['name'];
    }

    return null;
  }

  Future<String?> getBookTitleById(String? bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Books',
      where: 'idBook = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return maps[0]['title'];
    }

    return null;
  }

  Future<void> seedMembers() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM Members'));

    if (count == 0) {
      final batch = db.batch();

      final member1 = Member(
        nim: '24001',
        name: 'Taylor Swift',
        handphone: '082516275304',
        classField: 'Class A',
      );

      final member2 = Member(
        nim: '24002',
        name: 'Fuadi Yakas',
        handphone: '082516218331',
        classField: 'Class B',
      );

      final member3 = Member(
        nim: '24003',
        name: 'Magnus Carlsen',
        handphone: '082516212992',
        classField: 'Class C',
      );

      batch.insert('Members', member1.toMap());
      batch.insert('Members', member2.toMap());
      batch.insert('Members', member3.toMap());

      await batch.commit(noResult: true);
    }
  }

  Future<void> seedWorkers() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM Workers'));

    if (count == 0) {
      final batch = db.batch();

      final worker1 = Worker(
        nip: '24001',
        name: 'Jisooya',
        handphone: '082902012452',
        address: 'Pondok Permai Blok Ac 21',
      );

      final worker2 = Worker(
        nip: '24002',
        name: 'Jennie Rubie Jane',
        handphone: '082517332452',
        address: 'Valencia Mendalo Barat',
      );

      final worker3 = Worker(
        nip: '24003',
        name: 'Cristiano Ronaldo',
        handphone: '082516212452',
        address: 'Simpang Rimbo',
      );

      batch.insert('Workers', worker1.toMap());
      batch.insert('Workers', worker2.toMap());
      batch.insert('Workers', worker3.toMap());

      await batch.commit(noResult: true);
    }
  }

  Future<void> seedBook() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM Books'));

    if (count == 0) {
      final batch = db.batch();

      final book1 = Book(
        idBook: '35701',
        title: 'Dilan',
        category: 'Lover',
      );

      final book2 = Book(
        idBook: '35702',
        title: 'La La Land',
        category: 'Comedy',
      );

      final book3 = Book(
        idBook: '35703',
        title: 'House Of The Dragon',
        category: 'Horror',
      );

      batch.insert('Books', book1.toMap());
      batch.insert('Books', book2.toMap());
      batch.insert('Books', book3.toMap());

      await batch.commit(noResult: true);
    }
  }

  Future<void> seedEmail() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM Users'));

    if (count == 0) {
      final batch = db.batch();

      final userDefault = User(
        id: 1,
        email: 'email@gmail.com',
        password: 'email123',
      );

      batch.insert('Users', userDefault.toMap());

      await batch.commit(noResult: true);
    }
  }
}
