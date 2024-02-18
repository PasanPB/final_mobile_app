import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blood Pressure Classifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => BloodPressureInputPage(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: '/result',
          page: () => BloodPressureResultPage(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: '/info',
          page: () => BloodPressureInfoPage(),
          transition: Transition.rightToLeftWithFade,
        ),
      ],
    );
  }
}

// Blood Pressure Input Page
class BloodPressureInputPage extends StatelessWidget {
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();

  bool _isValidData(int systolic, int diastolic) {
    return systolic > 0 && diastolic > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/top-view-tensiometer-checking-blood-pressure.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  'Please Enter Your Blood Pressure',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: systolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Systolic Pressure (mmHg)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Diastolic Pressure (mmHg)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    int systolic = int.tryParse(systolicController.text) ?? 0;
                    int diastolic = int.tryParse(diastolicController.text) ?? 0;

                    if (_isValidData(systolic, diastolic)) {
                      Get.toNamed('/result', arguments: {'systolic': systolic, 'diastolic': diastolic});
                    } else {
                      Get.defaultDialog(
                        title: 'Invalid Data',
                        content: Text('Please enter valid systolic and diastolic values.'),
                        confirm: ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('OK'),
                        ),
                      );
                    }
                  },
                  child: Text('Classify', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Blood Pressure Result Page
class BloodPressureResultPage extends StatelessWidget {
  final Map<String, dynamic> arguments = Get.arguments;

  final Map<String, String> categoryInfo = {
    'Normal': 'Your blood pressure is in the normal range. Keep up the healthy lifestyle!',
    'Elevated': 'Your blood pressure is elevated. It\'s a sign to watch your lifestyle and consult a doctor if necessary.',
    'Hypertension Stage 1': 'Your blood pressure is in Hypertension Stage 1. It\'s recommended to consult a doctor for further evaluation and treatment.',
    'Hypertension Stage 2': 'Your blood pressure is in Hypertension Stage 2. Please consult a doctor immediately for proper treatment.',
  };

  String classifyBloodPressure(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'Normal';
    } else if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      return 'Elevated';
    } else if ((systolic >= 130 && systolic <= 139) || (diastolic >= 80 && diastolic <= 89)) {
      return 'Hypertension Stage 1';
    } else if (systolic >= 140 || diastolic >= 90) {
      return 'Hypertension Stage 2';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    int systolic = arguments['systolic'];
    int diastolic = arguments['diastolic'];
    String category = classifyBloodPressure(systolic, diastolic);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Result'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/qtq80-pWg7Ir.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your blood pressure is classified as:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  category,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    categoryInfo[category] ?? 'No information available',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/info', arguments: {'category': category});
                  },
                  child: Text('Show Info', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Blood Pressure Info Page
class BloodPressureInfoPage extends StatelessWidget {
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    String category = arguments['category'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Category Information'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            category,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}





