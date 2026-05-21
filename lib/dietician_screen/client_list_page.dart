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
  List<Map<String, dynamic>> _filteredClients = [];
  bool _isLoading = true;
  String? _error;
  
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, High Risk, Needs Attention, On Track

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
        _filteredClients = clients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterClients() {
    setState(() {
      _filteredClients = _clients.where((client) {
        // Search
        final name = (client["full_name"] ?? client["username"] ?? "Unknown").toString().toLowerCase();
        final matchesSearch = name.contains(_searchQuery.toLowerCase());
        
        // Filter
        final risk = (client["risk_level"] ?? "low").toString().toLowerCase();
        bool matchesFilter = true;
        if (_selectedFilter == 'High Risk') matchesFilter = risk == 'high';
        if (_selectedFilter == 'Needs Attention') matchesFilter = risk == 'medium';
        if (_selectedFilter == 'On Track') matchesFilter = risk == 'low';

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;

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

    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (val) {
                    _searchQuery = val;
                    _filterClients();
                  },
                  decoration: InputDecoration(
                    hintText: "Search clients...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'High Risk', 'Needs Attention', 'On Track'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedFilter = filter);
                            _filterClients();
                          }
                        },
                        selectedColor: palette.selectColor1.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? palette.selectColor1 : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: isSelected ? palette.selectColor1 : Colors.grey.shade300),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        
        // Client List
        Expanded(
          child: _filteredClients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No Clients Found",
                        style: AppTextStyle.heading4.copyWith(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadClients,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 100), // padding for bottom nav
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      return _buildClientCard(_filteredClients[index], palette);
                    },
                  ),
                ),
        ),
      ],
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
      riskColor = Colors.red.shade500;
      riskIcon = Icons.warning_rounded;
    } else if (riskLevel == "medium") {
      riskColor = Colors.orange.shade500;
      riskIcon = Icons.info_rounded;
    } else {
      riskColor = Colors.green.shade500;
      riskIcon = Icons.check_circle_rounded;
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [palette.selectColor1, palette.selectColor3],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: palette.selectColor1.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
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
                            fontSize: 18,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (age != null) ...[
                              Icon(Icons.cake_rounded, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text("$age yrs", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 12),
                            ],
                            if (gender != null) ...[
                              Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(gender, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Menu (Mock)
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Divider
            Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
            
            // Bottom Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(riskIcon, size: 16, color: riskColor),
                        const SizedBox(width: 6),
                        Text(
                          riskReason,
                          style: TextStyle(color: riskColor, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "View Progress",
                        style: TextStyle(
                          color: palette.selectColor1,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: palette.selectColor1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
