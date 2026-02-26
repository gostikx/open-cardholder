import 'package:go_router/go_router.dart';
import 'package:open_cardholder/screens/add_new_card_screen.dart';
import 'package:open_cardholder/screens/card_detail_screen.dart';
import 'package:open_cardholder/screens/home_screen.dart';
import 'package:open_cardholder/screens/update_card_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/add-new-card',
      builder: (context, state) => const CreateNewCard(),
    ),
    GoRoute(
      path: '/card-detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CardDetailScreen(cardId: id);
      },
    ),
    GoRoute(
      path: '/update-card/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return UpdateCardScreen(cardId: id);
      },
    ),
  ],
);
