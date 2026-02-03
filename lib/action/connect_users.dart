import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mono_flutter/models/mono_customer.dart';
import 'package:mono_flutter/mono_web_view.dart';

import 'package:intl/intl.dart';

import '../widgets/adaptiveForms.dart';

class MonoConnectWidget extends StatefulWidget {
  const MonoConnectWidget({super.key});

  @override
  State<MonoConnectWidget> createState() => _MonoConnectWidgetState();
}

class _MonoConnectWidgetState extends State<MonoConnectWidget> {
  String? acctId = '';
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bvnController = TextEditingController();

  bool obscurePass = true;
  bool obscureConfirm = true;

  DateTime? _startDate;
  DateTime? _endDate;

  bool _loading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bvnController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _openMonoConnect({
      required BuildContext context,
      required String fullName,
      required String email,
      required String bvn,
    }) {
      showDialog(
        context: context,
        builder: (c) => MonoWebView(
          apiKey: 'test_pk_b1nqy9l7bmh4sfshp0jy',
          scope: "auth",
          customer: MonoCustomer(
            newCustomer: MonoNewCustomerModel(
              name: fullName,
              email: email,
              identity: MonoNewCustomerIdentity(type: "bvn", number: bvn),
            ),
            // existingCustomer: MonoExistingCustomerModel(
            //   id: "6759f68cb587236111eac1d4",
            // ),
          ),
          // selectedInstitution: ConnectInstitution(
          //   id: "5f2d08be60b92e2888287702",
          //   authMethod: ConnectAuthMethod.mobileBanking,
          // ),
          onEvent: (event, data) {
            print('event: $event, data: $data');
          },
          onClosed: (data) {
            print('Modal closed');
            Navigator.pop(context); // Close the dialog
          },
          onLoad: () {
            print('Mono loaded successfully');
          },
          onSuccess: (code) {
            print('Mono Success everything concluded suceessfulllyyyyy $code');
            setState(() {});
            // Handle the success code here (e.g., send to your backend)
            Navigator.pop(context);
          },
        ),
      );
    }

    final isIOS = Platform.isIOS;

    return Scaffold(
      appBar: AppBar(title: const Text('Filter & Query')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // TextFormField(
              //   controller: _fullNameController,
              //   decoration: const InputDecoration(labelText: 'Full Name'),
              //   validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              // ),
              CustomTextField(
                isIOS: isIOS,
                controller: _fullNameController,
                label: 'Full Name',
                placeholder: "John Doe",
                // validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              // TextFormField(
              //   controller: _emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (v) {
              //     if (v == null || v.isEmpty) return 'Required';
              //     if (!v.contains('@')) return 'Invalid email';
              //     return null;
              //   },
              // ),
              CustomTextField(
                isIOS: isIOS,
                controller: _emailController,
                label: 'Email',
                placeholder: "JohnDoe@gmail.com",
                keyboardType: TextInputType.emailAddress,
                // validator: (v) {
                //   if (v == null || v.isEmpty) return 'Required';
                //   if (!v.contains('@')) return 'Invalid email';
                //   return null;
                // },
              ),

              const SizedBox(height: 12),

              CustomTextField(
                isIOS: isIOS,
                controller: _bvnController,
                label: "BVN (Bank Verification Number)",
                placeholder: "••••••••",
                obscure: obscurePass,
                onToggleVisibility: () =>
                    setState(() => obscurePass = !obscurePass),
                maxLength: 11,
                // validator: (v) {
                //   if (v == null || v.isEmpty) return 'Required';
                //   if (v.length != 11) return 'BVN must be 11 digits';
                //   return null;
                // },
              ),

              // TextFormField(
              //   controller: _bvnController,
              //   decoration: const InputDecoration(
              //     labelText: 'BVN (Bank Verification Number)',
              //   ),
              //   keyboardType: TextInputType.number,
              //   maxLength: 11,
              //   validator: (v) {
              //     if (v == null || v.isEmpty) return 'Required';
              //     if (v.length != 11) return 'BVN must be 11 digits';
              //     return null;
              //   },
              // ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: Colors.blue,
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        _startDate == null
                            ? 'Select Start Date'
                            : 'Start: ${DateFormat.yMMMd().format(_startDate!)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoButton(
                      color: Colors.blue,
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(
                        _endDate == null
                            ? 'Select End Date'
                            : 'End: ${DateFormat.yMMMd().format(_endDate!)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  if (_startDate == null || _endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select start and end dates'),
                      ),
                    );
                    return;
                  }

                  setState(() => _loading = true);

                  final payload = {
                    "full_name": _fullNameController.text.trim(),
                    "email": _emailController.text.trim(),
                    "bvn": _bvnController.text.trim(),
                    "start_date": DateFormat('yyyy-MM-dd').format(_startDate!),
                    "end_date": DateFormat('yyyy-MM-dd').format(_endDate!),
                  };
                  _openMonoConnect(
                    context: context,
                    fullName: payload['full_name'] ?? '',
                    email: payload['email'] ?? '',
                    bvn: payload['bvn'] ?? '',
                  );
                },
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAccountBalance() async {
    // Replace 'id' with your actual account ID
    const String accountId = '697e7f8f08164867f4e4aec0';
    final url = Uri.parse(
      'https://api.withmono.com/v2/accounts/$accountId/balance',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'mono-sec-key':
              'test_sk_noevtgv5lkd652b3bh1j', // Replace 'string' with your actual key
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = jsonDecode(response.body);
        print('Balance Data: $data');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Error body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

//flutter: MonoClientInterface, {type: mono.connect.institution_selected, data: {timestamp: 1769897877670, reference: , authMethod: internet_banking, institution: {id: 5f2d08bf60b92e2888287703, name: Access Bank}}}
