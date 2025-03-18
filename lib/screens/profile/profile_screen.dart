import 'package:flutter/material.dart';
import 'package:go_wallet/screens/profile/profile_editScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _primaryBlue = const Color(0xFF2196F3);
    final _lightBlue = const Color(0xFFE3F2FD);
    final _darkBlue = const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: _lightBlue,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryBlue,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: _primaryBlue,
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: const NetworkImage(
                              'https://via.placeholder.com/150',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.verified,
                              color: _primaryBlue,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Premium Member',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    title: 'Personal Information',
                    items: [
                      _buildInfoItem(
                          Icons.email, 'Email', 'john.doe@example.com'),
                      _buildInfoItem(Icons.phone, 'Phone', '+1 234 567 890'),
                      _buildInfoItem(Icons.location_on, 'Address',
                          '123 Main St, City, Country'),
                      _buildInfoItem(Icons.cake, 'Date of Birth', '01/01/1990'),
                    ],
                    primaryBlue: _primaryBlue,
                    darkBlue: _darkBlue,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Account Information',
                    items: [
                      _buildInfoItem(
                          Icons.account_balance, 'Account Type', 'Savings'),
                      _buildInfoItem(
                          Icons.credit_card, 'Card Status', 'Active'),
                      _buildInfoItem(Icons.security, 'KYC Status', 'Verified'),
                      _buildInfoItem(
                          Icons.calendar_today, 'Member Since', 'Jan 2023'),
                    ],
                    primaryBlue: _primaryBlue,
                    darkBlue: _darkBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> items,
    required Color primaryBlue,
    required Color darkBlue,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

