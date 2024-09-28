import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/provider/location_provider.dart';
import 'package:inventory_management/Custom-Files/custom-button.dart';
import 'package:inventory_management/Custom-Files/colors.dart';

class NewLocationForm extends StatefulWidget {
  const NewLocationForm({super.key});

  @override
  _NewLocationFormState createState() => _NewLocationFormState();
}

class _NewLocationFormState extends State<NewLocationForm> {
  final _formKey = GlobalKey<FormState>();

  final _warehouseNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _billingAddress1Controller = TextEditingController();
  final _billingAddress2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _shippingAddress1Controller = TextEditingController();
  final _shippingAddress2Controller = TextEditingController();
  final _shippingCityController = TextEditingController();
  final _shippingZipCodeController = TextEditingController();
  final _shippingPhoneNumberController = TextEditingController();

  final bool holdStock = true;
  final bool copyStock = true;

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Location',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                labelWithRequiredSymbol('Warehouse Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _warehouseNameController,
                  decoration: InputDecoration(
                    labelText: 'Warehouse Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter warehouse name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                labelWithRequiredSymbol('User Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _userEmailController,
                  decoration: InputDecoration(
                    labelText: 'User Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user email';
                    }
                    // Basic email validation using regex
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                labelWithRequiredSymbol('Enter Other Details'),
                const SizedBox(height: 8),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _taxIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tax Identification No.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tax identification number';
                    }
                    if (value.length != 11) {
                      return 'Tax identification number must be 11 digits';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 24),
                labelWithRequiredSymbol('Billing Address'),
                const SizedBox(height: 8),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _billingAddress1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter billing address line 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _billingAddress2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdown(
                  option: locationProvider.countries,
                  selectedIndex: locationProvider.selectedCountryIndex,
                  onSelectedChanged: (country) {
                    locationProvider.selectCountry(country);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'State',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdown(
                  option: locationProvider.states,
                  selectedIndex: locationProvider.selectedStateIndex,
                  onSelectedChanged: (state) {
                    locationProvider.selectState(state);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    labelText: 'ZIP Code/Postal Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ZIP/Postal code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: locationProvider.copyAddress,
                      onChanged: (bool? value) {
                        locationProvider.updateCopyAddress(value ?? false);

                        if (value == true) {
                          // Copy billing address to shipping address
                          locationProvider.updateShippingAddress(
                            address1: _billingAddress1Controller.text,
                            address2: _billingAddress2Controller.text,
                            city: _cityController.text,
                            zipCode: _zipCodeController.text,
                            phoneNumber: _phoneNumberController.text,
                          );
                        } else {
                          // Clear shipping address fields if unchecked
                          locationProvider.updateShippingAddress(
                            address1: '',
                            address2: '',
                            city: '',
                            zipCode: '',
                            phoneNumber: '',
                          );
                        }
                      },
                    ),
                    const Text(
                      'Copy Billing Address to Shipping Address',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                labelWithRequiredSymbol('Shipping Address'),
                const SizedBox(height: 8),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shippingAddress1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shipping address line 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shippingAddress2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdown(
                  option: locationProvider.countries,
                  selectedIndex: locationProvider.selectedCountryIndex,
                  onSelectedChanged: (country) {
                    locationProvider.selectCountry(country);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'State',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdown(
                    option: locationProvider.states,
                    selectedIndex: locationProvider.selectedStateIndex,
                    onSelectedChanged: (state) {
                      locationProvider.selectState(state);
                    }),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shippingCityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shipping city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shippingZipCodeController,
                  decoration: InputDecoration(
                    labelText: 'ZIP Code/Postal Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shipping ZIP/Postal code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _shippingPhoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shipping phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 3,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location Type',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdown(
                  option: locationProvider.locationTypes,
                  selectedIndex: locationProvider.selectedLocationTypeIndex,
                  onSelectedChanged: (locationType) {
                    locationProvider.selectLocationType(locationType);
                  },
                ),
                const SizedBox(height: 16),
                labelWithRequiredSymbol('Holds Stock'),
                Row(
                  children: [
                    const Text("Yes"),
                    Radio<String>(
                      value: "Yes",
                      groupValue: locationProvider.holdsStock == null
                          ? null
                          : locationProvider.holdsStock!
                              ? "Yes"
                              : "No",
                      onChanged: (String? value) {
                        locationProvider.updateHoldsStock(value);
                      },
                    ),
                    const Text("No"),
                    Radio<String>(
                      value: "No",
                      groupValue: locationProvider.holdsStock == null
                          ? null
                          : locationProvider.holdsStock!
                              ? "Yes"
                              : "No",
                      onChanged: (String? value) {
                        locationProvider.updateHoldsStock(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                labelWithRequiredSymbol('Copy Master SKU from Primary'),
                Row(
                  children: [
                    const Text("Yes"),
                    Radio<String>(
                      value: "Yes",
                      groupValue: locationProvider.copysku == null
                          ? null
                          : locationProvider.copysku!
                              ? "Yes"
                              : "No",
                      onChanged: (String? value) {
                        locationProvider.updateCopysku(value);
                      },
                    ),
                    const Text("No"),
                    Radio<String>(
                      value: "No",
                      groupValue: locationProvider.copysku == null
                          ? null
                          : locationProvider.copysku!
                              ? "Yes"
                              : "No",
                      onChanged: (String? value) {
                        locationProvider.updateCopysku(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 120,
                      height: 40,
                      onTap: () {
                        locationProvider.toggleCreatingNewLocation();
                      },
                      color: AppColors.grey,
                      textColor: AppColors.white,
                      fontSize: 14,
                      text: 'Cancel',
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      width: 140,
                      height: 40,
                      // Within the onTap method of the Save Location button:
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final location = {
                            'name': _warehouseNameController.text,
                            'email': _userEmailController.text,
                            'taxIdentificationNumber':
                                int.tryParse(_taxIdController.text) ?? 0,

                            // Billing address
                            'billingAddress': {
                              'addressLine1': _billingAddress1Controller.text,
                              'addressLine2': _billingAddress2Controller.text,
                              'country': locationProvider.selectedCountryIndex
                                      ?.toString() ??
                                  '',
                              'state': locationProvider.selectedStateIndex
                                      ?.toString() ??
                                  '',
                              'city': _cityController.text,
                              'zipCode':
                                  int.tryParse(_zipCodeController.text) ?? 0,
                              'phoneNumber':
                                  int.tryParse(_phoneNumberController.text) ??
                                      0,
                            },

                            // Shipping address
                            'shippingAddress': {
                              'addressLine1': _shippingAddress1Controller.text,
                              'addressLine2': _shippingAddress2Controller.text,
                              'country': locationProvider.selectedCountryIndex
                                      ?.toString() ??
                                  '',
                              'state': locationProvider.selectedStateIndex
                                      ?.toString() ??
                                  '',
                              'city': _shippingCityController.text,
                              'zipCode': int.tryParse(
                                      _shippingZipCodeController.text) ??
                                  0,
                              'phoneNumber': int.tryParse(
                                      _shippingPhoneNumberController.text) ??
                                  0,
                            },

                            // Other fields
                            'locationType': locationProvider
                                    .selectedLocationTypeIndex
                                    ?.toString() ??
                                '',
                            'holdStocks': locationProvider.holdsStock ?? false,
                            'copyMasterSkuFromPrimary':
                                locationProvider.copysku ?? false,
                          };

                          final success =
                              await locationProvider.createWarehouse(location);

                          final snackBar = success
                              ? const SnackBar(
                                  content:
                                      Text('Warehouse created successfully!'),
                                  backgroundColor: Colors.green,
                                )
                              : SnackBar(
                                  content: Text(
                                      'Failed to create warehouse: ${locationProvider.errorMessage}'),
                                  backgroundColor: Colors.red,
                                );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          // if (success) {
                          //   // Navigate back to the LocationMaster page
                          //   Navigator.of(context)
                          //       .pushReplacementNamed('/location-master');
                          // }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please fill in all required fields.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },

                      color: AppColors.primaryGreen,
                      textColor: AppColors.white,
                      fontSize: 14,
                      text: 'Save Location',
                      borderRadius: BorderRadius.circular(8),
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

  Widget labelWithRequiredSymbol(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
