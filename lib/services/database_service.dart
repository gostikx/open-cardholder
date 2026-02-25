import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_cardholder/models/card_model.dart';

class DatabaseService {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = Isar.open(directory: dir.path, schemas: [CardModelSchema]);
  }

  static Isar get instance => _isar;

  static Future<void> close() async {
    _isar.close();
  }
}
