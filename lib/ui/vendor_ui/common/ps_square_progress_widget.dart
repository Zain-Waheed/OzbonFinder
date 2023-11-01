

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';

class PsSquareProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container( 
      width : 35,
      height : 35,
      child:LoadingAnimationWidget.beat(
        // color: AppColors.mainPurpleColor,
        size: 50,
        color: Utils.isLightMode(context) ? PsColors.achromatic100 : PsColors.achromatic600,
      ),
      //==============================
      // child:  LinearProgressIndicator(
      //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.black12),
      //   backgroundColor: Utils.isLightMode(context) ? PsColors.achromatic100 : PsColors.achromatic600
      // ),
    );
  }
}