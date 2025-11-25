import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/api_cubit.dart';
import '../cubit/api_state.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../../../../core/utils/pokemon_utils.dart';

class ApiListScreen extends StatefulWidget {
  const ApiListScreen({super.key});

  @override
  State<ApiListScreen> createState() => _ApiListScreenState();
}

class _ApiListScreenState extends State<ApiListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ApiCubit>().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.go('/prefs'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Debounce could be added here
                context.read<ApiCubit>().searchItems(value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ApiCubit, ApiState>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const LoadingWidget();
                } else if (state is ApiLoaded) {
                  final items = state.filteredItems;
                  // Simple local filtering for demo purposes if not handled in Cubit fully
                  final filteredItems = items;

                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                            backgroundImage: NetworkImage(PokemonUtils.getImageUrl(item.url)),
                            onBackgroundImageError: (_, __) => {}, // Fallback to text if image fails
                            child: Text(
                              item.name[0].toUpperCase(),
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to create screen with item details
                            context.go('/prefs/new', extra: item);
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ApiError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<ApiCubit>().fetchItems(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
