import 'package:go_router/go_router.dart';
import '../../features/items/domain/entities/item.dart';
import '../../features/items/domain/entities/local_item.dart';
import '../../features/items/presentation/pages/api_list_screen.dart';
import '../../features/items/presentation/pages/create_item_screen.dart';
import '../../features/items/presentation/pages/item_detail_screen.dart';
import '../../features/items/presentation/pages/saved_items_screen.dart';

final router = GoRouter(
  initialLocation: '/api-list',
  routes: [
    GoRoute(
      path: '/api-list',
      builder: (context, state) => const ApiListScreen(),
    ),
    GoRoute(
      path: '/prefs',
      builder: (context, state) => const SavedItemsScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) {
            final item = state.extra as Item?;
            return CreateItemScreen(item: item);
          },
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final item = state.extra as LocalItem?;
            return ItemDetailScreen(id: id, item: item);
          },
        ),
      ],
    ),
  ],
);
