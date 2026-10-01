import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../controllers/app_controller.dart';

class AddressItem {
  final String id;
  final String label;
  final bool isDefault;
  final String recipientName;
  final String phone;
  final String address;
  final String note;
  final IconData icon;

  AddressItem({
    required this.id,
    required this.label,
    required this.isDefault,
    required this.recipientName,
    required this.phone,
    required this.address,
    required this.note,
    required this.icon,
  });

  AddressItem copyWith({
    String? id,
    String? label,
    bool? isDefault,
    String? recipientName,
    String? phone,
    String? address,
    String? note,
    IconData? icon,
  }) {
    return AddressItem(
      id: id ?? this.id,
      label: label ?? this.label,
      isDefault: isDefault ?? this.isDefault,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      icon: icon ?? this.icon,
    );
  }
}

class AlamatTersimpanScreen extends StatefulWidget {
  final AppController controller;

  const AlamatTersimpanScreen({
    super.key,
    required this.controller,
  });

  @override
  State<AlamatTersimpanScreen> createState() => _AlamatTersimpanScreenState();
}

class _AlamatTersimpanScreenState extends State<AlamatTersimpanScreen> {
  late List<AddressItem> addresses;
  late String primaryId;

  @override
  void initState() {
    super.initState();
    addresses = [
      AddressItem(
        id: '1',
        label: 'Rumah',
        isDefault: true,
        recipientName: 'Tania Anastasia',
        phone: '0811-3456-7890',
        address:
            'Jl. Sudirman No. 45, RT 03 / RW 05, Kel. Karet Tengsin, Tanah Abang, Jakarta Pusat 10220',
        note: 'Patokan: Pagar hitam depan pos satpam',
        icon: Icons.home_rounded,
      ),
      AddressItem(
        id: '2',
        label: 'Kantor',
        isDefault: false,
        recipientName: 'Tania Anastasia',
        phone: '0811-3456-7890',
        address:
            'Gedung Menara Mandiri Lt. 14, Jl. Jend. Gatot Subroto Kav. 36, RT 05 / RW 03, Senayan, Kebayoran Baru, Jakarta Selatan 12190',
        note: 'Drop point: Lobby Selatan samping Starbucks',
        icon: Icons.business_rounded,
      ),
      AddressItem(
        id: '3',
        label: 'Rumah Bandung',
        isDefault: false,
        recipientName: 'Bpk. Bambang Gunawan',
        phone: '0813-8877-2211',
        address:
            'Jl. Cihampelas No. 88, RT 02 / RW 07, Cipaganti, Kec. Coblong, Kota Bandung, Jawa Barat 40131',
        note: 'Patokan: Depan Kedai Kopi Cihampelas',
        icon: Icons.location_on_rounded,
      ),
    ];
    primaryId = '1';
  }

  void _setAsPrimary(String id) {
    setState(() {
      primaryId = id;
      addresses = addresses.map((addr) {
        return addr.copyWith(isDefault: addr.id == id);
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alamat utama berhasil diperbarui'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteAddress(String id) {
    final toDelete = addresses.firstWhere((a) => a.id == id);
    if (toDelete.id == primaryId && addresses.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih alamat utama lain sebelum menghapus alamat ini.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      addresses.removeWhere((a) => a.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alamat "${toDelete.label}" dihapus'),
        backgroundColor: const Color(0xFF334155),
      ),
    );
  }

  void _showAddressModal([AddressItem? existing]) {
    final isDark = widget.controller.isDarkMode;
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    final nameCtrl = TextEditingController(text: existing?.recipientName ?? 'Tania Anastasia');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '0811-3456-7890');
    final addrCtrl = TextEditingController(text: existing?.address ?? '');
    final noteCtrl = TextEditingController(text: existing?.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    existing == null ? 'Tambah Alamat Baru' : 'Ubah Alamat',
                    style: AppTypography.getHeading(
                      isDark: isDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: labelCtrl,
                decoration: InputDecoration(
                  labelText: 'Label Alamat (Contoh: Rumah, Kantor)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Penerima',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addrCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Alamat Lengkap',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  labelText: 'Patokan / Catatan Kurir (Opsional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (labelCtrl.text.isEmpty || addrCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lengkapi label dan alamat')),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    if (existing == null) {
                      final newId = DateTime.now().millisecondsSinceEpoch.toString();
                      setState(() {
                        addresses.add(
                          AddressItem(
                            id: newId,
                            label: labelCtrl.text,
                            isDefault: addresses.isEmpty,
                            recipientName: nameCtrl.text,
                            phone: phoneCtrl.text,
                            address: addrCtrl.text,
                            note: noteCtrl.text.isNotEmpty
                                ? 'Patokan: ${noteCtrl.text}'
                                : 'Patokan: Sesuai titik peta',
                            icon: Icons.place_rounded,
                          ),
                        );
                      });
                    } else {
                      setState(() {
                        final idx = addresses.indexWhere((a) => a.id == existing.id);
                        if (idx != -1) {
                          addresses[idx] = existing.copyWith(
                            label: labelCtrl.text,
                            recipientName: nameCtrl.text,
                            phone: phoneCtrl.text,
                            address: addrCtrl.text,
                            note: noteCtrl.text,
                          );
                        }
                      });
                    }
                  },
                  child: Text(
                    existing == null ? 'Simpan Alamat Baru' : 'Perbarui Alamat',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Alamat Tersimpan',
          style: AppTypography.getHeading(
            isDark: isDark,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alamat digunakan untuk penjemputan montir Home Service & pengiriman part.'),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              children: [
                // Subheader
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DAFTAR LOKASI PENJEMPUTAN',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFDBA74),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        '${addresses.length} Alamat',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // List of addresses
                ...addresses.map((item) {
                  final isSelected = item.id == primaryId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildAddressCard(item, isSelected, isDark),
                  );
                }),
              ],
            ),
          ),

          // Bottom Button: Tambah Alamat Baru
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _showAddressModal(),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(
                  'Tambah Alamat Baru',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressItem item, bool isSelected, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.1)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _setAsPrimary(item.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon + Label + Badge UTAMA + Radio Selection Indicator
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF352614) : const Color(0xFFFEF3C7))
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: isSelected
                            ? const Color(0xFFEA580C)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.label,
                      style: AppTypography.getHeading(
                        isDark: isDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF142F1E) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UTAMA',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    // Radio indicator
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Recipient & Phone
                Row(
                  children: [
                    Text(
                      item.recipientName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '•  ${item.phone}',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Full Address
                Text(
                  item.address,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 10),

                // Landmark Box (Light grey pill box)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.note.contains('Drop point')
                            ? Icons.location_searching_rounded
                            : Icons.chat_bubble_outline_rounded,
                        size: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.note,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Bottom Action Row
                Row(
                  children: [
                    if (!isSelected)
                      InkWell(
                        onTap: () => _setAsPrimary(item.id),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: Text(
                            'Jadikan Alamat Utama',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _showAddressModal(item),
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 14, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              'Ubah Alamat',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                      ),
                      onPressed: () => _deleteAddress(item.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
