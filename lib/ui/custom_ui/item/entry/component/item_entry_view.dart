import 'package:flutter/material.dart';

import '../../../../../core/vendor/viewobject/product.dart';
import '../../../../vendor_ui/item/entry/component/item_entry_view.dart';

class CustomItemEntryView extends StatefulWidget {
  const CustomItemEntryView({
    Key? key,
    required this.flag,
    required this.item,
    required this.animationController,
    this.onItemUploaded,
    required this.maxImageCount,
  }) : super(key: key);
  
  final AnimationController? animationController;
  final String? flag;
  final Product? item;
  final Function? onItemUploaded;
  final int maxImageCount;

  @override
  State<StatefulWidget> createState() => ItemEntryViewState();
}

class ItemEntryViewState extends State<CustomItemEntryView> {
  @override
  Widget build(BuildContext context) {
    return ItemEntryView(
        flag: widget.flag,
        item: widget.item,
        onItemUploaded: widget.onItemUploaded,
        animationController: widget.animationController,
        maxImageCount: widget.maxImageCount);
  }
}
