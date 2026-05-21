import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutrilens_test/home_screen/homepages/settings/profile_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _addWorkoutCalories = true;
  bool _autoBudget = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Profile'),
          _buildCardGroup([
            _buildArrowItem('Profile detail', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileDetailPage()),
              );
            }),
            _buildDivider(),
            _buildArrowItem('Goal'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Preference'),
          _buildCardGroup([
            _buildArrowItem('Notifications'),
            _buildDivider(),
            _buildSwitchItem(
              'Add workout calories to budget',
              _addWorkoutCalories,
              (val) => setState(() => _addWorkoutCalories = val),
            ),
            _buildDivider(),
            _buildSwitchItem(
              'Auto budget',
              _autoBudget,
              (val) => setState(() => _autoBudget = val),
            ),
            _buildDivider(),
            _buildArrowItem('Unit'),
            _buildDivider(),
            _buildArrowItem('Language'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Support'),
          _buildCardGroup([
            _buildArrowItem('Contact Support (Email)', onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'rohitkumardebnath02@gmail.com',
                query: 'subject=Nutrilens Support Request',
              );
              if (!await launchUrl(emailLaunchUri)) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open email client.')),
                  );
                }
              }
            }),
            _buildDivider(),
            _buildArrowItem('Suggestion'),
            _buildDivider(),
            _buildArrowItem('Report'),
            _buildDivider(),
            _buildArrowItem('Encourage us'),
            _buildDivider(),
            _buildArrowItem('Manage account'),
            _buildDivider(),
            _buildArrowItem('Restore membership'),
          ]),
          const SizedBox(height: 20),
          _buildSectionHeader('Legal'),
          _buildCardGroup([
            _buildArrowItem('Terms of use'),
            _buildDivider(),
            _buildArrowItem('Privacy policy'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildArrowItem(String title, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16), // Won't clip perfectly for middle items, but good enough for ripple
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: Colors.blue.shade600,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade100,
      ),
    );
  }
}
