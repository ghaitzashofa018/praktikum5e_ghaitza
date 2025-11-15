import 'package:flutter/material.dart';
import 'main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _barangList = [
    {"nama": "Kipas Angin", "harga": 120000, "kategori": "Elektronik", "icon": Icons.toys_outlined},
    {"nama": "Laptop Asus", "harga": 7500000, "kategori": "Komputer", "icon": Icons.laptop},
    {"nama": "Kursi Kantor", "harga": 560000, "kategori": "Furniture", "icon": Icons.chair},
    {"nama": "Meja Belajar", "harga": 450000, "kategori": "Furniture", "icon": Icons.table_restaurant},
  ];

  late AnimationController _fadeController;
  String _searchQuery = "";
  String _filterKategori = "Semua";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBarang {
    return _barangList.where((barang) {
      final matchSearch = barang['nama'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchFilter = _filterKategori == "Semua" || barang['kategori'] == _filterKategori;
      return matchSearch && matchFilter;
    }).toList();
  }

  double get _totalHarga => _filteredBarang.fold(0, (sum, barang) => sum + barang['harga']);

  String _formatCurrency(int harga) {
    return "Rp ${harga.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}";
  }

  void _tambahBarang() {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();
    String selectedKategori = "Elektronik";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "➕ Tambah Barang",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                  prefixIcon: const Icon(Icons.inventory_2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Barang",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField(
                value: selectedKategori,
                items: ["Elektronik", "Komputer", "Furniture"]
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (value) => selectedKategori = value!,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (namaController.text.isNotEmpty && hargaController.text.isNotEmpty) {
                setState(() {
                  _barangList.add({
                    "nama": namaController.text,
                    "harga": int.parse(hargaController.text),
                    "kategori": selectedKategori,
                    "icon": Icons.shopping_bag,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editBarang(int index) {
    final TextEditingController namaController =
        TextEditingController(text: _barangList[index]['nama']);
    final TextEditingController hargaController =
        TextEditingController(text: _barangList[index]['harga'].toString());
    String selectedKategori = _barangList[index]['kategori'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "✏️ Edit Barang",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                  prefixIcon: const Icon(Icons.edit_note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Barang",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField(
                value: selectedKategori,
                items: ["Elektronik", "Komputer", "Furniture"]
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (value) => selectedKategori = value!,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _barangList[index]['nama'] = namaController.text;
                _barangList[index]['harga'] = int.parse(hargaController.text);
                _barangList[index]['kategori'] = selectedKategori;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _hapusBarang(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "⚠️ Konfirmasi Hapus",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          "Apakah kamu yakin ingin menghapus '${_barangList[index]['nama']}'?",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() => _barangList.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 8,
        shadowColor: Colors.indigo.withOpacity(0.5),
        title: const Text(
          "📦 Dashboard Barang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white, size: 26),
            tooltip: "Logout",
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: CustomScrollView(
          slivers: [
            // Header Gradient
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
                  boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selamat Datang, Ghaitza 👋",
                      style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Kelas 5E • ${_barangList.length} Barang",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard("Total Barang", _filteredBarang.length.toString(), Colors.blue, Icons.inventory_2),
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "🔍 Cari barang...",
                        prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ["Semua", "Elektronik", "Komputer", "Furniture"]
                            .map((kategori) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: _filterKategori == kategori,
                            label: Text(kategori),
                            onSelected: (selected) => setState(() => _filterKategori = kategori),
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: Colors.indigo,
                            labelStyle: TextStyle(
                              color: _filterKategori == kategori ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Barang List
            if (_filteredBarang.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          "Tidak ada barang",
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final barang = _filteredBarang[index];
                      final originalIndex = _barangList.indexOf(barang);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.indigo.shade100,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.indigo.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.indigo, Colors.indigo.shade300],
                                  ),
                                  boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8)],
                                ),
                                child: Icon(barang['icon'], color: Colors.white, size: 26),
                              ),
                              title: Text(
                                barang['nama'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      barang['kategori'],
                                      style: TextStyle(fontSize: 12, color: Colors.indigo.shade700),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_formatCurrency(barang['harga']), style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 4,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editBarang(originalIndex),
                                    tooltip: "Edit",
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _hapusBarang(originalIndex),
                                    tooltip: "Hapus",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _filteredBarang.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahBarang,
        backgroundColor: Colors.indigo,
        elevation: 8,
        label: const Text(
          "Tambah Barang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}