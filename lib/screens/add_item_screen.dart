import 'package:flutter/material.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import 'item_details_screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Hair dryer');
  final TextEditingController _personController = TextEditingController(text: 'Roma');
  final TextEditingController _dateController = TextEditingController(text: 'Oct 03, 2026');

  bool _isLend = true; // true = Lend, false = Borrow

  @override
  void dispose() {
    _nameController.dispose();
    _personController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add an item',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/6.png',
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6B4FA0),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const CustomTextField(
                labelText: 'Item name',
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                hintText: 'Item name',
              ),
              const SizedBox(height: 16),

              // Поле вводу "Contact person"
              const CustomTextField(
                labelText: 'Contact person',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
                hintText: 'Contact person',
              ),
              const SizedBox(height: 16),

              // Перемикач "Type" (Lend / Borrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Кнопка Lend
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLend = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _isLend ? const Color(0xFFEFE7F8) : Colors.transparent,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isLend) ...[
                                    const Icon(Icons.check, size: 18, color: Color(0xFF6B4FA0)),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    'Lend',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _isLend ? const Color(0xFF6B4FA0) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1, height: 48, color: Colors.grey.shade400),
                        // Кнопка Borrow
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLend = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_isLend ? const Color(0xFFEFE7F8) : Colors.transparent,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!_isLend) ...[
                                    const Icon(Icons.check, size: 18, color: Color(0xFF6B4FA0)),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    'Borrow',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: !_isLend ? const Color(0xFF6B4FA0) : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Поле вибору дати "Return date"
              CustomTextField(
                controller: _dateController,
                labelText: 'Return date',
                hintText: 'DD.MM.YYYY',
                prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2026, 10, 3),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      String day = pickedDate.day.toString().padLeft(2, '0');
                      String month = pickedDate.month.toString().padLeft(2, '0');
                      _dateController.text = "$day.$month.${pickedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Кнопка "Save"
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
          child: PrimaryButton(
            text: 'Save',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ItemDetailsScreen(
                    title: 'Hair dryer',
                    imageUrl: 'assets/images/6.png',
                    updatedText: 'Updated 2 days ago',
                    dateText: '03.09.2026',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}