import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opencardholder/providers/database_provider.dart';
import 'package:opencardholder/screens/error_screen.dart';
import 'package:opencardholder/widgets/card_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isScrolled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(allCardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OpenCardHolder',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cardsAsync.when(
        data: (cards) =>
            Cardlist(cards: cards, scrollController: _scrollController),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            ErrorScreen(error: error, stackTrace: stackTrace),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        onPressed: () {
          GoRouter.of(context).push('/add-new-card');
        },
        tooltip: 'Add new card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
