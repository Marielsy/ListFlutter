import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/preference_cubit.dart';
import '../cubit/preference_state.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/loading_widget.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PreferenceCubit>().loadSavedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/api-list'),
        ),
      ),
      body: BlocBuilder<PreferenceCubit, PreferenceState>(
        builder: (context, state) {
          if (state is PreferenceLoading) {
            return const LoadingWidget();
          } else if (state is PreferenceLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No saved items'));
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.imageUrl),
                      onBackgroundImageError: (_, __) => {},
                      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      child: item.imageUrl.isEmpty 
                          ? Text(item.customName[0].toUpperCase()) 
                          : null,
                    ),
                    title: Text(
                      item.customName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.apiItemName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<PreferenceCubit>().deleteItem(item.id);
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      context.go('/prefs/${item.id}', extra: item);
                    },
                  ),
                );
              },
            );
          } else if (state is PreferenceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<PreferenceCubit>().loadSavedItems(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
