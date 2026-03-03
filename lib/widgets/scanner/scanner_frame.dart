import 'package:flutter/material.dart';

class ScannerFrame extends StatelessWidget {
  final Widget? instructionsWidget;

  const ScannerFrame({super.key, this.instructionsWidget});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: SizedBox(
            width: 320,
            height: 320,
            child: Stack(
              children: [
                // Corner indicators - Top-left (Google Red)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFEA4335), width: 10),
                        left: BorderSide(color: Color(0xFFEA4335), width: 10),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                // Top-right (Google Yellow/Orange)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFBBC04), width: 10),
                        right: BorderSide(color: Color(0xFFFBBC04), width: 10),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                // Bottom-left (Google Blue)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF4285F4), width: 10),
                        left: BorderSide(color: Color(0xFF4285F4), width: 10),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                // Bottom-right (Google Green)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF34A853), width: 10),
                        right: BorderSide(color: Color(0xFF34A853), width: 10),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),

                // Instructions
                instructionsWidget!,
                // Positioned(
                //   bottom: -110,
                //   left: -50,
                //   right: -50,
                //   child: Column(
                //     children: [
                //       Text(
                //         _codeDetected
                //             ? 'Code detected!'
                //             : 'Scan a card QR code',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 26,
                //           fontWeight: FontWeight.w400,
                //           letterSpacing: 0.5,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
  }
}