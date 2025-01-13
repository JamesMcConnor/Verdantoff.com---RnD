import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

class EditFieldScreen extends StatefulWidget {
  final String fieldName;
  final String currentValue;

  EditFieldScreen({required this.fieldName, required this.currentValue});

  @override
  _EditFieldScreenState createState() => _EditFieldScreenState();
}

class _EditFieldScreenState extends State<EditFieldScreen> {
  final TextEditingController _fieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fieldController.text = widget.currentValue;
  }

  Future<void> _saveField() async {
    final newValue = _fieldController.text.trim();
    if (newValue.isNotEmpty) {
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({widget.fieldName: newValue});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.fieldName} updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update ${widget.fieldName}')),
        );
      }
    }
  }

  void _selectBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _fieldController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _fieldController.text = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fieldName}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.fieldName == 'birthday')
              TextField(
                controller: _fieldController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Birthday',
                  border: OutlineInputBorder(),
                ),
                onTap: _selectBirthday,
              )
            else if (widget.fieldName == 'country')
              TextField(
                controller: _fieldController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Country',
                  border: OutlineInputBorder(),
                ),
                onTap: _selectCountry,
              )
            else if (widget.fieldName == 'industry')
                DropdownButtonFormField<String>(
                  value: _fieldController.text.isNotEmpty ? _fieldController.text : null,
                  items: [
                    'Technology',
                    'Healthcare',
                    'Education',
                    'Finance',
                    'Retail',
                    'Manufacturing',
                    'Other',
                  ].map((industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _fieldController.text = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Industry',
                    border: OutlineInputBorder(),
                  ),
                )
              else
                TextField(
                  controller: _fieldController,
                  decoration: InputDecoration(
                    labelText: 'Enter new ${widget.fieldName}',
                    border: OutlineInputBorder(),
                  ),
                ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveField,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
