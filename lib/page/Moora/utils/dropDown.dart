import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:spk_app/page/Moora/utils/dialogHasil.dart';
import 'package:spk_app/page/Moora/utils/hitungSepatu.dart';

class Dropdown extends StatefulWidget {
  final int jml_dropdown;
  const Dropdown({super.key, required this.jml_dropdown});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> semuaDataDropdown = [];
  List<String?> hasilPilihan = [];
  int jumlahDropdown = 0;

  @override
  void initState() {
    super.initState();
    jumlahDropdown = widget.jml_dropdown;
    ambilDataDariTigaKoleksi();
  }

  Future<void> ambilDataDariTigaKoleksi() async {
    List<String> hasil = [];

    try {
      final koleksiList = [
        {
          'nama': 'compass',
          'snap': await FirebaseFirestore.instance.collection('compass').get(),
        },
        {
          'nama': 'kanky',
          'snap': await FirebaseFirestore.instance.collection('kanky').get(),
        },
        {
          'nama': 'patrobas',
          'snap': await FirebaseFirestore.instance.collection('patrobas').get(),
        },
      ];

      for (var koleksi in koleksiList) {
        final namaKoleksi = koleksi['nama'];
        final snap = koleksi['snap'] as QuerySnapshot;

        for (var doc in snap.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('tipe_sepatu')) {
            final tipe = data['tipe_sepatu'];
            hasil.add('$namaKoleksi $tipe');
          }
        }
      }

      setState(() {
        semuaDataDropdown = hasil.toSet().toList();
        hasilPilihan = List.filled(jumlahDropdown, null);
      });
    } catch (e) {
      print("Error ambil data: $e");
    }
  }

  Future<void> simpanKeFirestore(List<Map<String, dynamic>> hasilList) async {
    try {
      for (var data in hasilList) {
        await FirebaseFirestore.instance.collection('hasil_moora').add(data);
      }
    } catch (e) {
      print("Error simpan ke Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFB),
      body:
          semuaDataDropdown.isEmpty
              ? Center(
                child: Lottie.asset(
                  'assets/animation/Loading.json',
                  width: 500,
                  height: 500,
                  repeat: true,
                  reverse: false,
                  animate: true,
                ),
              )
              : Column(
                children: [
                  for (int i = 0; i < jumlahDropdown; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: CustomAutocompleteDropdown(
                        items: semuaDataDropdown,
                        label: 'Sepatu ke-${i + 1}',
                        initialValue: hasilPilihan[i],
                        onSelected: (value) {
                          setState(() {
                            hasilPilihan[i] = value;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F98CA),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        shadowColor: Colors.black,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (hasilPilihan.contains(null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Semua pilihan harus diisi"),
                            ),
                          );
                        } else {
                          final List<String> pilihanAkhir =
                              hasilPilihan.whereType<String>().toList();
                          try {
                            final hasil = await hitungSepatu(pilihanAkhir);
                            await simpanKeFirestore(hasil);
                            // cekDataSepatuTidakLengkap(); buat debug
                            setState(() {});
                            print('Data telah disimpan');
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialoghasil();
                              },
                            );
                          } catch (e, stackTrace) {
                            print(
                              '🔥 Error saat menghitung atau menyimpan: $e',
                            );
                            print('📌 Stacktrace: $stackTrace');
                          }
                        }
                      },
                      child: const Text(
                        "Hitung",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEFFFFB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class CustomAutocompleteDropdown extends StatefulWidget {
  final List<String> items;
  final void Function(String) onSelected;
  final String label;
  final String? initialValue;

  const CustomAutocompleteDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    required this.label,
    this.initialValue,
  });

  @override
  State<CustomAutocompleteDropdown> createState() =>
      _CustomAutocompleteDropdownState();
}

class _CustomAutocompleteDropdownState
    extends State<CustomAutocompleteDropdown> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });

    _controller.addListener(() {
      _filterItems();
    });
  }

  void _filterItems() {
    final query = _controller.text.toLowerCase();
    _filteredItems =
        widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    _filteredItems = widget.items;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    //box sugestions
    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 5),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF4F98CA),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children:
                        _filteredItems
                            .map(
                              (item) => ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFEFFFFB),
                                  ),
                                ),
                                onTap: () {
                                  _controller.text = item;
                                  widget.onSelected(item);
                                  _focusNode.unfocus();
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  //box field
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Color(0xFF272727),
        ),
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(142, 39, 39, 39),
          ),
          floatingLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF272727),
          ),
          filled: true,
          fillColor: const Color(0xFFEFFFFB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF272727), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(142, 39, 39, 39),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
