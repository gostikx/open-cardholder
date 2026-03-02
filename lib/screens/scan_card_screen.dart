import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide BarcodeType;
import 'package:barcode_widget/barcode_widget.dart' hide Barcode;

class ScanCardScreen extends ConsumerStatefulWidget {
  const ScanCardScreen({super.key});

  @override
  ConsumerState<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends ConsumerState<ScanCardScreen> {
  BarcodeType _selectedType = BarcodeType.Code128;

  MobileScannerController? _scannerController;
  bool _isScanning = true;
  String _scannedCode = '';
  bool _codeDetected = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning || _codeDetected) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String code = barcode.rawValue ?? '';
      if (code.isNotEmpty) {
        setState(() {
          _scannedCode = code;
          _codeDetected = true;
          _isScanning = false;
        });

        // Auto-detect barcode type based on the scanned code
        _autoDetectBarcodeType(barcode.format);

        // Stop scanning after successful detection
        _scannerController?.stop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                Text('Code detected: $code'),
                Text('Barcode format: $_selectedType'),
              ],
            ),
            action: SnackBarAction(
              label: 'Continue Scanning',
              onPressed: () {
                setState(() {
                  _codeDetected = false;
                  _isScanning = true;
                });
                _scannerController?.start();
              },
            ),
          ),
        );
      }
    }
  }

  void _autoDetectBarcodeType(BarcodeFormat format) {
    // Simple heuristic to detect barcode type
    BarcodeType barcodeType = BarcodeType.Code128;

    switch (format) {
      case BarcodeFormat.code39:
        barcodeType = BarcodeType.Code39;
      case BarcodeFormat.code93:
        barcodeType = BarcodeType.Code93;
      case BarcodeFormat.ean8:
        barcodeType = BarcodeType.CodeEAN8;
      case BarcodeFormat.ean13:
        barcodeType = BarcodeType.CodeEAN13;
      case BarcodeFormat.code128:
        barcodeType = BarcodeType.Code128;
      case BarcodeFormat.dataMatrix:
        barcodeType = BarcodeType.DataMatrix;
      case BarcodeFormat.aztec:
        barcodeType = BarcodeType.Aztec;
      case BarcodeFormat.pdf417:
        barcodeType = BarcodeType.PDF417;
      case BarcodeFormat.qrCode:
        barcodeType = BarcodeType.QrCode;
      case BarcodeFormat.upcA:
        barcodeType = BarcodeType.CodeUPCA;
      case BarcodeFormat.upcE:
        barcodeType = BarcodeType.CodeUPCE;
      case BarcodeFormat.codabar:
        barcodeType = BarcodeType.Codabar;
      default:
        barcodeType = BarcodeType.Code128;
    }
    setState(() {
      _selectedType = barcodeType; // Default for longer codes
    });
  }

  void _startScanning() {
    setState(() {
      _codeDetected = false;
      _isScanning = true;
      _scannedCode = '';
    });
    _scannerController?.start();
  }

  void _toggleTorch() {
    _scannerController?.toggleTorch();
  }

  void _switchCamera() {
    _scannerController?.switchCamera();
  }

  void _saveCard() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Card saved')));
    GoRouter.of(context).pop();
  }

  void _returnScannedCode() {
    if (_scannedCode.isNotEmpty) {
      // Return the scanned code and type to the calling screen
      GoRouter.of(context).pop({'code': _scannedCode, 'type': _selectedType});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No code has been scanned yet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner view
          MobileScanner(
            controller: _scannerController!,
            fit: BoxFit.cover,
            onDetect: _onDetect,
            overlayBuilder: (context, constraints) {
              return _buildScanOverlay();
            },
          ),

          // Top Action Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.flashlight_on,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: _toggleTorch,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _codeDetected ? _returnScannedCode : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E3E1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _codeDetected
                            ? 'Use detected code'
                            : 'Show your QR code',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Navigation indicator simulation (bottom bar)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Stack(
      children: [
        // Dark overlay with transparent center
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.7),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scanner frame with corners
        Center(
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
                Positioned(
                  bottom: -110,
                  left: -50,
                  right: -50,
                  child: Column(
                    children: [
                      Text(
                        _codeDetected
                            ? 'Code detected!'
                            : 'Scan a card QR code',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
