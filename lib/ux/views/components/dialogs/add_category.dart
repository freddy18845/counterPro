import "dart:async";
import "package:eswaini_destop_app/platform/utils/isar_manager.dart";
import "package:eswaini_destop_app/ux/models/shared/category.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/screen.dart";
import "../shared/base_dailog.dart";
import "../shared/login_input.dart";
import "../shared/btn.dart";

class AddEditCategoryDialog extends StatefulWidget {
  final Category? category; // null = add mode, not null = edit mode

  const AddEditCategoryDialog({super.key, this.category});

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final isar = IsarService.db;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isActive = true;
  bool _isLoading = false;

  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    _prefillIfEditing();
  }

  void _prefillIfEditing() {
    if (!_isEditMode) return;
    final c = widget.category!;
    _nameController.text = c.name;
    _descriptionController.text = c.description ?? '';
    _isActive = c.isActive;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // check for duplicate name
    final existing = await isar.categorys
        .where()
        .filter()
        .nameEqualTo(_nameController.text.trim())
        .findFirst();

    // allow same name if editing the same record
    if (existing != null &&
        (!_isEditMode || existing.id != widget.category!.id)) {
      setState(() => _isLoading = false);
      if (mounted) {
        AppUtil.toastMessage(
          message: '❌ Category "${_nameController.text.trim()}" already exists',
          context: context,
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    final category = _isEditMode ? widget.category! : Category();

    category
      ..name = _nameController.text.trim()
      ..description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim()
      ..isActive = _isActive
      ..updatedAt = DateTime.now();

    if (!_isEditMode) {
      category.createdAt = DateTime.now();
    }

    await isar.writeTxn(() async {
      await isar.categorys.put(category);
    });

    setState(() => _isLoading = false);

    if (mounted) {
      AppUtil.toastMessage(
        message: _isEditMode
            ? '✅ Category updated successfully'
            : '✅ Category added successfully',
        context: context,
        backgroundColor: Colors.green,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: _isEditMode ? 'Edit Category' : 'Add Category',
        showCard: true,
        titleSize: 18,
        cardHeight: 390,
        cardWidth: 480,
        onClose: () => Navigator.pop(context),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),

              // ── Name ──────────────────────────────────────
              InputField(
                label: 'Category Name',
                controller: _nameController,
                hintText: 'Enter category name',
                prexIcon: Icons.category_outlined,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Category name is required' : null,
              ),
              const SizedBox(height: 12),

              // ── Description ───────────────────────────────
              InputField(
                label: 'Description (optional)',
                controller: _descriptionController,
                hintText: 'Enter category description',
                prexIcon: Icons.description_outlined,
              ),
              const SizedBox(height: 12),

              // ── Active toggle ─────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => setState(() => _isActive = !_isActive),
                    child:RepaintBoundary(
                      child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isActive ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isActive
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            size: 16,
                            color: _isActive ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Divider(thickness: 1),
              const SizedBox(height: 8),
              // ── Buttons ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ColorBtn(
                      text: AppStrings.cancel,
                      btnColor: AppColors.red,
                      action: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ColorBtn(
                      text: _isLoading
                          ? AppStrings.saving
                          : _isEditMode
                          ? 'Update Category'
                          : 'Add Category',
                      btnColor: AppColors.secondaryColor,
                      action: _isLoading ? () {} : _save,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
