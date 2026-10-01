import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/app_controller.dart';
import '../garasi/widgets/tambah_motor_sheet.dart';
import 'schedule_picker_screen.dart';

class BookingStep1Screen extends StatefulWidget {
  final AppController controller;
  final bool isHomeService;
  /// Jika diisi, booking hanya untuk 1 kendaraan dengan plate ini
  final String? initialVehiclePlate;

  const BookingStep1Screen({
    super.key,
    required this.controller,
    this.isHomeService = false,
    this.initialVehiclePlate,
  });

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  int _selectedVehicleIndex = 0;
  final TextEditingController _notesController = TextEditingController();

  int _prevOdometer = 12450;
  // ignore: unused_field
  int? _swipedDeleteIndex;

  // Master list of registered vehicles in user\'s garage (2 motor garasi)
  static final List<Map<String, dynamic>> _garageVehicles = [
    {
      'id': 'v1',
      'name': 'Honda Vario 160',
      'shortName': 'Vario 160',
      'plate': 'B 1234 XYZ',
      'odometer': 12450,
      'isComplete': true,
      'status': 'Siap Servis',
      'lastService': '15 Agu 2024',
      'selectedPackageIndex': 0, // Servis Berkala (Rp 85.000)
      'parts': <Map<String, dynamic>>[
        {
          'title': 'Oli AHM SPX2',
          'price': 65000,
        },
        {
          'title': 'Kampas Rem Belakang',
          'price': 45000,
        },
      ],
      'selectedParts': <int>{0}, // Only Oli SPX2 checked (85k + 65k = 150k)
      'notes': '',
      'attachedMedia': <Map<String, String>>[],
    },
    {
      'id': 'v2',
      'name': 'Honda Beat',
      'shortName': 'Beat',
      'plate': 'B 5678 JKL',
      'odometer': 8210,
      'isComplete': true,
      'status': 'Servis Rutin Berkala',
      'lastService': '02 Sep 2024',
      'selectedPackageIndex': 1, // Servis CVT (Rp 60.000) -> misal motor 2 centang servis CVT
      'parts': <Map<String, dynamic>>[
        {
          'title': 'Oli Mesin AHM MPX 2 Semi Synthetic (0.8L)',
          'price': 60000,
        },
        {
          'title': 'Gemuk CVT Grease Double Tube AHM',
          'price': 15000,
        },
        {
          'title': 'V-Belt Kit & Roller Weight AHM',
          'price': 135000,
        },
      ],
      'selectedParts': <int>{0, 1}, // Oli MPX 2 & Gemuk CVT checked (60k + 60k + 15k = 135k)
      'notes': 'Tarikan awal gredek saat tanjakan & getar di area CVT',
      'attachedMedia': <Map<String, String>>[],
    },
  ];

  // Helper to clone a vehicle map deeply
  static Map<String, dynamic> _cloneVehicle(Map<String, dynamic> orig) {
    final copy = Map<String, dynamic>.from(orig);
    final rawParts = orig['parts'] as List<Map<String, dynamic>>? ?? [];
    copy['parts'] = rawParts.map((p) => Map<String, dynamic>.from(p)).toList();
    final rawSelected = orig['selectedParts'] as Set<int>? ?? <int>{};
    copy['selectedParts'] = Set<int>.from(rawSelected);
    final rawMedia = orig['attachedMedia'] as List<Map<String, String>>? ?? [];
    copy['attachedMedia'] = rawMedia.map((m) => Map<String, String>.from(m)).toList();
    return copy;
  }

  // Mutable list of vehicles — diisi di initState agar bisa akses widget.initialVehiclePlate
  final List<Map<String, dynamic>> _vehicles = [];

  // Dynamic getters & setters for currently selected vehicle's state
  Map<String, dynamic> get _currentVehicle {
    if (_selectedVehicleIndex >= 0 && _selectedVehicleIndex < _vehicles.length) {
      return _vehicles[_selectedVehicleIndex];
    }
    return _vehicles.isNotEmpty ? _vehicles[0] : {};
  }

  int get _selectedPackageIndex {
    return (_currentVehicle['selectedPackageIndex'] as int?) ?? 0;
  }

  set _selectedPackageIndex(int val) {
    if (_currentVehicle.isNotEmpty) {
      _currentVehicle['selectedPackageIndex'] = val;
    }
  }

  List<Map<String, dynamic>> get _parts {
    final v = _currentVehicle;
    if (!v.containsKey('parts') || v['parts'] == null) {
      v['parts'] = <Map<String, dynamic>>[];
    }
    return v['parts'] as List<Map<String, dynamic>>;
  }

  Set<int> get _selectedParts {
    final v = _currentVehicle;
    if (!v.containsKey('selectedParts') || v['selectedParts'] == null) {
      v['selectedParts'] = <int>{};
    }
    return v['selectedParts'] as Set<int>;
  }

  List<Map<String, String>> get _attachedMedia {
    final v = _currentVehicle;
    if (!v.containsKey('attachedMedia') || v['attachedMedia'] == null) {
      v['attachedMedia'] = <Map<String, String>>[];
    }
    return v['attachedMedia'] as List<Map<String, String>>;
  }

  // Available catalog of extra spare parts (AHASS OEM Rich Dataset)
  static const List<Map<String, dynamic>> _catalogParts = [
    // Pelumas & Kimia
    {
      'title': 'Oli Mesin AHM SPX 2 Full Synthetic (0.8L)',
      'category': 'Pelumas & Kimia',
      'price': 65000,
      'code': '08232-M99-K1LZ3',
      'desc': 'Khusus Matic Honda 110cc - 160cc, perlindungan gesekan maksimal mesin eSP+',
    },
    {
      'title': 'Oli Mesin AHM MPX 2 Semi Synthetic (0.8L)',
      'category': 'Pelumas & Kimia',
      'price': 52000,
      'code': '08232-M99-K1ZN1',
      'desc': 'Efisiensi bahan bakar tinggi dan keawetan komponen mesin harian',
    },
    {
      'title': 'Oli Mesin AHM SPX 1 Bebek / Sport (1.0L)',
      'category': 'Pelumas & Kimia',
      'price': 72000,
      'code': '08232-2BL-K0LZ1',
      'desc': 'Formulasi kopling basah untuk performa tarikan responsif tanpa selip',
    },
    {
      'title': 'Oli Gardan / Gear Oil AHM (120ml)',
      'category': 'Pelumas & Kimia',
      'price': 16000,
      'code': '08232-M99-K1L',
      'desc': 'Pelumasan presisi gear rasio transmisi roda belakang agar hening & awet',
    },
    {
      'title': 'Minyak Rem DOT 4 AHM Original (50ml)',
      'category': 'Pelumas & Kimia',
      'price': 18000,
      'code': '08200-DOT4-AHM',
      'desc': 'Titik didih tinggi menjaga kestabilan pengereman cakram dalam kondisi ekstrem',
    },
    {
      'title': 'Air Radiator AHM Coolant Ready to Use (500ml)',
      'category': 'Pelumas & Kimia',
      'price': 22000,
      'code': '08CLA-M99-001',
      'desc': 'Anti karat dan pendingin optimal suhu blok silinder mesin radiator',
    },
    {
      'title': 'Gemuk CVT Grease Double Tube AHM',
      'category': 'Pelumas & Kimia',
      'price': 15000,
      'code': '08266-999-001',
      'desc': 'Pelumas khusus puli primer dan sekunder CVT tahan temperatur tinggi',
    },
    {
      'title': 'Honda Engine Flush Cleaner (100ml)',
      'category': 'Pelumas & Kimia',
      'price': 28000,
      'code': '08200-FLUSH-AHM',
      'desc': 'Melarutkan kerak endapan lumpur oli lama sebelum diganti oli baru',
    },
    {
      'title': 'Honda Injector Cleaner Gas Additive (60ml)',
      'category': 'Pelumas & Kimia',
      'price': 35000,
      'code': '08200-INJ-CLNR',
      'desc': 'Membersihkan lubang nosel injektor agar semprotan bensin berkabut sempurna',
    },

    // Transmisi CVT
    {
      'title': 'V-Belt Drive & Roller Kit Vario 160 / PCX 160',
      'category': 'Transmisi CVT',
      'price': 145000,
      'code': '23100-K0R-V01',
      'desc': 'Paket vanbelt kevlar original + 6 butir weight roller genuine AHM',
    },
    {
      'title': 'Slider Piece Set CVT (3 Pcs)',
      'category': 'Transmisi CVT',
      'price': 28000,
      'code': '22011-K0R-V00',
      'desc': 'Peredam getaran plat ramp plate puli rumah roller depan',
    },
    {
      'title': 'Kampas Ganda Kopling CVT (Weight Set Clutch)',
      'category': 'Transmisi CVT',
      'price': 135000,
      'code': '22535-K0R-V00',
      'desc': 'Menghilangkan getaran gredek pada tarikan awal motor matic',
    },
    {
      'title': 'Mangkok Kampas Ganda (Outer Comp Clutch)',
      'category': 'Transmisi CVT',
      'price': 115000,
      'code': '22100-K0R-V00',
      'desc': 'Tromol kopling belakang presisi anti oleng dan tahan panas tinggi',
    },
    {
      'title': 'Face Comp Movable Drive (Rumah Roller Depan)',
      'category': 'Transmisi CVT',
      'price': 95000,
      'code': '22110-K0R-V00',
      'desc': 'Jalur roller presisi untuk akselerasi bertahap yang halus tanpa jeda',
    },
    {
      'title': 'Per CVT Spring Driven Face Genuine',
      'category': 'Transmisi CVT',
      'price': 38000,
      'code': '23233-K0R-V01',
      'desc': 'Tekanan pegas stabil untuk buka-tutup secondary pulley matic',
    },
    {
      'title': 'Rantai Roda & Sprocket Gear Set Honda CB/CBR',
      'category': 'Transmisi CVT',
      'price': 295000,
      'code': '06401-K15-900',
      'desc': 'Rantai tipe 428 O-Ring heavy duty + gear depan & belakang presisi',
    },

    // Pengereman
    {
      'title': 'Kampas Rem Depan Cakram (Pad Set Front) Nissin',
      'category': 'Pengereman',
      'price': 48000,
      'code': '06455-KRE-K01',
      'desc': 'Material non-asbestos ramah lingkungan dengan gigitan rem pakem',
    },
    {
      'title': 'Kampas Rem Belakang Cakram (Pad Set Rear) AHM',
      'category': 'Pengereman',
      'price': 52000,
      'code': '06435-K97-N01',
      'desc': 'Pengereman roda belakang presisi anti decit dalam kondisi basah / hujan',
    },
    {
      'title': 'Kampas Rem Tromol Belakang (Brake Shoe Set)',
      'category': 'Pengereman',
      'price': 38000,
      'code': '43130-KZL-930',
      'desc': 'Termasuk sepasang per pegas pengembali kampas tromol',
    },
    {
      'title': 'Piringan Cakram Depan (Disk Front Brake)',
      'category': 'Pengereman',
      'price': 175000,
      'code': '45351-K0R-V01',
      'desc': 'Baja tahan karat berkekuatan tinggi pencegah piringan oleng bergelombang',
    },
    {
      'title': 'Master Rem Caliper Seal Kit Front',
      'category': 'Pengereman',
      'price': 26000,
      'code': '06451-GE2-405',
      'desc': 'Seal karet silinder kaliper pencegah kebocoran minyak rem hidrolik',
    },

    // Filter & Mesin
    {
      'title': 'Filter Udara Viscous Element (Air Cleaner)',
      'category': 'Filter & Mesin',
      'price': 55000,
      'code': '17210-K0R-V00',
      'desc': 'Kertas filter dilapisi oli khusus penyaring debu mikro ke ruang bakar',
    },
    {
      'title': 'Filter Bensin Pompa / Fuel Pump Strainer',
      'category': 'Filter & Mesin',
      'price': 35000,
      'code': '16707-K0R-V01',
      'desc': 'Saringan bensin tangki pencegah endapan lumpur menyumbat injektor',
    },
    {
      'title': 'Paking Tutup Silinder Head Rubber Gasket',
      'category': 'Filter & Mesin',
      'price': 32000,
      'code': '12391-K0R-V00',
      'desc': 'Karet silikon tahan panas tinggi pencegah rembesan oli mesin atas',
    },
    {
      'title': 'Tutup Radiator Cap Comp (1.1 Bar)',
      'category': 'Filter & Mesin',
      'price': 42000,
      'code': '19045-KVB-903',
      'desc': 'Menjaga tekanan sirkulasi pendingin radiator tetap stabil saat panas',
    },

    // Kelistrikan
    {
      'title': 'Busi Standar Denso U27EPR-N9 / NGK MR9C-9N',
      'category': 'Kelistrikan',
      'price': 25000,
      'code': '31916-KRM-841',
      'desc': 'Percikan api busi standar pabrik AHM untuk efisiensi BBM harian',
    },
    {
      'title': 'Busi NGK Laser Iridium CPR9EAIX-9',
      'category': 'Kelistrikan',
      'price': 110000,
      'code': '98067-86871',
      'desc': 'Ujung iridium 0.6mm menghasilkan api lebih fokus & akselerasi bertenaga',
    },
    {
      'title': 'Aki Kering GS Astra GTZ6V MF (12V 5Ah)',
      'category': 'Kelistrikan',
      'price': 275000,
      'code': '31500-KZR-602',
      'desc': 'Aki maintenance-free kapasitas tinggi untuk starter elektrik & ISS',
    },
    {
      'title': 'Bohlam Lampu Depan Halogen Stanley 12V 35/35W',
      'category': 'Kelistrikan',
      'price': 32000,
      'code': '34901-KFV-B01',
      'desc': 'Cahaya fokus terang tembus hujan lebat dan kabut tebal',
    },
    {
      'title': 'Relay Starter Comp Main Relay 4-Pin',
      'category': 'Kelistrikan',
      'price': 45000,
      'code': '38501-KVZ-631',
      'desc': 'Switch saklar arus tinggi motor starter elektrik',
    },
    {
      'title': 'Sekring Mini Blade Fuse Set (5A, 10A, 15A, 25A)',
      'category': 'Kelistrikan',
      'price': 15000,
      'code': '98200-41000',
      'desc': 'Sekring proteksi pengaman korsleting sistem kelistrikan motor',
    },

    // Kaki-kaki & Suspensi
    {
      'title': 'Seal Shock Depan & Dust Seal Set (2 Pcs)',
      'category': 'Kaki-kaki & Suspensi',
      'price': 42000,
      'code': '51490-KGH-901',
      'desc': 'Mencegah oli suspensi depan bocor merembes ke kaliper cakram',
    },
    {
      'title': 'Oli Shock Depan AHM Fork Oil (175ml x 2 Botol)',
      'category': 'Kaki-kaki & Suspensi',
      'price': 24000,
      'code': '08808-FORK-001',
      'desc': 'Redaman empuk suspensi teleskopik di jalan bergelombang & berbatu',
    },
    {
      'title': 'Bearing Roda Depan 6201RS High Speed',
      'category': 'Kaki-kaki & Suspensi',
      'price': 28000,
      'code': '91052-K03-N41',
      'desc': 'Laher roda dengan seal karet ganda pencegah debu & air masuk',
    },
    {
      'title': 'Komstir Bambu / Steering Head Race Cone Set',
      'category': 'Kaki-kaki & Suspensi',
      'price': 85000,
      'code': '06535-GN5-505',
      'desc': 'Menghilangkan stang kemudi kaku atau oblak saat bermanuver',
    },
    {
      'title': 'Karet Damper Tromol Roda Belakang (Rubber Damper)',
      'category': 'Kaki-kaki & Suspensi',
      'price': 30000,
      'code': '06410-KWB-600',
      'desc': 'Peredam hentakan gir rantai dan roda saat perpindahan gigi',
    },
  ];

  static const List<Map<String, dynamic>> _packages = [
    {
      'title': 'Servis Berkala',
      'desc': 'Pengecekan standar lengkap',
      'price': 85000,
    },
    {
      'title': 'Servis CVT',
      'desc': 'Pembersihan dan pelumasan CVT',
      'price': 60000,
    },
    {
      'title': 'Tune Up Injeksi',
      'desc': 'Kalibrasi & pembersihan injektor',
      'price': 75000,
    },
  ];

  @override
  void initState() {
    super.initState();

    final filterPlate = widget.initialVehiclePlate;
    if (filterPlate != null && filterPlate.isNotEmpty) {
      // Dari card garasi: hanya booking kendaraan ini
      // Coba cari di static list dulu
      final staticMatch = _garageVehicles.firstWhere(
        (g) => g['plate'] == filterPlate,
        orElse: () => <String, dynamic>{},
      );
      if (staticMatch.isNotEmpty) {
        _vehicles.add(_cloneVehicle(staticMatch));
      } else {
        // Kendaraan dinamis (ditambahkan via form) — ambil dari controller
        final ctrlMatch = widget.controller.vehicles.firstWhere(
          (v) => v.plateNumber == filterPlate,
          orElse: () => widget.controller.vehicles.first,
        );
        final dynamicMap = {
          'id': ctrlMatch.id,
          'name': ctrlMatch.name,
          'shortName': ctrlMatch.name.replaceFirst('Honda ', ''),
          'plate': ctrlMatch.plateNumber,
          'odometer': ctrlMatch.odometerKm > 0 ? ctrlMatch.odometerKm : 1500,
          'isComplete': true,
          'status': 'Siap Servis',
          'lastService': ctrlMatch.lastService,
          'selectedPackageIndex': 0,
          'parts': <Map<String, dynamic>>[
            {'title': 'Oli AHM SPX2', 'price': 65000},
          ],
          'selectedParts': <int>{0},
          'notes': '',
          'attachedMedia': <Map<String, String>>[],
        };
        _garageVehicles.add(dynamicMap);
        _vehicles.add(_cloneVehicle(dynamicMap));
      }
    } else {
      // Default (dari navbar): semua 2 kendaraan garasi
      _vehicles.add(_cloneVehicle(_garageVehicles[0]));
      _vehicles.add(_cloneVehicle(_garageVehicles[1]));
    }

    if (_vehicles.isNotEmpty) {
      _prevOdometer = (_vehicles[0]['odometer'] as int?) ?? 12450;
      _notesController.text = (_vehicles[0]['notes'] as String?) ?? '';
    }
  }



  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _totalPrice {
    int total = 0;
    for (final v in _vehicles) {
      final pkgIdx = (v['selectedPackageIndex'] as int?) ?? 0;
      if (pkgIdx >= 0 && pkgIdx < _packages.length) {
        total += _packages[pkgIdx]['price'] as int;
      }
      final parts = (v['parts'] as List<Map<String, dynamic>>?) ?? [];
      final selectedParts = (v['selectedParts'] as Set<int>?) ?? {};
      for (final pIdx in selectedParts) {
        if (pIdx >= 0 && pIdx < parts.length) {
          total += parts[pIdx]['price'] as int;
        }
      }
    }
    return total;
  }

  String _formatCurrency(int amount) {
    return 'Rp ${_formatNumber(amount)}';
  }

  static String _formatNumber(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) buffer.write('.');
    }
    return buffer.toString().split('').reversed.join('');
  }

  // -------------------------------------------------------------
  // FEATURE 1.1: Switch Vehicle & Hapus Unit Motor
  // -------------------------------------------------------------
  void _switchVehicle(int index) {
    if (index < 0 || index >= _vehicles.length) return;
    if (_selectedVehicleIndex >= 0 && _selectedVehicleIndex < _vehicles.length) {
      _vehicles[_selectedVehicleIndex]['notes'] = _notesController.text;
    }
    setState(() {
      _selectedVehicleIndex = index;
      _swipedDeleteIndex = null;
      final cur = _vehicles[index];
      _notesController.text = (cur['notes'] as String?) ?? '';
      _prevOdometer = (cur['odometer'] as int?) ?? 12450;
    });
  }

  void _deleteVehicle(int index) {
    if (_vehicles.length <= 1) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal harus ada 1 unit motor untuk booking servis!'),
          backgroundColor: Color(0xFFE11D48),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedVehicleIndex >= 0 && _selectedVehicleIndex < _vehicles.length) {
      _vehicles[_selectedVehicleIndex]['notes'] = _notesController.text;
    }

    final deletedItem = _vehicles[index];
    final deletedIndex = index;

    setState(() {
      _vehicles.removeAt(index);
      _swipedDeleteIndex = null;
      if (_selectedVehicleIndex >= _vehicles.length) {
        _selectedVehicleIndex = _vehicles.length - 1;
      }
      if (_vehicles.isNotEmpty) {
        final cur = _vehicles[_selectedVehicleIndex];
        _notesController.text = (cur['notes'] as String?) ?? '';
        _prevOdometer = (cur['odometer'] as int?) ?? 12450;
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' berhasil dihapus dari booking'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'URUNGKAN',
          textColor: const Color(0xFFF97316),
          onPressed: () {
            setState(() {
              _vehicles.insert(deletedIndex, deletedItem);
              _selectedVehicleIndex = deletedIndex;
              _notesController.text = (deletedItem['notes'] as String?) ?? '';
              _prevOdometer = (deletedItem['odometer'] as int?) ?? 12450;
            });
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // FEATURE 1: Tambah / Pilih Unit Motor dari Garasi (Bisa 1, 2, atau Keduanya)
  // -------------------------------------------------------------
  void _showAddUnitSheet(bool isDark) {
    // Ambil daftar plat nomor yang saat ini aktif di booking
    final selectedPlates = _vehicles.map((v) => (v['plate'] as String?) ?? '').toSet();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.two_wheeler_rounded,
                        color: Color(0xFFF97316),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Unit Motor dari Garasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Pilih motor yang ingin diservis (bisa 1, 2, atau keduanya)',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Presets: Pilih Keduanya / Hanya Vario / Hanya Beat
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFFF97316)),
                        label: const Text('Pilih Keduanya'),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selectedPlates.length == _garageVehicles.length
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                        ),
                        backgroundColor: selectedPlates.length == _garageVehicles.length
                            ? const Color(0xFFF97316)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        side: BorderSide.none,
                        onPressed: () {
                          setModalState(() {
                            selectedPlates.clear();
                            for (final g in _garageVehicles) {
                              selectedPlates.add((g['plate'] as String?) ?? '');
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Hanya Vario 160'),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selectedPlates.length == 1 && selectedPlates.contains('B 1234 XYZ')
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                        ),
                        backgroundColor: selectedPlates.length == 1 && selectedPlates.contains('B 1234 XYZ')
                            ? const Color(0xFFF97316)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        side: BorderSide.none,
                        onPressed: () {
                          setModalState(() {
                            selectedPlates.clear();
                            selectedPlates.add('B 1234 XYZ');
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Hanya Beat'),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selectedPlates.length == 1 && selectedPlates.contains('B 5678 JKL')
                              ? Colors.white
                              : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
                        ),
                        backgroundColor: selectedPlates.length == 1 && selectedPlates.contains('B 5678 JKL')
                            ? const Color(0xFFF97316)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        side: BorderSide.none,
                        onPressed: () {
                          setModalState(() {
                            selectedPlates.clear();
                            selectedPlates.add('B 5678 JKL');
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Daftar Motor dari Garasi (Cards dengan Checkbox)
                ..._garageVehicles.map((motor) {
                  final plate = (motor['plate'] as String?) ?? '';
                  final isChecked = selectedPlates.contains(plate);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setModalState(() {
                          if (isChecked) {
                            if (selectedPlates.length > 1) {
                              selectedPlates.remove(plate);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Minimal harus memilih 1 motor untuk servis!'),
                                  backgroundColor: Color(0xFFE11D48),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } else {
                            selectedPlates.add(plate);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isChecked
                              ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isChecked
                                ? const Color(0xFFF97316)
                                : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                            width: isChecked ? 1.6 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isChecked
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isChecked
                                  ? const Color(0xFFF97316)
                                  : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isChecked
                                    ? const Color(0xFFFFEDD5)
                                    : (isDark ? const Color(0xFF0F172A) : Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.two_wheeler_rounded,
                                color: Color(0xFFF97316),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (motor['name'] as String?) ?? 'Honda Motor',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      if (isChecked)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDCFCE7),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Terpilih',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF16A34A),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${motor['plate']} • ${_formatNumber(motor['odometer'] as int)} km',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Status: ${motor['status']}',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 6),

                // Button Tambah Motor Baru ke Garasi & Booking
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      showTambahMotorSheet(
                        context,
                        controller: widget.controller,
                        onVehicleAdded: (newVehicle) {
                          final newMap = {
                            'id': newVehicle.id,
                            'name': newVehicle.name,
                            'shortName': newVehicle.name.replaceFirst('Honda ', ''),
                            'plate': newVehicle.plateNumber,
                            'odometer': newVehicle.odometerKm > 0 ? newVehicle.odometerKm : 1500,
                            'isComplete': true,
                            'status': 'Siap Servis',
                            'lastService': 'Baru Didaftarkan',
                            'selectedPackageIndex': 0,
                            'parts': <Map<String, dynamic>>[
                              {
                                'title': 'AHM Oil SPX2 0.8L (Fully Synthetic)',
                                'partNumber': '08234-2PK-25N',
                                'price': 69000,
                                'qty': 1,
                                'isRecommended': true,
                                'warranty': 'Garansi Resmi AHM 100% Original',
                              },
                            ],
                            'notes': '',
                          };
                          setState(() {
                            _garageVehicles.add(newMap);
                            _vehicles.add(_cloneVehicle(newMap));
                            _selectedVehicleIndex = _vehicles.length - 1;
                            _notesController.text = '';
                            _prevOdometer = newMap['odometer'] as int;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${newVehicle.name} (${newVehicle.plateNumber}) berhasil didaftarkan dan dipilih untuk booking!'),
                              backgroundColor: const Color(0xFF16A34A),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 18,
                            color: Color(0xFFF97316),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+ Daftarkan Motor Baru (Form Lengkap AHASS)',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Button Terapkan
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final newVehicles = <Map<String, dynamic>>[];
                      for (final plate in selectedPlates) {
                        final existing = _vehicles.firstWhere(
                          (v) => v['plate'] == plate,
                          orElse: () => <String, dynamic>{},
                        );
                        if (existing.isNotEmpty) {
                          newVehicles.add(existing);
                        } else {
                          final garage = _garageVehicles.firstWhere(
                            (g) => g['plate'] == plate,
                            orElse: () => _garageVehicles[0],
                          );
                          newVehicles.add(_cloneVehicle(garage));
                        }
                      }

                      if (_selectedVehicleIndex >= 0 && _selectedVehicleIndex < _vehicles.length) {
                        _vehicles[_selectedVehicleIndex]['notes'] = _notesController.text;
                      }

                      setState(() {
                        _vehicles.clear();
                        _vehicles.addAll(newVehicles);
                        if (_selectedVehicleIndex >= _vehicles.length) {
                          _selectedVehicleIndex = 0;
                        }
                        _swipedDeleteIndex = null;
                        if (_vehicles.isNotEmpty) {
                          final cur = _vehicles[_selectedVehicleIndex];
                          _notesController.text = (cur['notes'] as String?) ?? '';
                          _prevOdometer = (cur['odometer'] as int?) ?? 12450;
                        }
                      });

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newVehicles.length == 2
                                ? 'Kedua motor berhasil dipilih untuk booking!'
                                : '${newVehicles.first['name']} berhasil dipilih untuk booking!',
                          ),
                          backgroundColor: const Color(0xFF16A34A),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Terapkan Unit (${selectedPlates.length} Motor)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // FEATURE 2: Set Odometer dengan Animasi Roll
  // -------------------------------------------------------------
  void _showOdometerSheet(bool isDark) {
    final currentOdo = _vehicles[_selectedVehicleIndex]['odometer'] as int;
    final odoController = TextEditingController(text: currentOdo.toString());
    int tempOdo = currentOdo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.speed_rounded,
                        color: Color(0xFFF97316),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Perbarui Odometer Motor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Masukkan jarak tempuh kilometer aktual motor kamu:',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),

                // Display Big Value Preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFF97316).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_formatNumber(tempOdo)} KM',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFF97316),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Status servis akan dihitung otomatis dari nilai ini',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Quick add buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [500, 1000, 2000, 5000].map((step) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: const Icon(Icons.add_rounded, size: 14, color: Color(0xFFF97316)),
                          label: Text(
                            '+${_formatNumber(step)} km',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          onPressed: () {
                            setModalState(() {
                              tempOdo += step;
                              odoController.text = tempOdo.toString();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Manual Input Field
                TextField(
                  controller: odoController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = int.tryParse(val.trim());
                    if (p != null) {
                      setModalState(() => tempOdo = p);
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.edit_road_rounded, color: Color(0xFF64748B)),
                    suffixText: 'KM',
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final parsed = int.tryParse(odoController.text.trim()) ?? tempOdo;
                      setState(() {
                        _prevOdometer = _vehicles[_selectedVehicleIndex]['odometer'] as int;
                        _vehicles[_selectedVehicleIndex]['odometer'] = parsed;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Terapkan Odometer Baru',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // FEATURE 3: Pilih Suku Cadang Lainnya (Katalog Modal Kaya Data)
  // -------------------------------------------------------------
  void _showSparepartsCatalogSheet(bool isDark) {
    final Set<int> tempSelectedCatalog = {};
    String searchQuery = '';
    String selectedCategory = 'Semua';
    final searchCtrl = TextEditingController();

    const categories = [
      'Semua',
      'Pelumas & Kimia',
      'Transmisi CVT',
      'Pengereman',
      'Filter & Mesin',
      'Kelistrikan',
      'Kaki-kaki & Suspensi',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          // Filter parts based on search and selected category
          final filteredIndices = <int>[];
          for (int i = 0; i < _catalogParts.length; i++) {
            final part = _catalogParts[i];
            final title = ((part['title'] as String?) ?? '').toLowerCase();
            final code = ((part['code'] as String?) ?? '').toLowerCase();
            final cat = (part['category'] as String?) ?? 'Semua';
            final desc = ((part['desc'] as String?) ?? '').toLowerCase();

            final matchesCategory = selectedCategory == 'Semua' || cat == selectedCategory;
            final q = searchQuery.toLowerCase().trim();
            final matchesSearch = q.isEmpty ||
                title.contains(q) ||
                code.contains(q) ||
                desc.contains(q);

            if (matchesCategory && matchesSearch) {
              filteredIndices.add(i);
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.construction_rounded,
                        color: Color(0xFFF97316),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Katalog Suku Cadang & Oli AHASS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '${_catalogParts.length} Suku Cadang Resmi AHM Original Siap Pasang',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Bar Input
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: (val) {
                      setModalState(() => searchQuery = val);
                    },
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari nama suku cadang, part number (cth: SPX, V-Belt, Busi)...',
                      hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                searchCtrl.clear();
                                setModalState(() => searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Category Filter Chips
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      final cat = categories[idx];
                      final isSel = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                            color: isSel
                                ? Colors.white
                                : (isDark ? Colors.white70 : const Color(0xFF475569)),
                          ),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFFF97316),
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                        onSelected: (val) {
                          setModalState(() => selectedCategory = cat);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Results count & info
                Row(
                  children: [
                    Text(
                      'Menampilkan ${filteredIndices.length} suku cadang',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    if (tempSelectedCatalog.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${tempSelectedCatalog.length} Dipilih',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFF97316),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Scrollable List of Parts
                Expanded(
                  child: filteredIndices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Suku cadang tidak ditemukan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Coba gunakan kata kunci pencarian lain',
                                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredIndices.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final index = filteredIndices[i];
                            final part = _catalogParts[index];
                            final isAlreadyAdded = _parts.any((p) => p['title'] == part['title']);
                            final isSelected = tempSelectedCatalog.contains(index) || isAlreadyAdded;

                            return InkWell(
                              onTap: isAlreadyAdded
                                  ? null
                                  : () {
                                      setModalState(() {
                                        if (tempSelectedCatalog.contains(index)) {
                                          tempSelectedCatalog.remove(index);
                                        } else {
                                          tempSelectedCatalog.add(index);
                                        }
                                      });
                                    },
                              borderRadius: BorderRadius.circular(14),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFF97316)
                                        : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                                    width: isSelected ? 1.4 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_box_rounded
                                            : Icons.check_box_outline_blank_rounded,
                                        color: isSelected
                                            ? const Color(0xFFF97316)
                                            : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  (part['title'] as String?) ?? '',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '+${_formatCurrency(part['price'] as int)}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFFF97316),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                                decoration: BoxDecoration(
                                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  (part['code'] as String?) ?? '',
                                                  style: TextStyle(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '•  ${part['category']}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? AppColors.textSecondaryDark
                                                      : const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (part['desc'] != null) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              (part['desc'] as String?) ?? '',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                          if (isAlreadyAdded) ...[
                                            const SizedBox(height: 4),
                                            const Text(
                                              '✓ Sudah ada dalam booking',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF16A34A),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 14),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        for (final idx in tempSelectedCatalog) {
                          final item = _catalogParts[idx];
                          if (!_parts.any((p) => p['title'] == item['title'])) {
                            _parts.add({
                              'title': item['title'],
                              'price': item['price'],
                            });
                            _selectedParts.add(_parts.length - 1);
                          }
                        }
                      });
                      Navigator.pop(ctx);
                      if (tempSelectedCatalog.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${tempSelectedCatalog.length} suku cadang berhasil ditambahkan ke booking!',
                            ),
                            backgroundColor: const Color(0xFF16A34A),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Text(
                      tempSelectedCatalog.isEmpty
                          ? 'Tutup Katalog'
                          : 'Tambahkan ke Booking (${tempSelectedCatalog.length} Dipilih)',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // FEATURE 4: Tambah Foto / Video Kendala
  // -------------------------------------------------------------
  void _showMediaPickerSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tambah Bukti Foto/Video Kendala',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Bantu mekanik AHASS menganalisa masalah motor kamu sebelum tiba:',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF2563EB)),
              ),
              title: const Text('Ambil Foto via Kamera', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              subtitle: const Text('Foto bagian mesin, rem, CVT atau body yang bermasalah', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                _addMockMedia('Foto Bagian Mesin/CVT', 'image');
              },
            ),
            const Divider(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_rounded, color: Color(0xFF16A34A)),
              ),
              title: const Text('Pilih dari Galeri Foto', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              subtitle: const Text('Pilih foto yang tersimpan di galeri HP', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                _addMockMedia('Foto Riwayat Kerusakan', 'image');
              },
            ),
            const Divider(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.videocam_rounded, color: Color(0xFFE11D48)),
              ),
              title: const Text('Rekam Video / Suara Kendala (Maks 30 dtk)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
              subtitle: const Text('Rekam suara getaran gredek / bunyi decit rem', style: TextStyle(fontSize: 11)),
              onTap: () {
                Navigator.pop(ctx);
                _addMockMedia('Video Suara Mesin', 'video');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addMockMedia(String label, String type) {
    setState(() {
      _attachedMedia.add({
        'title': '$label #${_attachedMedia.length + 1}',
        'type': type,
        'size': type == 'video' ? '8.4 MB' : '2.1 MB',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil dilampirkan!'),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBack() {
    widget.controller.setNavIndex(0);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.controller.isDarkMode;
    const primaryColor = Color(0xFFF97316);
    final currentOdo = _vehicles[_selectedVehicleIndex]['odometer'] as int;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            onPressed: _handleBack,
          ),
        titleSpacing: 0,
        title: Text(
          'Booking Servis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stepper Bar
            Container(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepItem(1, 'Pilih Unit & Servis', isActive: true, isDark: isDark),
                  _buildStepConnector(),
                  _buildStepItem(2, 'Bengkel & Waktu', isActive: false, isDark: isDark),
                  _buildStepConnector(),
                  _buildStepItem(3, 'Konfirmasi', isActive: false, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Unit Selection Cards Row (Swipe to Reveal Red Delete Button)
            SizedBox(
              height: 84,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  ...List.generate(_vehicles.length, (i) {
                    final v = _vehicles[i];
                    final isSelected = _selectedVehicleIndex == i;
                    // Tombol sampah merah selalu muncul saat motor dipilih / diklik
                    final isDeleteOpen = isSelected;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _buildVehicleCard(
                            index: i,
                            title: 'Motor ${i + 1}:',
                            name: (v['shortName'] as String?) ?? (v['name'] as String?) ?? 'Motor',
                            isSelected: isSelected,
                            badgeText: (v['isComplete'] as bool? ?? true) ? 'Terpilih' : 'Belum Lengkap',
                            isDark: isDark,
                          ),
                        ),
                        // Red Trash Delete Box (Selalu muncul saat pilihan diklik atau di-swipe)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: isDeleteOpen ? 60 : 0,
                          height: 72,
                          margin: EdgeInsets.only(right: isDeleteOpen ? 8 : 0),
                          child: isDeleteOpen
                              ? InkWell(
                                  onTap: () => _deleteVehicle(i),
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    width: 54,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    );
                  }),
                  // Clickable + Unit Card
                  _buildAddUnitCard(isDark),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 3. Main Big Card Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.two_wheeler_rounded,
                            color: Color(0xFF334155),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (_currentVehicle['name'] as String?) ?? 'Honda Motor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              (_currentVehicle['plate'] as String?) ?? 'B 1234 XYZ',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Odometer Bar with Roll Animation & Click to Edit
                    InkWell(
                      onTap: () => _showOdometerSheet(isDark),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFEDF2F7),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.speed_rounded,
                              color: Color(0xFF64748B),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Odometer Saat Ini:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const Spacer(),
                            // Animated Counting Odometer Text
                            TweenAnimationBuilder<double>(
                              key: ValueKey('${_selectedVehicleIndex}_$currentOdo'),
                              tween: Tween<double>(
                                begin: _prevOdometer.toDouble(),
                                end: currentOdo.toDouble(),
                              ),
                              duration: const Duration(milliseconds: 650),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Text(
                                  '${_formatNumber(value.round())} km',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.edit_rounded,
                              color: primaryColor,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 1: Pilih Paket Servis
                    const Row(
                      children: [
                        Icon(Icons.handyman_rounded, color: primaryColor, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Pilih Paket Servis',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_packages.length, (index) {
                      final pkg = _packages[index];
                      final isSelected = _selectedPackageIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedPackageIndex = index);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: primaryColor,
                                        size: 22,
                                      )
                                    : Icon(
                                        Icons.radio_button_unchecked,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : const Color(0xFF64748B),
                                        size: 22,
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (pkg['title'] as String?) ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (pkg['desc'] as String?) ?? '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _formatCurrency(pkg['price'] as int),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? primaryColor
                                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 18),

                    // Section 2: Suku Cadang & Oli
                    const Row(
                      children: [
                        Icon(Icons.settings_rounded, color: primaryColor, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Suku Cadang & Oli',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_parts.length, (index) {
                      final part = _parts[index];
                      final isChecked = _selectedParts.contains(index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                _selectedParts.remove(index);
                              } else {
                                _selectedParts.add(index);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isChecked
                                    ? primaryColor
                                    : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                                width: isChecked ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                isChecked
                                    ? const Icon(
                                        Icons.check_box_rounded,
                                        color: primaryColor,
                                        size: 22,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank_rounded,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : const Color(0xFF64748B),
                                        size: 22,
                                      ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    (part['title'] as String?) ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                Text(
                                  '+${_formatCurrency(part['price'] as int)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isChecked
                                        ? primaryColor
                                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 4),

                    // + Pilih Suku Cadang Lainnya (Clickable modal catalog)
                    InkWell(
                      onTap: () => _showSparepartsCatalogSheet(isDark),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded, color: primaryColor, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Pilih Suku Cadang Lainnya',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section 3: Catatan Keluhan / Masalah
                    const Row(
                      children: [
                        Icon(Icons.description_rounded, color: primaryColor, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Catatan Keluhan / Masalah',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Textarea box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        controller: _notesController,
                        onChanged: (val) {
                          if (_currentVehicle.isNotEmpty) {
                            _currentVehicle['notes'] = val;
                          }
                        },
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText:
                              'Contoh: Tarikan awal gredek di tanjakan, rem belakang bunyi mencicit...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Tambah Foto/Video Kendala Button (Clickable sheet)
                    InkWell(
                      onTap: () => _showMediaPickerSheet(isDark),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _attachedMedia.isEmpty
                                  ? 'Tambah Foto/Video Kendala'
                                  : 'Tambah Foto/Video (${_attachedMedia.length})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Attached Media Preview Row (if any items attached)
                    if (_attachedMedia.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _attachedMedia.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final m = _attachedMedia[i];
                            final isVid = m['type'] == 'video';
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isVid ? Icons.videocam_rounded : Icons.image_rounded,
                                    size: 18,
                                    color: isVid ? const Color(0xFFE11D48) : const Color(0xFF2563EB),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        m['title'] ?? 'Media',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        m['size'] ?? '',
                                        style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () {
                                      setState(() => _attachedMedia.removeAt(i));
                                    },
                                    child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // 4. Sticky Bottom Summary Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_vehicles.length} Motor Terpilih • ~90 Menit',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCurrency(_totalPrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    final vehicle = widget.controller.selectedVehicle;
                    final service = widget.controller.services.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchedulePickerScreen(
                          controller: widget.controller,
                          vehicle: vehicle,
                          service: service,
                          isHomeService: widget.isHomeService,
                          totalPrice: _totalPrice,
                          vehicles: _vehicles,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Lanjut ke Jadwal & Bengkel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildStepItem(int stepNumber, String title, {required bool isActive, required bool isDark}) {
    const activeColor = Color(0xFFF97316);
    const inactiveColor = Color(0xFF94A3B8);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isActive ? activeColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$stepNumber',
            style: TextStyle(
              color: isActive ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF64748B)),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Container(
      width: 32,
      height: 1.5,
      margin: const EdgeInsets.only(bottom: 16, left: 6, right: 6),
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildVehicleCard({
    required int index,
    required String title,
    required String name,
    required bool isSelected,
    required String badgeText,
    required bool isDark,
  }) {
    const primaryColor = Color(0xFFF97316);

    return InkWell(
      onTap: () => _switchVehicle(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 145,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFF7ED)
                    : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.two_wheeler_rounded,
                size: 20,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isSelected)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 11,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Terpilih',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Clickable Add Unit Card with Custom Dashed Border
  Widget _buildAddUnitCard(bool isDark) {
    return InkWell(
      onTap: () => _showAddUnitSheet(isDark),
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: isDark ? AppColors.borderDark : const Color(0xFF94A3B8),
          strokeWidth: 1.2,
          radius: 16,
          dashWidth: 4.5,
          dashSpace: 3.5,
        ),
        child: Container(
          width: 100,
          height: 72,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                size: 16,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
              const SizedBox(width: 4),
              Text(
                'Unit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.radius = 16,
    this.dashWidth = 4.5,
    this.dashSpace = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        final extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
