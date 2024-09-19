import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PasswordStrengthChecker extends StatelessWidget {
  final String password;
  const PasswordStrengthChecker({super.key, required this.password});

  double calculatePasswordStrength() {
    double strength = 0.0;

    // Length check
    if (password.length >= 8) strength += 20;
    // Uppercase check
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 20;
    // Lowercase check
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 20;
    // Digit check
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 20;
    // Special character check
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 20;

    return strength;
  }

  Color getColor(double percentage) {
    if (percentage <= 30) {
      return Colors.red;
    } else if (percentage > 30 && percentage <= 50) {
      return Colors.orange;
    } else if (percentage > 50 && percentage <= 80) {
      return Colors.blue;
    } else if (percentage > 80) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  Widget textChecker(String text, bool value, TextStyle style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          value ? Icons.check_rounded : Icons.clear_rounded,
          size: 15.0,
          color: value ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 5.0),
        Text(
          text,
          style: style,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodySmall!;
    double thickness = 8.0;

    return password.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(thickness / 2),
                    child: SizedBox(
                        height: thickness + 25.0,
                        child: SfLinearGauge(
                          showTicks: false,
                          showLabels: false,
                          animateAxis: true,
                          axisTrackStyle: LinearAxisTrackStyle(
                            thickness: thickness,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            borderWidth: 1,
                            borderColor: Colors.grey[350],
                            color: Colors.grey[350],
                          ),
                          barPointers: <LinearBarPointer>[
                            LinearBarPointer(
                                value: calculatePasswordStrength(),
                                thickness: thickness,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                color: getColor(calculatePasswordStrength())),
                          ],
                          markerPointers: const [
                            LinearWidgetPointer(
                              value: 0,
                              enableAnimation: false,
                              position: LinearElementPosition.outside,
                              offset: 4,
                              child: Text(
                                'Empty',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                            ),
                            LinearWidgetPointer(
                              value: 30,
                              enableAnimation: false,
                              position: LinearElementPosition.outside,
                              offset: 4,
                              child: Text(
                                'Weak',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w700,
                                    color: Colors.red),
                              ),
                            ),
                            LinearWidgetPointer(
                              value: 50,
                              enableAnimation: false,
                              position: LinearElementPosition.outside,
                              offset: 4,
                              child: Text(
                                'Fair',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w700,
                                    color: Colors.orange),
                              ),
                            ),
                            LinearWidgetPointer(
                              value: 80,
                              enableAnimation: false,
                              position: LinearElementPosition.outside,
                              offset: 4,
                              child: Text(
                                'Good',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              ),
                            ),
                            LinearWidgetPointer(
                              value: 100,
                              enableAnimation: false,
                              position: LinearElementPosition.outside,
                              offset: 4,
                              child: Text(
                                'Strong',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w700,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ))),
                Text("Enter a password that contains: ", style: style),
                textChecker(
                    "Atleast 8 characters", password.length >= 8, style),
                textChecker("Atleast 1 lowercase letter",
                    RegExp(r'[a-z]').hasMatch(password), style),
                textChecker("Atleast 1 uppercase letter",
                    RegExp(r'[A-Z]').hasMatch(password), style),
                textChecker("Atleast 1 digit",
                    RegExp(r'[0-9]').hasMatch(password), style),
                textChecker("Atleast 1 special character",
                    RegExp(r'[!@#\$&*~]').hasMatch(password), style),
              ],
            ),
          );
  }
}
