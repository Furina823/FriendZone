import 'package:flutter/material.dart';
import 'package:friendzone_application/model/attendance.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'QRscannerOverlay.dart';
import 'package:geolocator/geolocator.dart';

class QrScan extends StatefulWidget {
  final String user_id;
  const QrScan({super.key, required this.user_id});

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_left_sharp,
                size: 50,
              ),
              color: Color(0xff4C315C),
            ),
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Scan QR Code For Rewards",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture barcodeCapture) =>
                _foundBarcode(barcodeCapture),
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
              child: Text('Enable'),
            ),
          ],
        ),
      );
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _foundBarcode(BarcodeCapture barcodeCapture) async {
    if (_screenOpened) return;

    setState(() {
      _screenOpened = true;
    });

    Position currentLocation = await _determinePosition();

    final Barcode barcode = barcodeCapture.barcodes.first;
    final String code = barcode.rawValue ?? "___";
    final Map<String, String> extractedInfo = _parseQRCodeData(code);

    print("QR Code Data: $code");
    print("Extracted Info: $extractedInfo");

    if (extractedInfo.isNotEmpty) {
      final String? eventId = extractedInfo['event_id'];
      final double? eventLat = double.tryParse(extractedInfo['event_lat'] ?? '');
      final double? eventLng = double.tryParse(extractedInfo['event_long'] ?? '');

      print("Event ID: $eventId");
      print("Parsed Latitude: $eventLat");
      print("Parsed Longitude: $eventLng");

      if (eventId != null && eventLat != null && eventLng != null) {
        final LatLng eventLatLng = LatLng(eventLat, eventLng);
        final LatLng currentLatLng = LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );

        final double distance = Geolocator.distanceBetween(
          currentLatLng.latitude,
          currentLatLng.longitude,
          eventLatLng.latitude,
          eventLatLng.longitude,
        );

        if (distance < 500) {
          // Check if the attendance already exists
          bool exists = await checkAttendanceExists(eventId, widget.user_id);

          if (exists) {
            if (mounted) {
              _showErrorDialog('Event Attendance already updated.');
            }
          } else {
            await createAttendance(eventId, widget.user_id);

            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text(
                    "Successful!",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xff4C315C),
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  backgroundColor: Color(0xffD9D9D9),
                  children: [
                    const Text(
                      "Your QR code has been successfully scanned.",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Color(0xff4C315C), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            }
          }
        } else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text(
                  "Out Of Range!",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xff4C315C),
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                backgroundColor: Color(0xffD9D9D9),
                children: [
                  const Text(
                    "Unable to scan QR code. Please try again.",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Color(0xff4C315C), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
        }
      } else {
        if (mounted) {
          _showErrorDialog('Invalid event data from QR code.');
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  _screenOpened = false; // Reset flag after dialog is closed
                });
              },
              child: Text('Continue'),
            ),
          ],
        ),
      );
    }
  }


  

  Future<bool> checkAttendanceExists(String eventId, String userId) async {
    try {
      // Fetch all attendances
      List<Attendance> attendances = await fetchAttendances();

      // Check if any record matches the event_id and user_id
      for (var attendance in attendances) {
        if (attendance.event_id.toString() == eventId && attendance.user_id.toString() == userId) {
          return true; // Record exists
        }
      }
      return false; // No matching record found
    } catch (e) {
      print('Error checking attendance: $e');
      return false; // In case of an error, assume the record does not exist
    }
  }


  Map<String, String> _parseQRCodeData(String data) {
    final Map<String, String> parsedData = {};
    final lines = data.split('\n');

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        parsedData[parts[0].trim()] = parts[1].trim();
      }
    }

    print("Parsed QR Code Data: $parsedData"); // Add this line for debugging

    return parsedData;
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
