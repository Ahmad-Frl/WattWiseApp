import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wattwiseapp/data/database_helper.dart';
import 'package:wattwiseapp/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0; // Untuk melacak tab yang aktif di Footer

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    await _auth.signOut(); 
    await DatabaseHelper.instance.clearLocalSession(); 
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    // Mengambil displayName dari Firebase, jika null tampilkan "Pengguna"
    final String namaLengkap = user?.displayName ?? "Pengguna";

    // Kumpulan halaman untuk Footer
    final List<Widget> pages = [
      // Index 0: Halaman Beranda
      _buildBeranda(namaLengkap),
      
      // Index 1: Halaman Profil
      _buildProfil(namaLengkap, user?.email ?? ""),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("WattWise"),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: pages[_selectedIndex], // Tampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // --- WIDGET HALAMAN BERANDA ---
  Widget _buildBeranda(String namaLengkap) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hai, $namaLengkap!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Card Penggunaan Listrik
          const Text(
            "Penggunaan Listrik Bulan Ini",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "(Kosong, Anda belum mencantumkan peralatan elektronik)",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: 30),

          // Menu Umum
          const Text(
            "Menu Utama",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuIcon(Icons.devices, "Peralatan", Colors.orange),
              _buildMenuIcon(Icons.request_quote, "Tarif Listrik", Colors.green),
              _buildMenuIcon(Icons.insights, "Optimasi", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET MENU ICON ---
  Widget _buildMenuIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // --- WIDGET HALAMAN PROFIL ---
  Widget _buildProfil(String nama, String email) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text("Keluar (Logout)"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          )
        ],
      ),
    );
  }
}