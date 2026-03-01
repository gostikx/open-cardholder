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
        _autoDetectBarcodeType(code);

        // Stop scanning after successful detection
        _scannerController?.stop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Code detected: $code'),
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

  void _autoDetectBarcodeType(String code) {
    // Simple heuristic to detect barcode type
    if (code.length <= 13 && code.contains(RegExp(r'^[0-9]+$'))) {
      setState(() {
        _selectedType = BarcodeType.Code128; // EAN/UPC codes
      });
    } else if (code.length > 13) {
      setState(() {
        _selectedType = BarcodeType.Code128; // Default for longer codes
      });
    }
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
        const SnackBar(
          content: Text('No code has been scanned yet'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Scan Card'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Scanner view
          MobileScanner(
            controller: _scannerController!,
            fit: BoxFit.cover,
            onDetect: _onDetect,
          ),

          // Overlay with scanning frame
          _buildScanOverlay(),

          // Controls and form
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: _buildControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          width: 300,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Corner indicators
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 3),
                      left: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 3),
                      right: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 3),
                      left: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 3),
                      right: BorderSide(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),

              // Instructions
              if (!_codeDetected)
                const Center(
                  child: Text(
                    'Align the barcode within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _codeDetected ? null : _startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _codeDetected ? Colors.grey : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _codeDetected ? 'Code Detected' : 'Start Scanning',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Save Card', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Return code button
        if (_codeDetected)
          ElevatedButton(
            onPressed: _returnScannedCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Use This Code', style: TextStyle(fontSize: 16)),
          ),

        const SizedBox(height: 8),

        // Camera controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.flashlight_on, color: Colors.white),
              onPressed: _toggleTorch,
              tooltip: 'Toggle Flashlight',
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.switch_camera, color: Colors.white),
              onPressed: _switchCamera,
              tooltip: 'Switch Camera',
            ),
          ],
        ),
      ],
    );
  }
}
