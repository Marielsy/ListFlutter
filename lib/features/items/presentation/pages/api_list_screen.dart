import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/api_cubit.dart';
import '../cubit/api_state.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/loading_widget.dart';

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
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
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
                  final items = state.items;
                  // Simple local filtering for demo purposes if not handled in Cubit fully
                  final filteredItems = items.where((item) =>
                      item.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.url),
                        onTap: () {
                          // Navigate to create screen with item details
                          context.go('/prefs/new', extra: item);
                        },
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
