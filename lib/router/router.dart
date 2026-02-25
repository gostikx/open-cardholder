import 'package:go_router/go_router.dart';
import 'package:open_cardholder/screens/add_new_card_screen.dart';
import 'package:open_cardholder/screens/home_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/add-new-card',
      builder: (context, state) => const CreateNewCard(),
    ),
  ],
);
