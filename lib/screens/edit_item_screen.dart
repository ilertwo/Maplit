import 'package:flutter/material.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/custom_text_field.dart';
import 'item_details_screen.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Hair dryer');
  final TextEditingController _personController = TextEditingController(text: 'Roma');
  final TextEditingController _dateController = TextEditingController(text: '25.09.2026');

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
          'Edit item',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/3.png',
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Поле вводу "Item name"
              CustomTextField(
                controller: _nameController,
                labelText: 'Item name',
                hintText: 'Enter item name',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Поле вводу "Contact person"
              CustomTextField(
                controller: _personController,
                labelText: 'Contact person',
                hintText: 'Enter contact name',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
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
                    initialDate: DateTime(2027, 10, 23),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
          child: PrimaryButton(
            text: 'Save',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailsScreen(
                    title: _nameController.text,
                    imageUrl: 'assets/images/3.png',
                    updatedText: 'Updated 2 days ago',
                    dateText: _dateController.text,
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