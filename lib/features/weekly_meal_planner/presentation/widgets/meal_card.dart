import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_type.dart';
import '../bloc/week_menu_bloc.dart';
import '../bloc/week_menu_event.dart';
import '../bloc/week_menu_state.dart';

class MealCard extends StatefulWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal.name);
    _urlController = TextEditingController(text: widget.meal.referenceUrl ?? '');
    _notesController = TextEditingController(text: widget.meal.notes);
  }

  @override
  void didUpdateWidget(covariant MealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If external meal data changed and we are not currently editing, refresh controllers
    final isEditing = context.read<WeekMenuBloc>().state.editingMealId == widget.meal.id;
    if (oldWidget.meal != widget.meal && !isEditing) {
      _nameController.text = widget.meal.name;
      _urlController.text = widget.meal.referenceUrl ?? '';
      _notesController.text = widget.meal.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _launchReferenceUrl(String? url) async {
    if (url == null || url.trim().isEmpty) return;

    final trimmed = url.trim();
    final uri = Uri.tryParse(
      trimmed.startsWith('http://') || trimmed.startsWith('https://')
          ? trimmed
          : 'https://$trimmed',
    );

    if (uri != null) {
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $url')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening link: $e')),
          );
        }
      }
    }
  }

  void _onSave(BuildContext context) {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal name cannot be empty')),
      );
      return;
    }

    final isSnack = widget.meal.type == MealType.snack;
    final updatedMeal = widget.meal.copyWith(
      name: newName,
      referenceUrl: isSnack ? null : _urlController.text.trim(),
      notes: _notesController.text.trim(),
    );

    context.read<WeekMenuBloc>().add(UpdateMealEvent(updatedMeal));
  }

  void _onCancel(BuildContext context) {
    _nameController.text = widget.meal.name;
    _urlController.text = widget.meal.referenceUrl ?? '';
    _notesController.text = widget.meal.notes;
    context.read<WeekMenuBloc>().add(ToggleMealEditMode(widget.meal.id));
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text(
          'Are you sure you want to delete "${widget.meal.name.isNotEmpty ? widget.meal.name : widget.meal.type.displayName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<WeekMenuBloc>().add(
            DeleteMealEvent(widget.meal.id, widget.meal.date, widget.meal.type),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<WeekMenuBloc, WeekMenuState, bool>(
      selector: (state) => state.editingMealId == widget.meal.id,
      builder: (context, isEditing) {
        return Card(
          elevation: isEditing ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isEditing
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant.withOpacity(0.5),
              width: isEditing ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isEditing ? _buildEditMode(context, theme) : _buildViewMode(context, theme),
          ),
        );
      },
    );
  }

  Widget _buildViewMode(BuildContext context, ThemeData theme) {
    final isSnack = widget.meal.type == MealType.snack;
    final hasUrl = !isSnack && (widget.meal.referenceUrl?.trim().isNotEmpty ?? false);
    final hasNotes = widget.meal.notes.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.meal.name.isNotEmpty ? widget.meal.name : 'Unnamed Meal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.edit_outlined, size: 18),
              visualDensity: VisualDensity.compact,
              tooltip: 'Edit meal',
              onPressed: () {
                _nameController.text = widget.meal.name;
                _urlController.text = widget.meal.referenceUrl ?? '';
                _notesController.text = widget.meal.notes;
                context.read<WeekMenuBloc>().add(ToggleMealEditMode(widget.meal.id));
              },
            ),
            const SizedBox(width: 4),
            IconButton.filledTonal(
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              visualDensity: VisualDensity.compact,
              style: IconButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              tooltip: 'Delete meal',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        if (hasUrl) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _launchReferenceUrl(widget.meal.referenceUrl),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.meal.referenceUrl!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (hasNotes) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.meal.notes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditMode(BuildContext context, ThemeData theme) {
    final isSnack = widget.meal.type == MealType.snack;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.edit_note_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Edit ${widget.meal.type.displayName}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Name field
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Meal Name',
            hintText: 'e.g. Avocado Toast',
            prefixIcon: const Icon(Icons.restaurant_menu_rounded, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        ),
        if (!isSnack) ...[
          const SizedBox(height: 10),
          // Reference URL field (omitted for Snack)
          TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Reference URL',
              hintText: 'https://...',
              prefixIcon: const Icon(Icons.link_rounded, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              isDense: true,
            ),
          ),
        ],
        const SizedBox(height: 10),
        // Notes field
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Notes',
            hintText: 'Recipe steps, ingredient details, etc.',
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: Icon(Icons.notes_rounded, size: 20),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 14),
        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => _onCancel(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Save'),
              onPressed: () => _onSave(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
