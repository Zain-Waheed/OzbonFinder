import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';

import '../../../../../../../core/vendor/provider/gallery/gallery_provider.dart';
import '../../../../../../../core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../../core/vendor/provider/product/item_entry_provider.dart';
import '../../../../../../../core/vendor/provider/user/user_provider.dart';
import '../../../../../../../core/vendor/repository/gallery_repository.dart';
import '../../../../../../../core/vendor/repository/item_entry_field_repository.dart';
import '../../../../../../../core/vendor/repository/product_repository.dart';
import '../../../../../../../core/vendor/repository/user_repository.dart';
import '../../../../../../../core/vendor/viewobject/common/ps_value_holder.dart';
import '../../../../../config/ps_config.dart';
import '../../../../../core/vendor/constant/ps_constants.dart';
import '../../../../../core/vendor/constant/ps_dimens.dart';
import '../../../../../core/vendor/db/common/ps_data_source_manager.dart';
import '../../../../../core/vendor/provider/entry/item_entry_provider.dart';
import '../../../../../core/vendor/viewobject/holder/request_path_holder.dart';
import '../../../../../core/vendor/viewobject/product.dart';
import '../../../../custom_ui/item/entry/component/entry_data/core_and_custom_field_entry_view.dart';
import '../../../../custom_ui/item/entry/component/entry_image/horizontal_entry_image_list.dart';
import '../../../../custom_ui/package/component/go_to_package_shop_view.dart';
import '../../../common/base/ps_widget_with_multi_provider.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView({
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
  State<StatefulWidget> createState() => ItemEntryViewState<ItemEntryView>();
}

class ItemEntryViewState<T extends ItemEntryView> extends State<ItemEntryView> {
  ProductRepository? repo1;
  GalleryRepository? galleryRepository;
  late ItemEntryProvider _itemEntryProvider;
  late GalleryProvider galleryProvider;
  UserProvider? userProvider;
  ItemEntryFieldProvider? itemEntryFieldProvider;
  UserRepository? userRepository;
  PsValueHolder? valueHolder;
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final TextEditingController userInputDiscount = TextEditingController();

  bool bindDataFirstTime = true;
  String isShopCheckbox = '1';

  @override
  Widget build(BuildContext context) {
    final AppLocalization langProvider = Provider.of<AppLocalization>(context);
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);
    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    final ItemEntryFieldRepository itemEntryFieldRepository =
        Provider.of<ItemEntryFieldRepository>(context);
    widget.animationController!.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemEntryFieldProvider?>(
            lazy: false,
            create: (BuildContext context) {
              itemEntryFieldProvider =
                  ItemEntryFieldProvider(repo: itemEntryFieldRepository);
              itemEntryFieldProvider!.loadData(
                  dataConfig: DataConfiguration(
                      dataSourceType: PsConfig.cacheInItemEntry
                          ? DataSourceType.FULL_CACHE
                          : DataSourceType.SERVER_DIRECT),
                  requestPathHolder: RequestPathHolder(
                      loginUserId: valueHolder?.loginUserId,
                      languageCode: langProvider.currentLocale.languageCode));
              return itemEntryFieldProvider;
            },
          ),
          ChangeNotifierProvider<ItemEntryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _itemEntryProvider =
                    ItemEntryProvider(repo: repo1, psValueHolder: valueHolder);
                _itemEntryProvider.item = widget.item;
                addDefaultDataToProvider();
                _itemEntryProvider.getItemFromDB(widget.item!.id);
                return _itemEntryProvider;
              }),
          ChangeNotifierProvider<GalleryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                galleryProvider = GalleryProvider(repo: galleryRepository!);
                if (widget.flag == PsConst.EDIT_ITEM) {
                  galleryProvider.loadDataList(
                      requestPathHolder: RequestPathHolder(
                          languageCode: langProvider.currentLocale.languageCode,
                          parentImgId: widget.item!.defaultPhoto!.imgParentId,
                          imageType: PsConst.ITEM_IMAGE_TYPE));
                }
                return galleryProvider;
              }),
          ChangeNotifierProvider<UserProvider?>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  repo: userRepository, psValueHolder: valueHolder);
              userProvider!.getUser(valueHolder!.loginUserId,
                  langProvider.currentLocale.languageCode);
              return userProvider;
            },
          )
        ],
        child: Consumer<UserProvider>(
          builder:
              (BuildContext context, UserProvider provider, Widget? child) {
            if (widget.flag == PsConst.ADD_NEW_ITEM &&
                valueHolder!.isPaidApp == PsConst.ONE &&
                provider.user.data == null)
              return Container(
                color: Utils.isLightMode(context) ? PsColors.achromatic50 : PsColors.achromatic800,
              );
            if (widget.flag == PsConst.EDIT_ITEM ||
                (valueHolder!.isPaidApp != PsConst.ONE ||
                    (provider.user.data != null &&
                        int.parse(provider.user.data!.remainingPost!) > 0)))
              return SingleChildScrollView(child: Consumer<ItemEntryProvider>(
                  builder: (BuildContext context, ItemEntryProvider provider,
                      Widget? child) {
                /**
                 * UI SECTION
                 */
                return AnimatedBuilder(
                    animation: widget.animationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomImageUploadHorizontalList(
                              addNewItem: widget.flag,
                              maxImageCount: valueHolder!.maxImageCount),
                          CustomCoreAndCustomFieldEntryView(
                            flag: widget.flag,
                            item: widget.item,
                            onItemUploaded: widget.onItemUploaded,
                          ),
                          const SizedBox(height: PsDimens.space80)
                        ],
                      );
                    });
              }));
            return CustomGoToPackageShopView();
          },
        ),
      ),
    );
  }

  void addDefaultDataToProvider() {
    _itemEntryProvider.itemCurrencyId = valueHolder!.defaultCurrencyId;
    _itemEntryProvider.currencyName = valueHolder!.defaultCurrency;
    //Location Section
    if (valueHolder!.isSubLocation == PsConst.ONE &&
        valueHolder!.locationTownshipLat != '') {
      _itemEntryProvider.itemLocationTownshipId =
          valueHolder!.locationTownshipId;
      _itemEntryProvider.locationTownshipName =
          valueHolder!.locationTownshipName;
      if (double.tryParse(valueHolder!.locationTownshipLat) != null &&
          double.tryParse(valueHolder!.locationTownshipLat)! > -90 &&
          double.tryParse(valueHolder!.locationTownshipLat)! < 90 &&
          double.tryParse(valueHolder!.locationTownshipLng) != null &&
          double.tryParse(valueHolder!.locationTownshipLng)! > -180 &&
          double.tryParse(valueHolder!.locationTownshipLng)! <
              180) //_latitude < -90 || _latitude > 90
      {
        _itemEntryProvider.latlng = LatLng(
            double.parse(valueHolder!.locationTownshipLat),
            double.parse(valueHolder!.locationTownshipLng));
        userInputLattitude.text = valueHolder!.locationTownshipLat;
        userInputLongitude.text = valueHolder!.locationTownshipLng;
      } else {
        _itemEntryProvider.latlng = LatLng(0.0, 0.0);
        userInputLattitude.text = '0.0';
        userInputLongitude.text = '0.0';
      }
    } else {
      if (double.tryParse(valueHolder!.locationLat!) != null &&
          double.tryParse(valueHolder!.locationLat!)! > -90 &&
          double.tryParse(valueHolder!.locationLat!)! < 90 &&
          double.tryParse(valueHolder!.locationLng!) != null &&
          double.tryParse(valueHolder!.locationLng!)! > -180 &&
          double.tryParse(valueHolder!.locationLng!)! <
              180) //_latitude < -90 || _latitude > 90
      {
        _itemEntryProvider.latlng = LatLng(
            double.parse(valueHolder!.locationLat!),
            double.parse(valueHolder!.locationLng!));
        userInputLattitude.text = valueHolder!.locationLat!;
        userInputLongitude.text = valueHolder!.locationLng!;
      } else {
        _itemEntryProvider.latlng = LatLng(0.0, 0.0);
        userInputLattitude.text = '0.0';
        userInputLongitude.text = '0.0';
      }
    }
    _itemEntryProvider.itemLocationId = valueHolder!.locationId;
    _itemEntryProvider.locationName = valueHolder!.locactionName ?? '';

    _itemEntryProvider.phoneNumList[0].countryCodeController.text =
        valueHolder!.defaulPhoneCountryCode;

    _itemEntryProvider.isAggreTermsAndPolicy =
        valueHolder!.isAggreTermsAndConditions;
  }
}
