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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(item!.imageUrl, height: 200),
              const SizedBox(height: 20),
              Text('Custom Name: ${item!.customName}', style: Theme.of(context).textTheme.headlineSmall),
              Text('Original Name: ${item!.apiItemName}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<PreferenceCubit>().deleteItem(item!.id);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
