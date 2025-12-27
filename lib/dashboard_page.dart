import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'portfolio_page.dart';
import 'price_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050816), Color(0xFF111827)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
              // Top bar with back button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Salary Pilot Dashboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF22C55E).withOpacity(0.2),
                        border: Border.all(color: const Color(0xFF22C55E), width: 1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_takeoff, size: 14, color: Color(0xFF22C55E)),
                          SizedBox(width: 4),
                          Text('ON', style: TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // LIVE Performance cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: PriceService().priceStream,
                  builder: (context, snapshot) {
                    final totalPrices = snapshot.data ?? PriceService().getCurrentPrices();
                    final totalValue = totalPrices.values.fold<double>(0, (sum, data) => sum + (data['price'] as num).toDouble());
                    final totalChange = totalPrices.values.fold<double>(0, (sum, data) => sum + (double.tryParse(data['change'].toString()) ?? 0));
                    
                    return Row(
                      children: [
                        Expanded(
                          child: _buildLivePerformanceCard(
                            title: 'Portfolio Value',
                            value: '₹${totalValue.round()}',
                            change: '+${(totalValue * 0.116).round()}',
                            changePercent: '+11.6%',
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLivePerformanceCard(
                            title: 'Monthly Return',
                            value: '${(11.8 + (totalChange / 5)).toStringAsFixed(1)}%',
                            change: '+0.4%',
                            changePercent: '+2.9%',
                            color: const Color(0xFFF97316),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Portfolio pie chart + Expandable investing details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.03),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.pie_chart, color: Color(0xFF7C3AED), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Current Allocation',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFF22C55E),
                                value: 50,
                                radius: 55,
                                title: '50%',
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF0EA5E9),
                                value: 20,
                                radius: 55,
                                title: '20%',
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFF97316),
                                value: 30,
                                radius: 65,
                                title: '30%',
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 35,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Spending  Savings  Investing',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                      
                      // REAL: Investing breakdown modal
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showInvestingModal(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF97316).withOpacity(0.15),
                            border: Border.all(color: const Color(0xFFF97316).withOpacity(0.4)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF97316).withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.trending_up, size: 16, color: Color(0xFFF97316)),
                                  SizedBox(width: 8),
                                  Text(
                                    '₹15,000 Investing (30%)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFF97316),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('13.8% APY', style: TextStyle(fontSize: 13, color: Color(0xFFF97316))),
                                  const SizedBox(width: 8),
                                  Icon(Icons.chevron_right, color: const Color(0xFFF97316)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // AI Recommendations + Notification
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Top performer label + notification banner
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            "Today's Top Performer",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF22C55E).withOpacity(0.9),
                                const Color(0xFF16A34A).withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.trending_up, color: Colors.white, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🚀 Solana Green +3.2%',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                    Text(
                                      'Your ₹4,500 → ₹4,650',
                                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.close, color: Colors.white70, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Next month rebalance
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [const Color(0xFF7C3AED).withOpacity(0.9), const Color(0xFFEC4899).withOpacity(0.9)],
                        ),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.insights, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Next Month Optimizer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '13.8% APY possible (+₹320 extra)',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PortfolioPage()),
                                );
                              },
                              child: const Text(
                                'Apply Next Month Plan',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String change,
    required String changePercent,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: color),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
              const SizedBox(width: 8),
              Text(changePercent, style: TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  void _showInvestingModal(BuildContext context) {
    final priceService = PriceService();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LiveInvestingModal(
        priceService: priceService,
      ),
    );
  }

  Widget _buildLivePerformanceCard({
    required String title,
    required String value,
    required String change,
    required String changePercent,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: color),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
              const SizedBox(width: 8),
              Text(changePercent, style: TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetRow(String name, String icon, String value, String change, String apy, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('$value • $apy APY', style: const TextStyle(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          Text(
            change,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: change.contains('+') ? const Color(0xFF22C55E) : const Color(0xFFF97316),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveInvestingModal extends StatefulWidget {
  final PriceService priceService;
  const LiveInvestingModal({super.key, required this.priceService});

  @override
  State<LiveInvestingModal> createState() => _LiveInvestingModalState();
}

class _LiveInvestingModalState extends State<LiveInvestingModal> {
  Map<String, dynamic> currentPrices = {};

  @override
  void initState() {
    super.initState();
    widget.priceService.priceStream.listen((prices) {
      if (mounted) {
        setState(() {
          currentPrices = prices;
        });
      }
    });
    currentPrices = widget.priceService.getCurrentPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF050816),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white30,
            ),
          ),
          
          // LIVE Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  children: [
                    const Icon(Icons.analytics, color: Color(0xFFF97316), size: 28),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LIVE Investing Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text('Prices updating...', style: TextStyle(fontSize: 12, color: Colors.white60)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white60),
                ),
              ],
            ),
          ),
          
          // LIVE Performance
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [const Color(0xFFF97316).withOpacity(0.9), const Color(0xFFEAB308).withOpacity(0.9)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('₹15,000', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('Invested', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
                Column(
                  children: [
                    Text('13.8%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('APY', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
                Column(
                  children: [
                    Text('₹1,980', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('Profit', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // LIVE Asset list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (context, index) {
                final assets = [
                  {'name': 'Reliance Green Energy', 'icon': '📈'},
                  {'name': 'Solana Green Lending', 'icon': '🌿'},
                  {'name': 'Cardano ESG Pool', 'icon': '🔗'},
                  {'name': 'SBI Magnum ESG', 'icon': '💰'},
                  {'name': 'Digital Gold', 'icon': '🥇'},
                ];
                
                final asset = assets[index];
                final name = asset['name']!;
                final priceData = currentPrices[name] ?? {'price': 0, 'change': '0'};
                
                final isPositive = double.tryParse(priceData['change'])?.isNegative != true;
                final color = isPositive ? const Color(0xFF22C55E) : const Color(0xFFF97316);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.04),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(asset['icon']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(
                              '₹${priceData['price']} • 13.8% APY',
                              style: const TextStyle(fontSize: 12, color: Colors.white60),
                            ),
                            const SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                String typeLabel;
                                Color typeColor;
                                
                                if (name.contains('Reliance') || name.contains('Tata')) {
                                  typeLabel = 'STOCK · India';
                                  typeColor = const Color(0xFF0EA5E9); // blue
                                } else if (name.contains('Solana') || name.contains('Cardano')) {
                                  typeLabel = 'CRYPTO · DeFi';
                                  typeColor = const Color(0xFF7C3AED); // purple
                                } else if (name.contains('SBI') || name.contains('ESG')) {
                                  typeLabel = 'FUND · ESG';
                                  typeColor = const Color(0xFF22C55E); // green
                                } else if (name.contains('Gold')) {
                                  typeLabel = 'GOLD · Safe';
                                  typeColor = const Color(0xFFEAB308); // yellow
                                } else {
                                  typeLabel = 'ASSET';
                                  typeColor = Colors.white54;
                                }
                                
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: typeColor.withOpacity(0.15),
                                  ),
                                  child: Text(
                                    typeLabel,
                                    style: TextStyle(fontSize: 11, color: typeColor, fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${priceData['change']}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}