import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'portfolio_page.dart';
import 'investing_complete_page.dart';
import 'price_service.dart';

void main() {
  runApp(const SalaryPilotApp());
}

class SalaryPilotApp extends StatelessWidget {
  const SalaryPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Pilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050816),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SalarySplitPage(),
    );
  }
}

class SalarySplitPage extends StatefulWidget {
  const SalarySplitPage({super.key});

  @override
  State<SalarySplitPage> createState() => _SalarySplitPageState();
}

class _SalarySplitPageState extends State<SalarySplitPage> {
  double spending = 50;
  double savings = 20;
  double investing = 30;
  final double salary = 50000;

  @override
  void initState() {
    super.initState();
    // START GLOBAL LIVE UPDATES
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PriceService().startGlobalUpdates();
    });
  }

  @override
  void dispose() {
    PriceService().stopUpdates();
    super.dispose();
  }

  void _normalize() {
    final total = spending + savings + investing;
    if (total == 0) return;
    setState(() {
      spending = (spending / total) * 100;
      savings = (savings / total) * 100;
      investing = (investing / total) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spendingAmt = (salary * spending / 100).round();
    final savingsAmt = (salary * savings / 100).round();
    final investingAmt = (salary * investing / 100).round();

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF050816), Color(0xFF111827)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Salary Pilot',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.flight_takeoff, size: 16, color: Colors.amber),
                          SizedBox(width: 6),
                          Text(
                            'Autopilot: OFF',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Salary card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7C3AED).withOpacity(0.9),
                        const Color(0xFFEC4899).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This month salary detected',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${salary.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.eco, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Aim for sustainable growth this month',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Splits
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      _buildSplitCard(
                        label: 'Spending',
                        color: const Color(0xFF22C55E),
                        icon: Icons.credit_card,
                        percentage: spending,
                        amount: spendingAmt,
                        onChanged: (v) {
                          setState(() => spending = v);
                          _normalize();
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildSplitCard(
                        label: 'Savings',
                        color: const Color(0xFF0EA5E9),
                        icon: Icons.savings,
                        percentage: savings,
                        amount: savingsAmt,
                        onChanged: (v) {
                          setState(() => savings = v);
                          _normalize();
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildSplitCard(
                        label: 'Investing',
                        color: const Color(0xFFF97316),
                        icon: Icons.trending_up,
                        percentage: investing,
                        amount: investingAmt,
                        onChanged: (v) {
                          setState(() => investing = v);
                          _normalize();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Approve button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InvestingCompletePage()),
                      );
                    },
                    child: const Text(
                      'Approve & Let Pilot Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitCard({
    required String label,
    required Color color,
    required IconData icon,
    required double percentage,
    required int amount,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${percentage.toStringAsFixed(0)}%  ·  ₹$amount',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              thumbColor: color,
              activeTrackColor: color,
              inactiveTrackColor: Colors.white12,
            ),
            child: Slider(
              value: percentage,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}