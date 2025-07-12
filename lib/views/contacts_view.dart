import 'package:sos/commons.dart';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final EmergencyController _controller = EmergencyController();
  List<EmergencyContact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      List<EmergencyContact> contacts =
          await _controller.getEmergencyContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.contacts, size: 28),
            SizedBox(width: 8),
            Text(
              'Emergency Contacts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2C5F63),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2C5F63),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading contacts...',
                      style: TextStyle(color: Color(0xFF455A64), fontSize: 16),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Instructions
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      border: Border.all(color: Color(0xFF2C5F63), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Select contacts to notify during emergencies.\nChecked contacts will receive instant alerts.',
                      style: TextStyle(
                        color: Color(0xFF455A64),
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Contacts List
                  Expanded(
                    child:
                        _contacts.isEmpty
                            ? _buildEmptyState()
                            : _buildContactsList(),
                  ),
                ],
              ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2C5F63).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showAddContactDialog,
          backgroundColor: Color(0xFF2C5F63),
          foregroundColor: Colors.white,
          elevation: 0,
          icon: Icon(Icons.person_add),
          label: Text(
            'Add Contact',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF2C5F63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.contacts_outlined,
                size: 60,
                color: Color(0xFF2C5F63).withOpacity(0.6),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Emergency Contacts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5F63),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Add trusted contacts who will be notified\nduring medical emergencies.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF455A64),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        EmergencyContact contact = _contacts[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  contact.isSelected
                      ? Color(0xFF2C5F63).withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    contact.isSelected
                        ? Color(0xFF2C5F63).withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _toggleContactSelection(index),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              contact.isSelected
                                  ? [
                                    Color(0xFF2C5F63),
                                    Color(0xFF2C5F63).withOpacity(0.8),
                                  ]
                                  : [
                                    Colors.grey.shade400,
                                    Colors.grey.shade500,
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    SizedBox(width: 16),

                    // Contact Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDisplayName(contact.name),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C5F63),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '+961 ${contact.phoneNumber}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF455A64),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  contact.isSelected
                                      ? Color(0xFF2C5F63).withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              contact.isSelected
                                  ? 'Will be notified'
                                  : 'Tap to enable',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    contact.isSelected
                                        ? Color(0xFF2C5F63)
                                        : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Checkbox and Delete
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                contact.isSelected
                                    ? Color(0xFF2C5F63)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  contact.isSelected
                                      ? Color(0xFF2C5F63)
                                      : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            contact.isSelected ? Icons.check : null,
                            color: Colors.white,
                            size: 20,
                          ),
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(height: 8),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade400,
                            size: 24,
                          ),
                          onPressed: () => _deleteContact(contact),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // NEW METHOD: Toggle contact selection with instant UI update
  Future<void> _toggleContactSelection(int index) async {
    final contact = _contacts[index];
    final newSelectionState = !contact.isSelected;

    // Update UI immediately
    setState(() {
      _contacts[index] = EmergencyContact(
        id: contact.id,
        name: contact.name,
        phoneNumber: contact.phoneNumber,
        isSelected: newSelectionState,
      );
    });

    // Update database in background
    try {
      await _controller.updateContactSelection(contact.id, newSelectionState);
    } catch (e) {
      // If database update fails, revert the UI change
      setState(() {
        _contacts[index] = contact; // Revert to original state
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update contact selection'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  String _formatDisplayName(String name) {
    return name
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }

  void _showAddContactDialog() {
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isSaving = false;
    final scaffoldContext = context;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.person_add, color: Color(0xFF2C5F63)),
                  SizedBox(width: 8),
                  Text(
                    'Add Contact',
                    style: TextStyle(
                      color: Color(0xFF2C5F63),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Contact Name',
                        hintText: 'Enter full name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF2C5F63),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF2C5F63),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a contact name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '70 123 456 (8 digits only)',
                        helperText:
                            'Enter 8-digit Lebanese number without +961',
                        helperStyle: TextStyle(color: Color(0xFF2C5F63)),
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF2C5F63)),
                        prefixText: '+961 ',
                        prefixStyle: TextStyle(
                          color: Color(0xFF2C5F63),
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF2C5F63),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a phone number';
                        }
                        String cleanNumber = value.replaceAll(' ', '');
                        if (cleanNumber.length != 8) {
                          return 'Lebanese numbers must be exactly 8 digits';
                        }
                        if (!RegExp(r'^[0-9]{8}$').hasMatch(cleanNumber)) {
                          return 'Please enter numbers only';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                if (!_isSaving)
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: Text('Cancel'),
                  ),
                ElevatedButton(
                  onPressed:
                      _isSaving
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setStateDialog(() => _isSaving = true);
                              try {
                                String displayName =
                                    _nameController.text.trim();
                                String storageName = displayName.toLowerCase();

                                EmergencyContact newContact = EmergencyContact(
                                  id:
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString(),
                                  name: storageName,
                                  phoneNumber: _phoneController.text.trim(),
                                  isSelected: true,
                                );

                                Navigator.of(
                                  dialogContext,
                                  rootNavigator: true,
                                ).pop();

                                await _controller.saveEmergencyContact(
                                  newContact,
                                );

                                _loadContacts();

                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text('Contact added successfully'),
                                    backgroundColor: Color(0xFF2C5F63),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                setStateDialog(() => _isSaving = false);
                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to add contact: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C5F63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Add Contact'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteContact(EmergencyContact contact) {
    bool _isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete Contact',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to delete ${_formatDisplayName(contact.name)}?\n\nThis action cannot be undone.',
                style: TextStyle(height: 1.4),
              ),
              actions: [
                if (!_isDeleting)
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: Text('Cancel'),
                  ),
                ElevatedButton(
                  onPressed:
                      _isDeleting
                          ? null
                          : () async {
                            setStateDialog(() => _isDeleting = true);
                            try {
                              await _controller.deleteEmergencyContact(
                                contact.id,
                              );

                              Navigator.pop(dialogContext);

                              setState(() {
                                _contacts.removeWhere(
                                  (c) => c.id == contact.id,
                                );
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Contact deleted successfully'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            } catch (e) {
                              setStateDialog(() => _isDeleting = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to delete contact: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
