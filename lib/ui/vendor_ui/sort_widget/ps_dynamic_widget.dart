import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/constant/ps_widget_const.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/blog.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/ui/custom_ui/blog/component/slider/blog_product_slider_widget.dart';
import 'package:psxmpc/ui/custom_ui/category/component/horizontal/home_category_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/buy_package_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/follower_product_horizontal_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/header_card.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/header_search_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/home_discount_product_horizontal_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/home_paid_ad_product_horizontal_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/home_popular_product_horizontal_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/nearest_product_horizontal_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/dashboard/components/home/widgets/recent_product_horizontal_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/appbar/product_expandable_appbar.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/info_widgets/description_widget.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/info_widgets/price_widget.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/info_widgets/title_with_favorite_edit_widget.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/tiles/faq_tile_view.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/tiles/safety_tips_tile_view.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/tiles/seller_info_tile_view.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/tiles/static_tile_view.dart';
import 'package:psxmpc/ui/custom_ui/item/detail/component/tiles/terms_and_conditions_tile_view.dart';
import 'package:psxmpc/ui/custom_ui/item/list_with_filter/components/item/widgets/filter_item_list.dart';
import 'package:psxmpc/ui/custom_ui/item/list_with_filter/components/item/widgets/filter_nav_items.dart';
import 'package:psxmpc/ui/custom_ui/item/related_item/component/horizontal/related_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/post_type/component/home_post_type_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/paid_item_list/component/horizontal/paid_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/detail_info/profile_detail_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/product_list/active_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/product_list/disabled_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/product_list/pending_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/product_list/rejected_product_list_widget.dart';
import 'package:psxmpc/ui/custom_ui/user/profile/component/product_list/sold_out_product_list_widget.dart';
import 'package:psxmpc/ui/vendor_ui/blog/component/blog_details_widget.dart';
import 'package:psxmpc/ui/vendor_ui/category/component/vertical/widgets/category_vertical_list_widget.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_admob_banner_widget.dart';
import 'package:psxmpc/ui/vendor_ui/item/detail/component/custom_detail_info/custom_field_list.dart';

import '../../custom_ui/item/detail/component/custom_field/product_info_list.dart';
import '../item/detail/component/custom_detail_info/amenities_widget.dart';
import '../item/detail/component/custom_detail_info/facilities_widget.dart';
import '../item/detail/component/info_widgets/map_widget.dart';

class PsDynamicWidget extends StatelessWidget {
const PsDynamicWidget({
    this.animationController,
    required this.scrollController,
    required this.widgetList,
    this.blog,
    this.heroTagImage = '',
    this.isReadyToShowAppBarIcons = false,
    this.heroTagTitle = '',
    this.callLogoutCallBack,
    this.isGrid,
  });

  final AnimationController? animationController;
  final ScrollController scrollController;
  final List<String>? widgetList;
  final Blog? blog;
  final String? heroTagImage;
  final bool? isReadyToShowAppBarIcons;
  final String? heroTagTitle;
  final Function? callLogoutCallBack;
  final bool? isGrid;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);

    final List<Widget> _widgets = <Widget>[];

    final Map<String, Map<String, Widget>> widgetMap =
        <String, Map<String, Widget>>{
      'category': <String, Widget>{
        PsWidgetConst.category_horizontal_list:
            CustomHomeCategoryHorizontalListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.category_vertical_list: CategoryVerticalListWidget(
          animationController: animationController!,
        ),

        PsWidgetConst.post_type_horizontal_list :CustomHomePostTypeHorizontalListWidget(
          animationController: animationController,
        )
      },
      'blog': <String, Widget>{
        PsWidgetConst.blog_detail: BlogDetailsWidget(
          blog: blog ?? Blog(),
          heroTagImage: heroTagImage ?? '',
        ),
        PsWidgetConst.blog_product_slider: CustomBlogProductSliderListWidget(
          animationController: animationController,
        ),
      },
      'product': <String, Widget>{
        PsWidgetConst.paid_ad_product:
            CustomHomePaidAdProductHorizontalListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.nearest_product: CustomNearestProductHorizontalListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.discount_product:
            CustomHomeDiscountProductHorizontalListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.popular_product:
            CustomHomePopularProductHorizontalListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.item_list_from_followers:
            Utils.isLoginUserEmpty(valueHolder)
                ? CustomItemListFromFollowersHorizontalListWidget(
                    animationController: animationController,
                  )
                : SliverToBoxAdapter(child: Container()),
        PsWidgetConst.recent_item: CustomRecentProductHorizontalListWidget(
          animationController: animationController!,
        ),
        PsWidgetConst.related_product_list: CustomRelatedProductListWidget(),
        PsWidgetConst.product_expandable_appbar: CustomProductExpandableAppbar(
            isReadyToShowAppBarIcons: isReadyToShowAppBarIcons ?? false),
        PsWidgetConst.product_title:
            CustomTitleWithEditAndFavoriteWidget(
          heroTagTitle: heroTagTitle ?? '',
        ),
        PsWidgetConst.product_description: CustomDescriptionWidget(),
        PsWidgetConst.product_map: MapWiget(),
        PsWidgetConst.product_details_info: CustomProductInfoListWidget(),
        PsWidgetConst.product_location_with_price: CustomLocationWithPriceWidget(),
        PsWidgetConst.product_custom_details_info: CustomProductDetailList(),
        PsWidgetConst.product_custom_facilities_widget: FacilitiesWidget(),
        PsWidgetConst.product_custom_amenities_widget: AmenitiesWidget(),
        PsWidgetConst.product_safety_tips_tile: CustomSafetyTipsTileView(),
        PsWidgetConst.product_terms_and_condition:
            const CustomTermsAndConditionTileView(),
        PsWidgetConst.product_faq_tile: const CustomFAQTileView(),
        PsWidgetConst.product_statistic_tile: CustomStatisticTileView(),
        // PsWidgetConst.product_contact_list: CustomContactListWidget(),
        PsWidgetConst.product_seller_info_tile: CustomSellerInfoTileView(),
        PsWidgetConst.filter_item_list_view: CustomItemListView(
          animationController: animationController!,
          isGrid: isGrid,
        ),
        PsWidgetConst.filter_nav_items: const SliverToBoxAdapter(
          child: CustomFilterNavItems(),
        ),
      },
      'common': <String, Widget>{
        PsWidgetConst.header_card:  CustomHeaderCard(animationController: animationController,),
        PsWidgetConst.search_header: CustomHomeSearchHeaderWidget(
          animationController: animationController,
        ),
        PsWidgetConst.sizedbox_80: const SliverToBoxAdapter(
          child: SizedBox(height: PsDimens.space80),
        ),
        PsWidgetConst.ps_admob_banner_widget: const PsAdMobBannerWidget(
          useSliver: true,
        ),
      },
      'package': <String, Widget>{
        PsWidgetConst.buy_package: valueHolder.isPaidApp == PsConst.ONE
            ? CustomBuyPackageWidget(
                animationController: animationController,
              )
            : SliverToBoxAdapter(child: Container()),
      },
      'user': <String, Widget>{
        PsWidgetConst.profile_detail: CustomProfileDetailWidget(
            animationController: animationController,
            callLogoutCallBack: callLogoutCallBack ?? () {}),
        PsWidgetConst.paid_product_list: CustomPaidProductListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.active_product_list: CustomActiveProductListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.pending_product_list_widget:
            CustomPendingProductListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.soldout_product_list: CustomSoldOutProductListWidget(
          animationController: animationController,
        ),
        PsWidgetConst.rejected_listing_data: CustomRejectedListingDataWidget(
          animationController: animationController,
        ),
        PsWidgetConst.disabled_listing_data: CustomDisabledListingDataWidget(
          animationController: animationController,
        ),
      },

      // 'common': <String, Widget>{
      //   PsWidgetConst.search_header: CustomHomeSearchHeaderWidget(
      //     animationController: animationController,
      //   ),
      //   PsWidgetConst.sizedbox_80: const SliverToBoxAdapter(
      //     child: SizedBox(height: PsDimens.space80),
      //   ),
      // },
      // 'package': <String, Widget>{
      //   PsWidgetConst.buy_package: valueHolder.isPaidApp == PsConst.ONE
      //       ? CustomBuyPackageWidget(
      //           animationController: animationController,
      //         )
      //       : SliverToBoxAdapter(child: Container()),
      // },
      // 'user': <String, Widget> {
      //   PsWidgetConst.profile_detail: CustomProfileDetailWidget(
      //       animationController: animationController,
      //       callLogoutCallBack: callLogoutCallBack ?? () {}),
      // },
    };
    for (String i in widgetList!) {
      for (String outerKey in widgetMap.keys) {
        if (widgetMap[outerKey]?[i] != null)
          _widgets.add(widgetMap[outerKey]![i]!);
      }
    }

    return CustomScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      shrinkWrap: false,
      slivers: _widgets,
    );
  }
}
