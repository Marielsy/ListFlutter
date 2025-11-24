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
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.imageUrl), // In real app, handle error
                  ),
                  title: Text(item.customName),
                  subtitle: Text(item.apiItemName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<PreferenceCubit>().deleteItem(item.id);
                    },
                  ),
                  onTap: () {
                    context.go('/prefs/${item.id}', extra: item);
                  },
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
