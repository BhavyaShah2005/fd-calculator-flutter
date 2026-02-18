import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FDCalculator(),
    );
  }
}

class FDCalculator extends StatefulWidget {
  const FDCalculator({super.key});

  @override
  State<FDCalculator> createState() => _FDCalculatorState();
}

class _FDCalculatorState extends State<FDCalculator> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  double interest = 0;
  double total = 0;

  List posts = [];

  // FD Calculation
  void calculateFD() {
    double principal = double.parse(amountController.text);
    double rate = double.parse(rateController.text);
    double time = double.parse(periodController.text);

    interest = (principal * rate * time) / (100 * 12);
    total = principal + interest;

    setState(() {});
  }

  // API Call
  Future fetchPosts() async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts(); // call API when app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fixed Deposit Calculator"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INPUT FIELDS
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Deposit Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Annual Interest Rate (%)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: periodController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Period (in months)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: calculateFD,
              child: const Text("CALCULATE"),
            ),

            const SizedBox(height: 20),

            Text(
              "Interest: ₹ ${interest.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),

            Text(
              "Total: ₹ ${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              "Sample API Data (First 5 Posts)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // LISTVIEW FROM API
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length > 5 ? 5 : posts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(title: Text(posts[index]['title'])),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
