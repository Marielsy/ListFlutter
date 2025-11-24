import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/local_item.dart';
import '../cubit/preference_cubit.dart';
import '../cubit/preference_state.dart';

class CreateItemScreen extends StatefulWidget {
  final Item? item;

  const CreateItemScreen({super.key, this.item});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return const Scaffold(
        body: Center(child: Text('No item selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Item'),
      ),
      body: BlocListener<PreferenceCubit, PreferenceState>(
        listener: (context, state) {
          if (state is PreferenceOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item saved successfully')),
            );
            context.go('/prefs');
          } else if (state is PreferenceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Original Name: ${widget.item!.name}'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final localItem = LocalItem(
                            id: const Uuid().v4(),
                            apiItemName: widget.item!.name,
                            customName: _nameController.text,
                            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', // Placeholder or extract ID from URL
                          );
                          context.read<PreferenceCubit>().saveItem(localItem);
                        }
                      },
                      child: const Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
