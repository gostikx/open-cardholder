import 'package:riverpod/riverpod.dart';
import 'package:open_cardholder/models/card_model.dart';
import 'package:open_cardholder/services/database_service.dart';
import 'package:isar/isar.dart';

final isarProvider = Provider<Isar>((ref) {
  return DatabaseService.instance;
});

final allCardsProvider = FutureProvider<List<CardModel>>((ref) async {
  final isar = ref.watch(isarProvider);
  return isar.cardModels.where().sortByTitle().findAll();
});

final addCardProvider = FutureProvider.autoDispose<void>((ref) async {
  // This will be used as a notifier
  throw UnimplementedError('Use addCardNotifier instead');
});

final addCardNotifierProvider = Provider<AddCardNotifier>((ref) {
  return AddCardNotifier(ref);
});

class AddCardNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AddCardNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> addCard({
    required String title,
    required String description,
    String? logo,
  }) async {
    state = const AsyncValue.loading();

    try {
      final isar = ref.read(isarProvider);

      final card = CardModel(
        id: isar.cardModels.autoIncrement(),
        title: title,
        description: description,
        logo: logo,
      );

      await isar.writeAsync((isar) {
        isar.cardModels.put(card);
      });

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

final deleteCardProvider = FutureProvider.autoDispose<void>((ref) async {
  // This will be used as a notifier
  throw UnimplementedError('Use deleteCardNotifier instead');
});

final deleteCardNotifierProvider = Provider<DeleteCardNotifier>((ref) {
  return DeleteCardNotifier(ref);
});

class DeleteCardNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  DeleteCardNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> deleteCard(int cardId) async {
    state = const AsyncValue.loading();

    try {
      final isar = ref.read(isarProvider);

      await isar.writeAsync((isar) {
        isar.cardModels.delete(cardId);
      });

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
