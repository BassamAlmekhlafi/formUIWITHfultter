import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complete Form - Single File',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Color(0xFF0A0759),
          inactiveTrackColor: Color(0xFFE5E5EA),
          thumbColor: Color(0xFF0A0759),
          overlayColor: Colors.blueAccent,
          valueIndicatorColor: Colors.blue,
        ),
      ),
      home: const CompleteFormScreen(),
    );
  }
}

class CompleteFormScreen extends StatefulWidget {
  const CompleteFormScreen({super.key});

  @override
  State<CompleteFormScreen> createState() => _CompleteFormScreenState();
}

class _CompleteFormScreenState extends State<CompleteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Demographics
  String? gender;
  String? country;

  // Date & Time
  DateTime? birthDate;
  TimeOfDay? preferredTime;

  // Sliders
  double satisfaction = 3.0;
  double progress = 0.5;
  RangeValues budget = const RangeValues(20, 80);

  // Preferences
  bool subscribe = false;
  bool agreeTerms = false;

  // Pickers
  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: preferredTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => preferredTime = picked);
  }

  void resetForm() {
    setState(() {
      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      ageController.clear();
      gender = null;
      country = null;
      birthDate = null;
      preferredTime = null;
      satisfaction = 3.0;
      progress = 0.5;
      budget = const RangeValues(20, 80);
      subscribe = false;
      agreeTerms = false;
      _formKey.currentState?.reset();
    });
  }

  void submitForm() {
    FocusScope.of(context).unfocus();
    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms and Conditions.')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final result = {
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'age': ageController.text.trim(),
        'gender': gender,
        'country': country,
        'birthDate': birthDate?.toIso8601String(),
        'preferredTime': preferredTime?.format(context),
        'satisfaction': satisfaction,
        'progressPercent': (progress * 100).round(),
        'budget': [budget.start.round(), budget.end.round()],
        'subscribe': subscribe,
        'agreeTerms': agreeTerms,
      };

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: SingleChildScrollView(child: Text(result.toString())),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(IconData icon, String label) {
    return InputDecoration(prefixIcon: Icon(icon), labelText: label, border: const OutlineInputBorder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Form Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: resetForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ===== Personal Information =====
            Text('Personal Information', style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            TextFormField(
              controller: fullNameController,
              decoration: _inputDecoration(Icons.person, 'Full Name *'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your name';
                if (v.trim().length < 3) return 'Name is too short';
                return null;
              },
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(Icons.email, 'Email Address *'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                final emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
                if (!emailReg.hasMatch(v.trim())) return 'Enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: _inputDecoration(Icons.lock, 'Password *'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter a password';
                if (v.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(Icons.phone, 'Phone Number'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final phoneReg = RegExp(r"^[0-9\-\+ ]{6,20}");
                if (!phoneReg.hasMatch(v.trim())) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(Icons.cake, 'Age'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final n = int.tryParse(v.trim());
                if (n == null) return 'Enter a valid number';
                if (n <= 0 || n > 120) return 'Enter a realistic age';
                return null;
              },
            ),

            const SizedBox(height: 18),

            // ===== Demographics =====
            Text('Demographics', style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              decoration: _inputDecoration(Icons.male, 'Select your gender'),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              value: gender,
              onChanged: (v) => setState(() => gender = v),
              validator: (v) => (v == null || v.isEmpty) ? 'Please select gender' : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: _inputDecoration(Icons.location_on, 'Select your country'),
              items: const [
                DropdownMenuItem(value: 'Yemen', child: Text('Yemen')),
                DropdownMenuItem(value: 'Saudi Arabia', child: Text('Saudi Arabia')),
                DropdownMenuItem(value: 'Egypt', child: Text('Egypt')),
                DropdownMenuItem(value: 'USA', child: Text('USA')),
                DropdownMenuItem(value: 'UK', child: Text('UK')),
              ],
              value: country,
              onChanged: (v) => setState(() => country = v),
              validator: (v) => (v == null || v.isEmpty) ? 'Please select country' : null,
            ),

            const SizedBox(height: 18),

            // ===== Date & Time =====
            Text('Date & Time', style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: pickBirthDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              birthDate == null
                                  ? "Birth Date"
                                  : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              preferredTime == null
                                  ? "Preferred Time"
                                  : preferredTime!.format(context),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),



            const SizedBox(height: 18),

            // ===== Ratings & Preferences =====
            Text('Ratings & Preferences', style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Satisfaction
            Text('Satisfaction Rating: ${satisfaction.toStringAsFixed(1)}'),
            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              value: satisfaction,
              label: satisfaction.toStringAsFixed(1),
              onChanged: (v) => setState(() => satisfaction = v),
            ),
            // digits under the slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("1"),
                Text("2"),
                Text("3"),
                Text("4"),
                Text("5"),
              ],
            ),

            const SizedBox(height: 12),

            // Progress
            Text('Progress Level: ${(progress * 100).round()}%'),
            Slider(
              min: 0,
              max: 1,
              divisions: 100,
              value: progress,
              label: '${(progress * 100).round()}%',
              onChanged: (v) => setState(() => progress = v),
            ),

            const SizedBox(height: 12),

            // Budget Range
            Text('Budget Range: \$${budget.start.round()} - \$${budget.end.round()}'),
            RangeSlider(
              values: budget,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels('\$${budget.start.round()}', '\$${budget.end.round()}'),
              onChanged: (r) => setState(() => budget = r),
            ),

            const SizedBox(height: 18),

            // ===== Preferences =====
            Text('Preferences', style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications),
              title: const Text('Subscribe to Newsletter'),
              subtitle: const Text('Receive updates and promotions'),
              value: subscribe,
              onChanged: (v) => setState(() => subscribe = v),
            ),


            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('I agree to the Terms and Conditions'),
              subtitle: const Text('You must agree to proceed'),
              value: agreeTerms,
              onChanged: (v) => setState(() => agreeTerms = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),



            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Submit Form', style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 8),

            Center(child: TextButton(onPressed: resetForm, child: const Text('Reset Form'))),
          ]),
        ),
      ),
    );
  }
}
