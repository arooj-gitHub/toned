import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_router.dart';
import '../locator.dart';
import '../main.dart';
import '../services/navigation_service.dart';

String defaultPaymentMethodCardBrand = "", defaultPaymentMethodCardlast4 = "", defaultPaymentMethodCardid = "", customerSubscriptionID = "";
String customerID = "", paymentIntentId = '';
DateTime subscribedAt = DateTime.now();

class StripePayments {
  final client = http.Client();
  String email = "";
  final NavigationService _navigationService = locator<NavigationService>();

  static Map<String, String> headers = {
    'Authorization': 'Bearer sk_test_51C8Ko3ENCVTkEo9sCpmeyZ7ePDMqFevulJeFbM9NwAOmqU1Tp2ivPu77pWOKO8ihesuRxfm32eVrpIx2kSKHLy7T004ZMlaCub',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  createCustomer() async {
    await getCustomerEmail();
    const String url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'description': "customer added",
        'name': email,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var resp = jsonDecode(response.body);
      customerID = resp['id'];
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("customerId", customerID);
      print(customerID);
      EasyLoading.showSuccess('Customer added successfully');
      return customerID;
    } else {
      var err = json.decode(response.body);
      var errMessage = err['error']['message'];
    }
  }

  createPaymentMethod(String number, String expMonth, String expYear, String cvc) async {
    EasyLoading.show(status: "Loading ...");
    String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'type': 'card',
        'card[number]': number,
        'card[exp_month]': expMonth,
        'card[exp_year]': expYear,
        'card[cvc]': cvc,
      },
    );
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Card added successfully');

      return json.decode(response.body);
    } else {
      var error = json.decode(response.body);

      throw 'Failed to create PaymentMethod.';
    }
  }

  createPaymentIntents(amount, defaultcard) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': 'AUD',
        'payment_method_types[]': 'card',
        'customer': customerID,
        "payment_method": defaultcard,
      };
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: headers);
      var res = jsonDecode(response.body);
      paymentIntentId = res['id'].toString();
      print(res['payment_method']);

      print(res['status']);
      return jsonDecode(response.body);
    } catch (e) {
      print("payment secon eo=ror");
      print('Exception $e');
    }
  }

  setPaymentMethod(String defaultpaymentMethodID) async {
    String url = 'https://api.stripe.com/v1/customers/$customerID';
    var response = await http.post(Uri.parse(url), headers: headers, body: {
      'invoice_settings[default_payment_method]': defaultpaymentMethodID,
    });

    if (response.statusCode == 200) {
      var responseTemp = json.decode(response.body);
      print(responseTemp);

      return (responseTemp);
    } else {
      print('Error');
    }
  }

  confirmPaymentIntents() async {
    String url = "https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm";
    try {
      var body = {
        'payment_method': defaultPaymentMethodCardid,
      };
      var response = await http.post(Uri.parse(url), body: body, headers: headers);
      var res = jsonDecode(response.body);
      print(res);

      print(res['status']);

      return jsonDecode(response.body);
    } catch (e) {
      print("in this section");
      print('Exception $e');
    }
  }

  attachPaymentMethod(String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to attach PaymentMethod.';
    }
  }

  Future createSubscriptions(String customerId, itemPriceID, defaultPaymentMethodCardid) async {
    String url = 'https://api.stripe.com/v1/subscriptions';
    Map<String, dynamic> body = {
      'customer': customerId,
      'items[0][price]': itemPriceID,
    };
    EasyLoading.show(status: "Loading ..");
    var response = await client.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['items']['data'][0]['price']['product']);
      print(res['items']['data'][0]['price']['recurring']['interval']);
      print(res['status']);

      customerSubscriptionID = res['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerSubscriptionID', customerSubscriptionID);

      await updateUserSubscriptionStatus();

      EasyLoading.showSuccess('Subscription has been created');
      EasyLoading.dismiss();
      return customerSubscriptionID;
    } else {
      print(response.body);
      throw 'Failed to register as a subscriber.';
    }
  }

  Future cancelSubscription(customerSubscriptionID, context) async {
    EasyLoading.show(status: "Loading ..");
    String url = 'https://api.stripe.com/v1/subscriptions/$customerSubscriptionID';
    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      customerSubscriptionID = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerSubscriptionID', customerSubscriptionID);
      await updateCurrentUserSubscriptionValuesFromDb();
      EasyLoading.showSuccess('Subscription has been cancelled successfully');
      EasyLoading.dismiss();
      // Navigator.push(context, PageViewTransition(builder: (_) => const MemberShip()));
      _navigationService.navigateAndRemoveUntilReplace(AppRoute.mainScreen);

      return json.decode(response.body);
    } else {
      customerSubscriptionID = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerSubscriptionID', customerSubscriptionID);
      EasyLoading.showError("Something went wrong");
      EasyLoading.dismiss();
      print(response.body);
    }
  }

  Future cancelSubscription2(customerSubscriptionID) async {
    EasyLoading.show(status: "Loading ..");
    String url = 'https://api.stripe.com/v1/subscriptions/$customerSubscriptionID';
    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await getcurrentUserSubscribedAtDate();

      customerSubscriptionID = "";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerSubscriptionID', customerSubscriptionID);
      await updateCurrentUserSubscriptionValuesFromDb();
      EasyLoading.showSuccess('Subscription has been cancelled successfully');
      EasyLoading.dismiss();

      return json.decode(response.body);
    } else {
      customerSubscriptionID = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('customerSubscriptionID', customerSubscriptionID);
      EasyLoading.showError("Something went wrong");
      EasyLoading.dismiss();
      print(response.body);
    }
  }

  updateUserSubscriptionStatus() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('user').doc(currentUserId).update({
      "status": 1,
      'subscribedAt': DateTime.now(),
      "customerId": customerID,
      "subscriptionId": customerSubscriptionID,
    });
  }

  getCustomerEmail() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('user').doc(currentUserId).get().then(
      (value) {
        email = value.get("email");
      },
    );
  }

  updateCurrentUserSubscriptionValuesFromDb() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('user').doc(currentUserId).update({
      "status": 0,
      "cancelSubscriptionAt": DateTime.now(),
      "customerId": customerID,
      "subscriptionId": "",
    });
    customerSubscriptionID = "";
  }

  getcurrentUserSubscribedAtDate() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('user').doc(currentUserId).get().then(
      (value) {
        subscribedAt = value.get("subscribedAt");
      },
    );
  }
}
