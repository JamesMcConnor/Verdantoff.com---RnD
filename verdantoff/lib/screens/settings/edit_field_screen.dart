import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

/// `EditFieldScreen` allows the user to edit a specific field in their profile.
///
/// Supported Fields:
/// - Standard text input fields (e.g., username, email, role)
/// - Date picker for `birthday`
/// - Country picker for `country`
/// - Dropdown selection for `industry`
class EditFieldScreen extends StatefulWidget {
  final String fieldName; // Name of the field being edited
  final String currentValue; // The current value of the field

  EditFieldScreen({required this.fieldName, required this.currentValue});

  @override
  _EditFieldScreenState createState() => _EditFieldScreenState();
}

class _EditFieldScreenState extends State<EditFieldScreen> {
  final TextEditingController _fieldController = TextEditingController(); // Controller for text input

  @override
  void initState() {
    super.initState();
    _fieldController.text = widget.currentValue; // Pre-fill with the current field value
  }

  /// Saves the updated field value to Firestore.
  /// - Prevents saving empty values.
  /// - Updates the authenticated user's profile.
  Future<void> _saveField() async {
    final newValue = _fieldController.text.trim(); // Trim whitespace from input

    if (newValue.isNotEmpty) {
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          // Update Firestore with the new field value
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({widget.fieldName: newValue});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.fieldName} updated successfully!')),
          );

          Navigator.pop(context, true); // Return `true` to indicate successful update
        }
      } catch (e) {
        // Show error message if Firestore update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update ${widget.fieldName}')),
        );
      }
    }
  }

  /// Opens a date picker for selecting a birthday.
  /// - Formats the date as `yyyy-MM-dd` before updating the input field.
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

  /// Opens a country picker dialog and updates the input field with the selected country name.
  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // Hide phone code selection
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
            // Different input types based on the field name
            if (widget.fieldName == 'birthday')
              _buildDatePickerField()
            else if (widget.fieldName == 'country')
              _buildCountryPickerField()
            else if (widget.fieldName == 'industry')
                _buildIndustryDropdown()
              else
                _buildTextInputField(),

            SizedBox(height: 16),

            // Save Button
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

  /// Builds a **date picker field** for `birthday`.
  Widget _buildDatePickerField() {
    return TextField(
      controller: _fieldController,
      readOnly: true, // Prevent manual input
      decoration: InputDecoration(
        labelText: 'Select Birthday',
        border: OutlineInputBorder(),
      ),
      onTap: _selectBirthday, // Open date picker on tap
    );
  }

  /// Builds a **country picker field** for `country`.
  Widget _buildCountryPickerField() {
    return TextField(
      controller: _fieldController,
      readOnly: true, // Prevent manual input
      decoration: InputDecoration(
        labelText: 'Select Country',
        border: OutlineInputBorder(),
      ),
      onTap: _selectCountry, // Open country picker on tap
    );
  }

  /// Builds a **dropdown menu** for selecting `industry`.
  Widget _buildIndustryDropdown() {
    return DropdownButtonFormField<String>(
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
    );
  }

  /// Builds a **standard text input field** for general fields.
  Widget _buildTextInputField() {
    return TextField(
      controller: _fieldController,
      decoration: InputDecoration(
        labelText: 'Enter new ${widget.fieldName}',
        border: OutlineInputBorder(),
      ),
    );
  }
}
