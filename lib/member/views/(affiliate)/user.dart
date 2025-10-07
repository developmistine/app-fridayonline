import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fridayonline/member/components/profile/affiliate/user.apply.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.header.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.menu.dart';
import 'package:fridayonline/member/components/profile/affiliate/user.slide.dart';
import 'package:fridayonline/member/components/profile/affiliate/utils/product.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.account.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.product.ctr.dart';
import 'package:fridayonline/member/controller/profile.ctr.dart';
import 'package:fridayonline/member/controller/showproduct.sku.ctr.dart';
import 'package:fridayonline/member/models/profile/profile_data.dart';
import 'package:fridayonline/safearea.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AffiliateUser extends StatefulWidget {
  const AffiliateUser({super.key});

  @override
  State<AffiliateUser> createState() => _AffiliateUserState();
}

class _AffiliateUserState extends State<AffiliateUser> {
  final affAccountCtl = Get.find<AffiliateAccountCtr>();
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
  final affProductCtl = Get.find<AffiliateProductCtr>();
  final profileCtl = Get.find<ProfileCtl>();
  Worker? _profileWorker;

  late final ScrollController _scrollCtr;
  final RxBool _showBackToTop = false.obs;
  final RxSet<int> selected = <int>{}.obs;

  Future<void> _handleRefresh() async {
    await affAccountCtl.checkStatus();

    if (affAccountCtl.validStatus.value == 'approved') {
      affCommissionCtl.getAccountSummary();
      await affProductCtl.refreshRecommendProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    final p0 = profileCtl.profileData.value;
    if (p0 != null) affAccountCtl.prefillFromProfile(p0);

    _profileWorker = ever<ProfileData?>(
      profileCtl.profileData,
      (p) {
        if (p != null) affAccountCtl.prefillFromProfile(p);
      },
    );

    affAccountCtl.getAffiliateTips();
    affAccountCtl.checkStatus();
    affCommissionCtl.getAccountSummary();

    _scrollCtr = ScrollController()
      ..addListener(() {
        _showBackToTop.value = _scrollCtr.offset > 300;
        if (_scrollCtr.position.pixels >=
            _scrollCtr.position.maxScrollExtent - 200) {
          affProductCtl.loadMoreRecommendProducts();
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      affProductCtl.refreshRecommendProducts();
    });
  }

  @override
  void dispose() {
    _scrollCtr.dispose();
    _profileWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaProvider(child: Obx(() {
      if (affAccountCtl.isCheckingStatus.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final status = affAccountCtl.validStatus.value;
      final isPending = status == 'pending';
      final isApproved = status == 'approved';

      return Scaffold(
        backgroundColor: isApproved
            ? const Color.fromARGB(255, 244, 244, 244)
            : Colors.white,
        body: Stack(
          children: [
            if (isPending || isApproved)
              RefreshIndicator(
                color: themeColorDefault,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  controller: _scrollCtr,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: _buildAffiliateBody(status),
                ),
              )
            else
              SingleChildScrollView(
                controller: _scrollCtr,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                child: _buildAffiliateBody(status),
              ),
            if (isPending || isApproved)
              Obx(() {
                if (!_showBackToTop.value) return const SizedBox.shrink();
                final safeBottom = MediaQuery.of(context).padding.bottom;
                return Positioned(
                  right: 16,
                  bottom: 16 + safeBottom,
                  child: FloatingActionButton.small(
                    heroTag: 'aff_user_back_to_top',
                    backgroundColor: Colors.black87.withValues(alpha: .3),
                    onPressed: () {
                      _scrollCtr.animateTo(
                        0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    child: const Icon(Icons.keyboard_arrow_up,
                        color: Colors.white),
                  ),
                );
              }),
          ],
        ),
      );
    }));
  }

  Widget _buildAffiliateBody(String status) {
    final isNotApplied = status == 'not_applied';
    final isApproved = status == 'approved';

    return Column(
      spacing: 2,
      children: [
        UserHeader(),
        SafeArea(
          top: false,
          child: isNotApplied
              ? Column(children: const [UserSlides(), UserApply()])
              : isApproved
                  ? Column(
                      spacing: 2,
                      children: [
                        const UserMenu(),
                        Obx(() {
                          final loading =
                              affProductCtl.isLoadingRecommend.value;
                          final items = affProductCtl.recommendProductData;

                          if (loading && items.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            );
                          }
                          if (items.isEmpty) return const SizedBox.shrink();

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final w = constraints.maxWidth;
                              final count =
                                  math.min(6, math.max(2, (w / 180).floor()));
                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สินค้าที่แนะนำให้เพิ่ม',
                                      style: GoogleFonts.ibmPlexSansThai(
                                        color: const Color(0xFF1F1F1F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: count,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        childAspectRatio: 0.62,
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        final p = items[index];
                                        final id = p.productId;
                                        return Obx(() {
                                          final isSelected =
                                              selected.contains(id);
                                          final isLoadingThis = affProductCtl
                                                  .isAddingProduct.value &&
                                              affProductCtl
                                                      .addingProductId.value ==
                                                  id;
                                          return Stack(
                                            children: [
                                              productItem(
                                                product: p,
                                                showShare: false,
                                                onTap: () {
                                                  Get.find<ShowProductSkuCtr>()
                                                      .fetchB2cProductDetail(
                                                          p.productId,
                                                          'shop_content');
                                                  // setPauseVideo();
                                                  Get.toNamed(
                                                    '/ShowProductSku/${p.productId}',
                                                  );
                                                },
                                              ),
                                              Positioned(
                                                bottom: 16,
                                                right: 16,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  onTap: (isSelected ||
                                                          isLoadingThis)
                                                      ? null
                                                      : () async {
                                                          final ok =
                                                              await affProductCtl
                                                                  .addProduct(
                                                                      'product',
                                                                      0,
                                                                      id);
                                                          if (ok) {
                                                            selected.add(id);
                                                            selected.refresh();
                                                          }
                                                        },
                                                  child: Container(
                                                    width: 34,
                                                    height: 34,
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? Colors.grey.shade400
                                                          : (isLoadingThis
                                                              ? Colors
                                                                  .grey.shade300
                                                              : themeColorDefault),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: isLoadingThis
                                                        ? const SizedBox(
                                                            width: 22,
                                                            height: 22,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            'assets/images/affiliate/add_bag.svg',
                                                            width: 22,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    )
                  : _buildPendingOrRejected(status),
        ),
      ],
    );
  }

  Widget _buildPendingOrRejected(String status) {
    final isPending = status == 'pending';
    final statusMsg = affAccountCtl.validStatusMsg.value;

    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Image.asset(
              isPending
                  ? 'assets/images/affiliate/register_pending.png'
                  : 'assets/images/affiliate/register_rejected.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isPending ? 'อยู่ระหว่างการตรวจสอบ' : 'ไม่ผ่านการตรวจสอบ',
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF1F1F1F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            statusMsg,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSansThai(
              color: const Color(0xFF5A5A5A),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
