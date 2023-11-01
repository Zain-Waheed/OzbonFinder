import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../config/route/route_paths.dart';
import '../../../../../../../core/vendor/provider/entry/item_entry_provider.dart';
import '../../../../../../../core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../../core/vendor/viewobject/category.dart';
import '../../../../../common/ps_dropdown_base_with_controller_widget.dart';


class ChooseCategoryDropDownWidget extends StatelessWidget {
  const ChooseCategoryDropDownWidget(
      {required this.categoryController,
      required this.subCategoryController,
      required this.isMandatory});
  final TextEditingController categoryController;
  final TextEditingController subCategoryController;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return PsDropdownBaseWithControllerWidget(
      title: 'item_entry__category'.tr,
      hintText: 'item_entry__choose_category'.tr,
      textEditingController: categoryController,
      isStar: isMandatory,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final ItemEntryProvider provider =
            Provider.of<ItemEntryProvider>(context, listen: false);

        final dynamic categoryResult = await Navigator.pushNamed(
            context, RoutePaths.searchCategory,
            arguments: categoryController.text);

        if (categoryResult != null && categoryResult is Category) {
          provider.categoryId = categoryResult.catId;
          categoryController.text = categoryResult.catName!;
          provider.subCategoryId = '';
          provider.subCategoryName = '';
          subCategoryController.text = '';
          provider.changeSubCategoryName('');
        }
      },
    );
  }
}
