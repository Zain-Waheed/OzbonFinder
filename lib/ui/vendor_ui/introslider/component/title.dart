import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import '../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../core/vendor/utils/utils.dart';

class SliderTitle extends StatelessWidget {
  const SliderTitle({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final List<String> titleList = <String>[
      'intro_slider1_title'.tr,
      'intro_slider2_title'.tr,
      'intro_slider3_title'.tr
    ];
    return Container(
      // color: Colors.blue,
      width: 300,
      margin: const EdgeInsets.only(
          top: PsDimens.space16,
          left: PsDimens.space16,
          right: PsDimens.space16),
      child: Text(
        titleList[currentIndex].tr,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Utils.isLightMode(context)
                  ? PsColors.text900
                  : PsColors.text300,
            ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
