import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/pokemon_utils.dart';
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
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Save to Favorites',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            PokemonUtils.getImageUrl(widget.item!.url),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Original: ${widget.item!.name}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Custom Name',
                          prefixIcon: Icon(Icons.edit),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final localItem = LocalItem(
                                    id: const Uuid().v4(),
                                    apiItemName: widget.item!.name,
                                    customName: _nameController.text,
                                    imageUrl: PokemonUtils.getImageUrl(widget.item!.url),
                                  );
                                  context.read<PreferenceCubit>().saveItem(localItem);
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
