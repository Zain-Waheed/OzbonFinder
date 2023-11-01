import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../../../core/vendor/provider/product/product_provider.dart';
import '../../../../../../config/ps_colors.dart';
import '../../../../../../core/vendor/utils/utils.dart';
import '../../../../common/ps_hero.dart';

class TitleWithEditAndFavoriteWidget extends StatelessWidget {
  const TitleWithEditAndFavoriteWidget({Key? key, required this.heroTagTitle})
      : super(key: key);

  final String? heroTagTitle;

  @override
  Widget build(BuildContext context) {
    final ItemDetailProvider itemDetailProvider =
        Provider.of<ItemDetailProvider>(context);
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
            top: PsDimens.space16,
            left: PsDimens.space16,
            right: PsDimens.space16),
        child: PsHero(
          tag: heroTagTitle!,
          child: Text(itemDetailProvider.product.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Utils.isLightMode(context)
                      ? PsColors.accent500
                      : PsColors.primary300)),
        ),
      ),
    );
  }
}
