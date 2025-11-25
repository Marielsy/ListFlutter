import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/local_item.dart';
import '../cubit/preference_cubit.dart';
import '../cubit/preference_state.dart';

class ItemDetailScreen extends StatelessWidget {
  final LocalItem? item;
  final String id;

  const ItemDetailScreen({super.key, this.item, required this.id});

  @override
  Widget build(BuildContext context) {
    // In a real app, if item is null, we might fetch it by ID from the cubit/repo
    if (item == null) {
      return const Scaffold(
        body: Center(child: Text('Item not found (or passed via extra)')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item!.customName),
      ),
      body: BlocListener<PreferenceCubit, PreferenceState>(
        listener: (context, state) {
          if (state is PreferenceOperationSuccess) {
            context.go('/prefs');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: Image.network(
                        item!.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            item!.customName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Original: ${item!.apiItemName}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<PreferenceCubit>().deleteItem(item!.id);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to List'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
