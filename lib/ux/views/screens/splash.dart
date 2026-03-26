
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/splash/bloc.dart";
import "../../res/app_drawables.dart";
import "../../res/app_strings.dart";
import "../../utils/shared/screen.dart";
import "../components/shared/footer.dart";


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashBloc splashBloc;

  @override
  void initState() {
    splashBloc = context.read<SplashBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashBloc.add(SplashInitEvent(context: context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, SplashState state) {
        return PopScope(
          canPop: state is SplashErrorState,
          child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              bottomNavigationBar: supportInfo(),body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppDrawables.loadingScreen),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Center(
                    child: SvgPicture.asset(
                      AppDrawables.logoSVG,
                      width: 150,
                      height: 70,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.1),
                  CupertinoActivityIndicator(radius: 18, color: Colors.white),
                  Spacer(),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


// // complete a sale
// await isar.writeTxn(() async {
// // 1. save completed order
// final order = SaleOrder()
// ..orderNumber = 'ORD-001'
// ..status = SaleOrderStatus.completed
// ..items = cartItems
// ..subtotal = subtotal
// ..discountAmount = discount
// ..taxAmount = tax
// ..totalAmount = total
// ..createdByUserId = currentUserId
// ..createdAt = DateTime.now()
// ..completedAt = DateTime.now();
// final orderId = await isar.saleOrders.put(order);
//
// // 2. record transaction
// await isar.transactions.put(Transaction()
// ..transactionNumber = 'TXN-001'
// ..saleOrderId = orderId
// ..orderNumber = order.orderNumber
// ..paymentMethod = PaymentMethod.cash
// ..status = TransactionStatus.completed
// ..amountPaid = amountPaid
// ..changeGiven = amountPaid - total
// ..totalAmount = total
// ..processedByUserId = currentUserId
// ..timestamp = DateTime.now());
//
// // 3. deduct stock for each item
// for (final item in cartItems) {
// final product = await isar.products.get(item.productId);
// if (product != null) {
// final before = product.stockQuantity;
// product.stockQuantity -= item.quantity;
// await isar.products.put(product);
//
// await isar.inventoryLogs.put(InventoryLog()
// ..productId = product.id
// ..productName = product.name
// ..action = InventoryAction.saleDeduction
// ..quantityChanged = -item.quantity
// ..quantityBefore = before
// ..quantityAfter = product.stockQuantity
// ..performedByUserId = currentUserId
// ..timestamp = DateTime.now());
// }
// }
// });



// adjust stock
// await isar.writeTxn(() async {
// final product = await isar.products.get(productId);
// if (product != null) {
// final before = product.stockQuantity;
// product.stockQuantity += adjustQty;
// product.updatedAt = DateTime.now();
// await isar.products.put(product);
//
// await isar.inventoryLogs.put(InventoryLog()
// ..productId = product.id
// ..productName = product.name
// ..action = InventoryAction.adjustment
// ..quantityChanged = adjustQty
// ..quantityBefore = before
// ..quantityAfter = product.stockQuantity
// ..performedByUserId = currentUserId
// ..timestamp = DateTime.now());
// }
// });

// create user
// await isar.writeTxn(() async {
// await isar.users.put(User()
// ..name = 'John'
// ..email = 'john@pos.com'
// ..passwordHash = hashPassword('1234')
// ..role = UserRole.cashier
// ..isActive = true
// ..createdAt = DateTime.now());
// });