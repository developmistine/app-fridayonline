import 'package:flutter/material.dart';
import 'package:fridayonline/member/components/shimmer/shimmer.card.dart';
import 'package:fridayonline/member/controller/affiliate/affiliate.commission.ctr.dart';
import 'package:fridayonline/member/models/affiliate/commission.dtlorder.model.dart';
import 'package:fridayonline/member/utils/format.dart';
import 'package:fridayonline/theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Orders extends StatefulWidget {
  final String str;
  const Orders({super.key, required this.str});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();

  @override
  void initState() {
    super.initState();
    affCommissionCtl.getOrderDtl(widget.str);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: themeColorDefault,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        shadowColor: Colors.black.withValues(alpha: 0.4),
        title: Text(
          'ประวัติรายวัน',
          style: GoogleFonts.ibmPlexSansThai(
            color: const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // Gradient header (fixed height)
          Container(
            height: 96,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.46, 0.00),
                end: Alignment(0.46, 1.00),
                colors: [Color(0xFF2291F5), Color(0xFF2EA9E1)],
              ),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/profileimg/background.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Obx(() {
                  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
                  final order = affCommissionCtl.ordersDtlData.value;
                  final dayDate = order?.date ?? '-';
                  final dayTotal = order?.totalAmount ?? '-';

                  if (affCommissionCtl.isDtlOrdersLoading.value) {
                    return Center(
                      child: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShimmerCard(
                            width: 100,
                            height: 12,
                            radius: 6,
                            color: Colors.white24,
                          ),
                          ShimmerCard(
                            width: 170,
                            height: 16,
                            radius: 6,
                            color: Colors.white24,
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayDate,
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ค่าคอมมิชชั่น : $dayTotal',
                          style: GoogleFonts.ibmPlexSansThai(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'คำสั่งซื้อทั้งหมด :',
                  style: GoogleFonts.ibmPlexSansThai(
                    color: const Color(0xFF5A5A5A),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Obx(() {
                  final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
                  final order = affCommissionCtl.ordersDtlData.value;
                  final orderTotal = order?.totalOrders ?? '-';

                  if (affCommissionCtl.isDtlOrdersLoading.value) {
                    return ShimmerCard(
                      width: 75,
                      height: 14,
                      radius: 2,
                      color: const Color.fromARGB(59, 136, 136, 136),
                    );
                  }

                  return Text(
                    orderTotal,
                    style: GoogleFonts.ibmPlexSansThai(
                      color: const Color(0xFF5A5A5A),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                })
              ],
            ),
          ),
          Obx(() {
            final affCommissionCtl = Get.find<AffiliateCommissionCtr>();
            final orderdtl = affCommissionCtl.ordersDtlData.value;
            final orders = orderdtl?.orders ?? [];

            if (affCommissionCtl.isDtlOrdersLoading.value) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }

            return Expanded(child: _OrdersList(orders));
          })
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList(this.orders, {super.key});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        physics: const BouncingScrollPhysics(),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = orders[index];

          final orderNo = item.orderNo;
          final orderDate = item.orderDate;
          final totalItems = item.totalItems;
          final commissionAmount = item.commissionAmount;
          final products = item.orderItems;

          return _OrderCard(
            orderNo: orderNo,
            orderDate: orderDate,
            totalItems: totalItems,
            commissionAmount: commissionAmount,
            products: products,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderNo;
  final String orderDate;
  final int totalItems;
  final String commissionAmount;
  final VoidCallback? onTap;
  final List<OrderItem> products;

  const _OrderCard({
    required this.orderNo,
    required this.orderDate,
    required this.totalItems,
    required this.commissionAmount,
    this.onTap,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF3F3F4), width: 1),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F3F4), width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order no
                    Text(
                      'หมายเลขคำสั่งซื้อ : $orderNo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    // Order date
                    Text(
                      'สั่งซื้อเมื่อ : $orderDate',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.ibmPlexSansThai(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8C8A94),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: List.generate(products.length, (i) {
                  final p = products[i];
                  final hasBottomBorder = i != products.length - 1;

                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: hasBottomBorder
                          ? const Border(
                              bottom: BorderSide(
                                  color: Color(0xFFF3F3F4), width: 1),
                            )
                          : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // thumb
                        Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFECECED)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: p.productImage.isNotEmpty
                                  ? Image.network(
                                      p.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const _ThumbFallback(),
                                      loadingBuilder: (c, w, prog) =>
                                          prog == null
                                              ? w
                                              : const _ThumbFallback(),
                                    )
                                  : const _ThumbFallback(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // texts
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name
                              Text(
                                p.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ibmPlexSansThai(
                                  color: const Color(0xFF1F1F1F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // price row (prevents overflow)
                              Row(
                                children: [
                                  // left price group can shrink
                                  Expanded(
                                    child: p.haveDiscount
                                        ? Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '฿${myFormat.format(p.price)}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                    color:
                                                        const Color(0xFFF54900),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  '฿${myFormat.format(p.priceBeforeDiscount)}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts
                                                      .ibmPlexSansThai(
                                                    color:
                                                        const Color(0xFF7A7A7A),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '฿${myFormat.format(p.priceBeforeDiscount)}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.ibmPlexSansThai(
                                              color: const Color(0xFFF54900),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 8),
                                  // right qty fixed width-ish
                                  Text(
                                    'x ${p.amount}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ibmPlexSansThai(
                                      color: const Color(0xFF1F1F1F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF3F3F4), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$totalItems',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: const Color(0xFF00AEEF),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' ชิ้น',
                            style: GoogleFonts.ibmPlexSansThai(
                              color: const Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'ค่าคอมมิชชั่นที่ได้รับ : ',
                              style: GoogleFonts.ibmPlexSansThai(
                                color: const Color(0xFF5A5A5A),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: commissionAmount,
                              style: GoogleFonts.ibmPlexSansThai(
                                color: const Color(0xFF1F1F1F),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF5F5F5),
      child: Center(
        child: Icon(Icons.image_outlined, size: 22, color: Color(0xFFB7B7B7)),
      ),
    );
  }
}

// Utility: safely get first element or null
extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
