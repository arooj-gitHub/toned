import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tonedaustralia/providers/payment_provider.dart';

import '../../style/colors.dart';

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
  dinnerClub
}

class CardDetails extends StatelessWidget {
  CardDetails({super.key, required this.amount});
  String amount;
  final formKey = GlobalKey<FormState>();
  var cardNo = TextEditingController();
  var expiry = TextEditingController();
  var cvc = TextEditingController();
  bool isBtnLoading = false;

  var cardMask = MaskTextInputFormatter(
      mask: 'xxxx xxxx xxxx xxxx', filter: {"x": RegExp(r'[0-9]')});
  var expiryMask =
      MaskTextInputFormatter(mask: 'xx/xx', filter: {"x": RegExp(r'[0-9]')});
  String cardError = "";
  String carnoErr = "";
  String expiryerr = "";
  String cvcErr = "";

  String expYear = "", expMon = "";
  Map<CardType, Set<List<String>>> cardNumberPattern = {
    CardType.visa: {
      ['4'],
    },
    CardType.americanExpress: {
      ['34'],
      ['37'],
    },
    CardType.discover: {
      ['6011'],
      ['622126', '622925'],
      ['644', '649'],
      ['65']
    },
    CardType.mastercard: {
      ['51', '55'],
      ['2221', '2229'],
      ['223', '229'],
      ['23', '26'],
      ['270', '271'],
      ['2720'],
    },
    CardType.dinnerClub: {
      ['54'],
      ['300', '305'],
      ['3095'],
      ['36'],
      ['38', '39'],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, paymentProvide, wid) {
      return Container(
        color: Colors.white,
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(
              left: 22,
              right: 22,
              top: MediaQuery.of(context).padding.top + 25,
              bottom: 22,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Add Card Details",
                          style: TextStyle(
                            color: textDarkColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        /*  Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child:Text ,
                          ),
                        ), */
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Card Number",
                                style: TextStyle(
                                  color: Color(0xff4B5563),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: cardNo,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            textInputAction: TextInputAction.next,
                            inputFormatters: [cardMask],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            onChanged: (value) {
                              String displayValue = cardMask.getUnmaskedText();

                              String valueCheck = cardMask.getUnmaskedText();
                              //cardNoError = valueCheck;

                              if (displayValue.length < 16) {
                                cardError = "you must 16-digit card number";
                              } else {
                                cardError = "";
                              }
                            },
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              hintText: "XXXX XXXX XXXX XXXX",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xffCDD7E1),
                                  width: 1,
                                ),
                              ),
                              isDense: true,
                              // important line
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 0),

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xffFE5960),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color(0xffCDD7E1),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(cardError,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "Expiration date",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: expiry,
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [expiryMask],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  onChanged: (value) {
                                    String displayValue =
                                        expiryMask.getUnmaskedText();
                                    expiryerr = value;
                                  },
                                  textAlign: TextAlign.justify,
                                  decoration: InputDecoration(
                                    hintText: "MM/YY",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffCDD7E1),
                                        width: 1,
                                      ),
                                    ),
                                    isDense: true,
                                    // important line
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffFE5960),
                                        width: 1,
                                      ),
                                    ),
                                    // enabledBorder: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffCDD7E1),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "CVC",
                                    style: TextStyle(
                                      color: Color(0xff4B5563),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: cvc,
                                  textInputAction: TextInputAction.done,
                                  maxLength: 6,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: false),
                                  validator: (value) {
                                    return null;
                                  },
                                  onChanged: (value) {},
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.justify,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffCDD7E1),
                                        width: 1,
                                      ),
                                    ),
                                    isDense: true,
                                    // important line
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 0),
                                    // enabledBorder: InputBorder.none,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffFE5960),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xffCDD7E1),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: isBtnLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 350,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff002366),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              "Subscribe",
                              style: TextStyle(
                                color: textLightColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (cvc.text.isEmpty ||
                                  cardNo.text.isEmpty ||
                                  expiry.text.isEmpty) {
                                EasyLoading.showError('Fields cannot be null');
                              } else {
                                EasyLoading.show(status: "Loading ..");
                                expYear = expiry.text.split('/')[1];
                                expMon = expiry.text.split('/')[0];
                                if (cardNo.text.length < 16) {
                                  EasyLoading.showError('Card no not valid');
                                  EasyLoading.dismiss();
                                } else {
                                  await paymentProvide.addSubscription(
                                      cardNo.text,
                                      expMon,
                                      expYear,
                                      cvc.text,
                                      double.parse(amount));
                                  if (!kDebugMode) {
                                    FirebaseAnalytics.instance.logEvent(
                                      name: 'subscription_confirmed',
                                    );
                                  }

                                  EasyLoading.dismiss();
                                }
                              }
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
      /* Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cardno,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: const Text('Enter card Number'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: expMon,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text('Expire Month'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: expYear,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: const Text('Expire Year'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: cvc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: const Text('CVC'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    EasyLoading.show(status: 'Loading...');
                    await paymentProvide.addSubscription(cardno.text, expMon.text, expYear.text, cvc.text, double.parse(amount));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 1.2,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xff002366),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Subscribe",
                          style: TextStyle(
                            color: textLightColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )); */
    });
  }

  //paymentProvide.addSubscription(cardno.text, expMon.text, expYear.text, cvc.text, double.parse(amount));
}
