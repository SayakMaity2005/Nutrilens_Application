import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'BMI',
    'Weight',
    'Calories Intake',
    'Calories Burned',
    'Nutrients',
    'Water'
  ];

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());
  bool _isScrollingFromTap = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrollingFromTap) return;

    int newIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final keyContext = _sectionKeys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox?;
        if (box != null && box.attached) {
          final position = box.localToGlobal(Offset.zero).dy;
          
          // We want the index of the section that is closest to the top bar (approx 200px from top)
          double distance = (position - 220).abs();
          if (distance < minDistance) {
            minDistance = distance;
            newIndex = i;
          }
        }
      }
    }

    if (newIndex != _selectedCategoryIndex) {
      setState(() {
        _selectedCategoryIndex = newIndex;
      });
    }
  }

  void _scrollToSection(int index) async {
    _isScrollingFromTap = true;
    setState(() {
      _selectedCategoryIndex = index;
    });

    final keyContext = _sectionKeys[index].currentContext;
    if (keyContext != null) {
      // Get the scroll offset required to bring this context to the top
      await Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.12, // Align near the top but below the sticky header
      );
    }
    
    Future.delayed(const Duration(milliseconds: 100), () {
      _isScrollingFromTap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Sticky Top Bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyTopBarDelegate(
            child: Container(
              color: palette.screenColor.withOpacity(0.95), // Slight transparency
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text("Trends", style: AppTextStyle.heading2.copyWith(color: palette.headingBlueText, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text("PRO", style: TextStyle(color: Color(0xFF00695C), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        // const CircleAvatar(
                        //   radius: 18,
                        //   backgroundColor: Color(0xFFE0E0E0),
                        //   child: Icon(Icons.person, color: Colors.white, size: 24),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySelector(palette),
                ],
              ),
            ),
            maxExtent: 140,
            minExtent: 140,
          ),
        ),

        // Scrollable Content
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _buildBMICard(screenWidth, palette, key: _sectionKeys[0]),
                const SizedBox(height: 20),
                _buildWeightCard(screenWidth, palette, key: _sectionKeys[1]),
                const SizedBox(height: 20),
                _buildCaloriesIntakeCard(screenWidth, palette, key: _sectionKeys[2]),
                const SizedBox(height: 20),
                _buildCaloriesBurnedCard(screenWidth, palette, key: _sectionKeys[3]),
                const SizedBox(height: 20),
                _buildNutrientsCard(screenWidth, palette, key: _sectionKeys[4]),
                const SizedBox(height: 20),
                _buildWaterCard(screenWidth, palette, key: _sectionKeys[5]),
                const SizedBox(height: 200), // Extra space to allow last item to reach top
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AppPalette palette) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_categories.length, (index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => _scrollToSection(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD1E3FF) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF4A90E2) : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ] : [],
              ),
              child: Text(
                _categories[index],
                style: AppTextStyle.primaryBoldText.copyWith(
                  color: isSelected ? const Color(0xFF1C3678) : Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBMICard(double width, AppPalette palette, {Key? key}) {
    return Container(
      key: key,
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current", style: AppTextStyle.smallText.copyWith(color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("29.4", style: AppTextStyle.heading2.copyWith(fontWeight: FontWeight.w900, fontSize: 32)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(6)),
                child: const Text("Overweight", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBMIProgressBar(width - 72),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFFF9E1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.sentiment_satisfied_alt, color: Color(0xFF4A90E2), size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Lose 28.4 lbs to achieve a healthy weight.",
                    style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIProgressBar(double width) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 10,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4FC3F7), // Underweight
                    Color(0xFF81C784), // Normal
                    Color(0xFFFFD54F), // Overweight
                    Color(0xFFFFB74D), // Obese I
                    Color(0xFFE57373), // Obese II
                  ],
                  stops: [0.2, 0.45, 0.65, 0.8, 1.0],
                ),
              ),
            ),
            Positioned(
              left: (width * 0.7) - 8,
              top: -12,
              child: const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF263238)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("12.0", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("18.5", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("24.9", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("30.0", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("40.0", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightCard(double width, AppPalette palette, {Key? key}) {
    return _buildTrendSection(
      key: key,
      title: "Weight",
      currentValue: "187.4",
      unit: "lbs",
      change: "0.0",
      isPositive: true,
      timeFrame: "Last 30 days",
      chart: _buildChartPlaceholder(width),
      message: "Getting started is the hardest part. You're ready for this!",
    );
  }

  Widget _buildCaloriesIntakeCard(double width, AppPalette palette, {Key? key}) {
    return _buildTrendSection(
      key: key,
      title: "Calories Intake",
      currentValue: "0",
      unit: "kcal",
      timeFrame: "Last 7 days",
      chart: _buildChartPlaceholder(width, "No data"),
      message: "Log a few more days to unlock clearer insights into your eating patterns.",
    );
  }

  Widget _buildCaloriesBurnedCard(double width, AppPalette palette, {Key? key}) {
    return _buildTrendSection(
      key: key,
      title: "Calories Burned",
      currentValue: "0",
      unit: "kcal",
      timeFrame: "Last 7 days",
      chart: _buildChartPlaceholder(width, "No data"),
      message: "Keep it up! A few more days of logging will help us unlock your personalized trends.",
    );
  }

  Widget _buildNutrientsCard(double width, AppPalette palette, {Key? key}) {
    return Container(
      key: key,
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nutrients", style: AppTextStyle.heading4.copyWith(fontWeight: FontWeight.w800)),
              Text("More >", style: AppTextStyle.smallBoldText.copyWith(color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Text("Average", style: AppTextStyle.smallText.copyWith(color: Colors.grey.shade400)),
          const SizedBox(height: 16),
          _buildNutrientRow("Carbs", 0, 215, const Color(0xFF81C784), subItems: ["Sugar", "Dietary Fiber"]),
          const SizedBox(height: 16),
          _buildNutrientRow("Protein", 0, 107, const Color(0xFFFFB74D)),
          const SizedBox(height: 16),
          _buildNutrientRow("Fat", 0, 48, const Color(0xFFFFD54F), subItems: ["Saturated Fat", "Trans Fat"]),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: Text("See more", style: TextStyle(color: Colors.grey.shade600)),
              label: Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String label, double current, double goal, Color color, {List<String>? subItems}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            Text("${current.toInt()} / ${goal.toInt()}g  0%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: current / goal,
          backgroundColor: Colors.grey.shade100,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        if (subItems != null) ...[
          const SizedBox(height: 12),
          ...subItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                Text("0 g", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          )).toList(),
        ]
      ],
    );
  }

  Widget _buildWaterCard(double width, AppPalette palette, {Key? key}) {
    return _buildTrendSection(
      key: key,
      title: "Water",
      currentValue: "0",
      unit: "ml",
      timeFrame: "Last 7 days",
      chart: _buildChartPlaceholder(width, "No data"),
    );
  }

  Widget _buildChartPlaceholder(double width, [String? text]) {
    return Container(
      height: 140,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200), left: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (text != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          // Simple grid lines
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (_) => Divider(height: 1, color: Colors.grey.shade100)),
          )
        ],
      ),
    );
  }

  Widget _buildTrendSection({
    Key? key,
    required String title,
    required String currentValue,
    required String unit,
    String? change,
    bool isPositive = true,
    required String timeFrame,
    required Widget chart,
    String? message,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyle.heading4.copyWith(fontWeight: FontWeight.w800)),
              Text("More >", style: AppTextStyle.smallBoldText.copyWith(color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Average", style: AppTextStyle.smallText.copyWith(color: Colors.grey.shade500)),
              Text(timeFrame, style: AppTextStyle.smallText.copyWith(color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(currentValue, style: AppTextStyle.heading2.copyWith(fontWeight: FontWeight.w900, fontSize: 28)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (change != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFF1F8E9), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_drop_down, color: Color(0xFF81C784), size: 20),
                      Text(change, style: const TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          chart,
          if (message != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFFFF9E1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.sentiment_satisfied_alt, color: Color(0xFF4A90E2), size: 28),
                  const SizedBox(width: 12),
                  Expanded(child: Text(message, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StickyTopBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  @override
  final double minExtent;
  @override
  final double maxExtent;

  _StickyTopBarDelegate({
    required this.child,
    required this.minExtent,
    required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyTopBarDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}

// Helper to use List<Widget> with slivers easily if needed, though SliverChildListDelegate works
class SliverChildListExtendedDelegate extends SliverChildListDelegate {
  SliverChildListExtendedDelegate(List<Widget> children) : super(children);
}
