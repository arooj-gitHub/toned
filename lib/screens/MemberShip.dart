import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_router.dart';
import '../style/colors.dart';
import 'Subscription/card_details.dart';

class MemberShip extends StatefulWidget {
  const MemberShip({super.key});

  @override
  State<MemberShip> createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  bool isSelectPlanA = false, isSelectPlanB = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgLightColor,
        body: Container(
          margin: const EdgeInsets.only(left: 22, right: 22, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back,
                        color: textDarkColor,
                        size: 20,
                      ),
                    ),
                    onTap: () {},
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Membership",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Choose your plan",
                style: TextStyle(
                  color: textDarkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "By becoming a member you can read on any device,read with no adds and offline",
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*  GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelectPlanB = false;
                            isSelectPlanA = true;
                          });
                        },
                        child: Container(
                          width: 125,
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: isSelectPlanA ? const Color(0xff002366) : Colors.grey.shade300),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              paymentSelectionTickIconForPlanA(),
                              const SizedBox(height: 15),
                              Text(
                                "Monthly",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "\$ 9.99",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Billed every month",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
  */
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelectPlanB = true;
                            isSelectPlanA = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 25),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: const Color(0xff002366)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              paymentSelectionTickIconForPlanB(),
                              const SizedBox(height: 15),
                              Text(
                                "Monthly",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "80 AUD/month",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Billed every 12 month",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  if (!kDebugMode) {
                    FirebaseAnalytics.instance.logEvent(
                      name: 'plan_selected',
                    );
                  }
                  Navigator.push(
                      context,
                      PageViewTransition(
                          builder: (_) => CardDetails(amount: "80")));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xff002366),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Select Plan",
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
        ),
      ),
    );
  }

  Widget paymentSelectionTickIconForPlanA() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isSelectPlanA ? const Color(0xff002366) : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget paymentSelectionTickIconForPlanB() {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        color: Color(0xff002366),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
