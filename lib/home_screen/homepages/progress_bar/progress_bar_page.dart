import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NutritionAnalyticsPage extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  /// List of daily data from backend
  // final List<Map<String, dynamic>> dailyRecords;

  const NutritionAnalyticsPage({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.dailyRecords,
  });

  final List<Map<String, dynamic>> dailyRecords;

  /// =========================
  /// GET DATA FOR A DAY
  /// =========================
  Map<String, dynamic> getDayData(DateTime date) {
    try {
      return dailyRecords.firstWhere(
            (e) {
          final d = DateTime.parse(e['date']);

          return d.year == date.year &&
              d.month == date.month &&
              d.day == date.day;
        },
      );
    } catch (_) {
      return {};
    }
  }

  /// =========================
  /// MACRO CALCULATION
  /// =========================
  double calculateMacro(
      Map<String, dynamic> dayData,
      String key,
      ) {
    if (dayData.isEmpty) return 0;

    double total = 0;

    final meals = dayData['meals'];

    for (final meal in meals.values) {
      final intakes = meal['consumed_intakes'];

      for (final intake in intakes) {
        total +=
            (intake['quantity'] ?? 0) *
                (intake[key] ?? 0);
      }
    }

    return total;
  }

  /// =========================
  /// CREATE DATE LIST
  /// =========================
  List<DateTime> generateDates() {
    List<DateTime> dates = [];

    for (
    DateTime d = startDate;
    !d.isAfter(endDate);
    d = d.add(const Duration(days: 1))
    ) {
      dates.add(d);
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final dates = generateDates();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        title: const Text(
          "Nutrition Analytics",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// =========================
            /// DATE HEADER
            /// =========================
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.date_range_rounded,
                      color: Color(0xFF7C3AED),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Selected Duration",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${startDate.day}/${startDate.month}/${startDate.year}"
                              " → "
                              "${endDate.day}/${endDate.month}/${endDate.year}",

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// =========================
            /// ENERGY GRAPH
            /// =========================
            const Text(
              "Energy Intake",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 16),

            GraphCard(
              child: SizedBox(
                height: 260,

                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),

                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 500,
                    ),

                    titlesData: FlTitlesData(
                      topTitles:
                      const AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false),
                      ),

                      rightTitles:
                      const AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,

                          getTitlesWidget:
                              (value, meta) {
                            final index =
                            value.toInt();

                            if (index >=
                                dates.length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding:
                              const EdgeInsets.only(
                                  top: 8),

                              child: Text(
                                "${dates[index].day}",

                                style:
                                const TextStyle(
                                  fontSize: 12,
                                  color:
                                  Colors.black54,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    barGroups: List.generate(
                      dates.length,
                          (index) {
                        final data =
                        getDayData(dates[index]);

                        final energy =
                        calculateMacro(
                          data,
                          'energy_per_unit',
                        );

                        return BarChartGroupData(
                          x: index,

                          barRods: [
                            BarChartRodData(
                              toY: energy,
                              width: 16,

                              borderRadius:
                              BorderRadius.circular(
                                  6),

                              color: const Color(
                                  0xFFBFA2FF),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            /// =========================
            /// OVERALL PROGRESS
            /// =========================
            const Text(
              "Overall Goal Achievement",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 16),

            buildOverallCard(
              title: "Protein",
              color: const Color(0xFFA7F3D0),
              dates: dates,
              macroKey: 'protein_per_unit',
              targetKey: 'protein',
              unit: 'g',
            ),

            buildOverallCard(
              title: "Carbs",
              color: const Color(0xFFBFDBFE),
              dates: dates,
              macroKey: 'carbs_per_unit',
              targetKey: 'carbs',
              unit: 'g',
            ),

            buildOverallCard(
              title: "Fat",
              color: const Color(0xFFFBCFE8),
              dates: dates,
              macroKey: 'fat_per_unit',
              targetKey: 'fat',
              unit: 'g',
            ),

            buildWaterCard(dates),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// OVERALL PROGRESS CARD
  /// =========================
  Widget buildOverallCard({
    required String title,
    required Color color,
    required List<DateTime> dates,
    required String macroKey,
    required String targetKey,
    required String unit,
  }) {
    double totalConsumed = 0;
    double totalTarget = 0;

    for (final date in dates) {
      final data = getDayData(date);

      if (data.isNotEmpty) {
        totalConsumed +=
            calculateMacro(data, macroKey);

        totalTarget +=
            (data['daily_target'][targetKey] ?? 0)
                .toDouble();
      }
    }

    final progress =
    totalTarget == 0
        ? 0
        : (totalConsumed / totalTarget)
        .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: GraphCard(
        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),

                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(30),

              child: LinearProgressIndicator(
                value: progress.toDouble(),
                minHeight: 12,
                backgroundColor: color.withOpacity(0.3),
                valueColor:
                AlwaysStoppedAnimation(color),
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,

              child: Text(
                "${totalConsumed.toStringAsFixed(1)} / "
                    "${totalTarget.toStringAsFixed(1)} $unit",

                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// WATER CARD
  /// =========================
  Widget buildWaterCard(List<DateTime> dates) {
    double totalWater = 0;
    double targetWater = 0;

    for (final date in dates) {
      final data = getDayData(date);

      if (data.isNotEmpty) {
        totalWater +=
            (data['water'] ?? 0).toDouble();

        targetWater +=
            (data['daily_target']['water'] ?? 0)
                .toDouble();
      }
    }

    final progress =
    targetWater == 0
        ? 0
        : (totalWater / targetWater)
        .clamp(0.0, 1.0);

    return GraphCard(
      child: Column(
        children: [

          Row(
            children: [

              const Expanded(
                child: Text(
                  "Water Intake",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),

              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),

            child: LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 12,
              backgroundColor:
              const Color(0xFFCFFAFE),

              valueColor:
              const AlwaysStoppedAnimation(
                Color(0xFF67E8F9),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,

            child: Text(
              "${totalWater.toStringAsFixed(0)} / "
                  "${targetWater.toStringAsFixed(0)} ml",

              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =========================
/// COMMON CARD
/// =========================
class GraphCard extends StatelessWidget {
  final Widget child;

  const GraphCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }
}