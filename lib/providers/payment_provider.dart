import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tonedaustralia/StripeIntegration/StripePaments.dart';
import 'package:tonedaustralia/app_router.dart';
import 'package:tonedaustralia/locator.dart';
import 'package:tonedaustralia/services/navigation_service.dart';

import '../main.dart';

class PaymentProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();

  StripePayments stripePayments = StripePayments();

  addSubscription(cardNo, expMon, expYear, cvc, amount) async {
    EasyLoading.show(status: "Loading ..");
    await checkifCurrentUserCustomerIdExist();
    if (customerID == "") {
      customerID = await stripePayments.createCustomer();
      final paymentMethod = await stripePayments.createPaymentMethod("$cardNo", "$expMon", "$expYear", "$cvc");

      await stripePayments.attachPaymentMethod(paymentMethod['id'], customerID);
      defaultPaymentMethodCardid = paymentMethod['id'];
      await stripePayments.setPaymentMethod(defaultPaymentMethodCardid);
      await stripePayments.createPaymentIntents(amount, defaultPaymentMethodCardid);
      await stripePayments.confirmPaymentIntents();

      await stripePayments.createSubscriptions(customerID, 'price_1MYMiVENCVTkEo9sp7TMXj0W', defaultPaymentMethodCardid);
      _navigationService.navigateReplace(AppRoute.mainScreen);
    } else {
      final paymentMethod = await stripePayments.createPaymentMethod("$cardNo", "$expMon", "$expYear", "$cvc");

      await stripePayments.attachPaymentMethod(paymentMethod['id'], customerID);
      defaultPaymentMethodCardid = paymentMethod['id'];
      await stripePayments.setPaymentMethod(defaultPaymentMethodCardid);
      await stripePayments.createPaymentIntents(amount, defaultPaymentMethodCardid);
      await stripePayments.confirmPaymentIntents();

      await stripePayments.createSubscriptions(customerID, 'price_1MYMiVENCVTkEo9sp7TMXj0W', defaultPaymentMethodCardid);
      _navigationService.navigateReplace(AppRoute.mainScreen);
    }
  }

  checkifCurrentUserCustomerIdExist() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(currentUserId);
    try {
      await firestore.collection('user').doc(currentUserId).get().then(
        (value) {
          customerID = value.get("customerId") ?? "";
        },
      );
    } catch (e) {
      print(e);
      customerID = "";
    }
  }
}
