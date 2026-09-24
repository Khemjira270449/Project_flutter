import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/plant_record_model.dart';
import '../services/database_helper.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class plantEntry extends StatefulWidget {
  final plantRecordModel plantRecord;
  final String action;
  const plantEntry({
    super.key,
    required this.action,
    required this.plantRecord,
  });

  @override
  State<plantEntry> createState() => _plantEntryState();
}

class _plantEntryState extends State<plantEntry> {
  late plantRecordModel newPlantRecord;
  late String title, buttonText;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    title = widget.action == 'add'
        ? 'Billing Entry (ADD)'
        : 'Billing Entry (EDIT)';
    buttonText = widget.action == 'add' ? 'Add' : 'Update';
    newPlantRecord = widget.plantRecord;
  }

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // plant ID
              TextFormField(
                initialValue: newPlantRecord.plantId,
                decoration: InputDecoration(
                  labelText: 'รหัสพืช (Plant ID)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอก Plant ID' : null,
                onSaved: (value) => newPlantRecord.plantId = value!,
              ),
              SizedBox(height: 15),

               // plant Name
              TextFormField(
                initialValue: newPlantRecord.plantName,
                decoration: InputDecoration(
                  labelText: 'ชื่อพืช (Plant Name)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอก Plant Name' : null,
                onSaved: (value) => newPlantRecord.plantName = value!,
              ),
              SizedBox(height: 15),

              // Month (with month picker)
              TextFormField(
                controller: _monthController,
                decoration: InputDecoration(
                  labelText: 'เดือน/ปี',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      String pickerDate = await selectMonth();
                      setState(() {
                        newPlantRecord.month = pickerDate;
                        // 2. อัปเดตค่าใน Controller เพื่อให้ตัวหนังสือเปลี่ยนบนหน้าจอ
                        _monthController.text = pickerDate;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกเดือน/ปี' : null,
                onSaved: (value) => newPlantRecord.month = value!,
              ),
              SizedBox(height: 15),

               // disease
              TextFormField(
                initialValue: newPlantRecord.disease,
                decoration: InputDecoration(
                  labelText: 'โรคพืช (Disease)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกโรคพืช' : null,
                onSaved: (value) => newPlantRecord.disease = value!,
              ),
              SizedBox(height: 15),

               // treatment
              TextFormField(
                initialValue: newPlantRecord.treatmentProducts,
                decoration: InputDecoration(
                  labelText: 'ผลิตภัณฑ์สำหรับรักษ์โรคพืช (Treatment Products)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกผลิตภัณฑ์รักษ์โรคพืช' : null,
                onSaved: (value) => newPlantRecord.treatmentProducts = value!,
              ),
              SizedBox(height: 15),

              // Paid Status (Radio Buttons)
              Text(
                'สถานะการรักษา:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioGroup<String>(
                // กำหนดค่าที่เลือกในปัจจุบันไว้ที่นี่ที่เดียว
                groupValue: newPlantRecord.paidStatus,

                // เมื่อมีการเปลี่ยนค่าในกลุ่มนี้
                onChanged: (value) {
                  if (value != null) {
                    setState(() => newPlantRecord.paidStatus = value);
                  }
                },

                // ใส่ปุ่ม Radio ต่างๆ ลงใน child
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('กำลังรักษา (Unpaid)'),
                      value: 'Unpaid',
                      // ไม่ต้องใส่ groupValue หรือ selectionValue แล้ว
                    ),
                    RadioListTile<String>(
                      title: const Text('รักษาแล้ว (Paid)'),
                      value: 'Paid',
                      // ไม่ต้องใส่ groupValue หรือ selectionValue แล้ว
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // บันทึกข้อมูลจากฟอร์มลงใน newPlantRecord
      processplantEntry(newPlantRecord); // เรียกฟังก์ชันเพื่อบันทึกข้อมูลลงฐานข้อมูล      
    }
  }

  Future<void> processplantEntry(dynamic plantRecord) async {
    if (widget.action == 'add') {
      try {
        await DatabaseHelper().addPlantRecord(plantRecord);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Plant record added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add plant record: $error'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else if (widget.action == 'edit') {
      try {
        await DatabaseHelper().updatePlantRecord(
          widget.plantRecord.referenceId!,
          plantRecord,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Plant record updated successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update plant record: $error'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<String> selectMonth() async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
    );
    if (selected != null) {
      return DateFormat('MMMM yyyy').format(selected);
    }
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }
}
