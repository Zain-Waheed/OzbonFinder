import 'package:flutter/material.dart';
import 'package:psxmpc/ui/vendor_ui/dashboard/components/bottom_nav/widgets/selected_noti_nav_item.dart';


class CustomSelectedNotiNavCount extends StatelessWidget {
  const CustomSelectedNotiNavCount(
      {required this.updateSelectedIndexWithAnimation});
  final Function updateSelectedIndexWithAnimation;
  @override
  Widget build(BuildContext context) {
    return SelectedNotiNavCount(updateSelectedIndexWithAnimation: updateSelectedIndexWithAnimation,);
  }
}
