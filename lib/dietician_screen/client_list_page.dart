import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/cores/dietician/dietician_services.dart';
import 'package:nutrilens_test/dietician_screen/client_progress_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  List<Map<String, dynamic>> _clients = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    try {
      final clients = await DieticianServices().getClients();
      setState(() {
        _clients = clients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "Could not load clients",
                style: AppTextStyle.heading5,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadClients,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (_clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "No Clients Yet",
              style: AppTextStyle.heading4.copyWith(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              "When users book appointments with you,\nthey'll appear here.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadClients,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          final client = _clients[index];
          return _buildClientCard(client, palette);
        },
      ),
    );
  }

  Widget _buildClientCard(Map<String, dynamic> client, AppPalette palette) {
    final name = client["full_name"] ?? client["username"] ?? "Unknown";
    final age = client["profile"]?["age"];
    final gender = client["profile"]?["gender"];
    final initial = name[0].toUpperCase();
    final riskLevel = client["risk_level"] ?? "low";
    final riskReason = client["risk_reason"] ?? "On track";

    Color riskColor;
    IconData riskIcon;
    if (riskLevel == "high") {
      riskColor = Colors.red.shade400;
      riskIcon = Icons.warning_amber_rounded;
    } else if (riskLevel == "medium") {
      riskColor = Colors.orange.shade400;
      riskIcon = Icons.info_outline_rounded;
    } else {
      riskColor = Colors.green.shade400;
      riskIcon = Icons.check_circle_outline_rounded;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientProgressPage(
              clientId: client["id"],
              clientName: name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.selectColor3, palette.selectColor3.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (age != null) ...[
                        Icon(Icons.cake_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text("$age yrs", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const SizedBox(width: 12),
                      ],
                      if (gender != null) ...[
                        Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(gender, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(riskIcon, size: 14, color: riskColor),
                            const SizedBox(width: 4),
                            Text(
                              riskReason,
                              style: TextStyle(color: riskColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
