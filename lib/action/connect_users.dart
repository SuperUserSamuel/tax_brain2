
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mono_flutter/models/mono_customer.dart';
import 'package:mono_flutter/mono_web_view.dart';

//import 'package:mono_connect/mono_connect.dart';



class MonoConnectWidget extends StatelessWidget {
  const MonoConnectWidget({super.key});


  @override
  Widget build(BuildContext context) {

    // final config = ConnectConfiguration(
    //   publicKey: 'test_pk_b1nqy9l7bmh4sfshp0jy',
    //   onSuccess: (code) {
    //     log('Success with code: $code');
    //   },
    //   customer: const MonoCustomer(
    //     newCustomer: MonoNewCustomer(
    //       name: 'Samuel Airadion',
    //       email: 'samuelairadion01@gmail.com',
    //       identity: MonoCustomerIdentity(
    //         type: 'bvn',
    //         number: '22399978256',
    //       ),
    //     ),
    //     // or
    //     // existingCustomer: MonoExistingCustomer(
    //     //   id: '6759f68cb587236111eac1d4',
    //     // ),
    //   ),
    //   // selectedInstitution: const ConnectInstitution(
    //   //   id: '5f2d08be60b92e2888287702',
    //   //   authMethod: ConnectAuthMethod.mobileBanking,
    //   // ),
    //   reference: 'testref',
    //   onEvent: (event) {
    //     log(event.toString());
    //   },
    //   onClose: () {
    //     log('Widget closed.');
    //   },
    // );


    void _openMonoConnect(BuildContext context) {
      showDialog(
        context: context,
        builder: (c) => MonoWebView(
        apiKey: 'test_pk_b1nqy9l7bmh4sfshp0jy',
          scope: "auth",
          customer: MonoCustomer(
            newCustomer: MonoNewCustomerModel(
              name: 'Samuel Airadion',
              email: 'samuelairadion01@gmail.com',
              identity: MonoNewCustomerIdentity(
                type: "bvn",
                number: '22399978256',
              ),
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
            Navigator.of(c).pop(); // Close the dialog
          },
          onLoad: () {
            print('Mono loaded successfully');
          },
          onSuccess: (code) {
            print('Mono Success $code');
            // Handle the success code here (e.g., send to your backend)
            Navigator.of(c).pop();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mono Connect Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // MonoConnect.launch(
              //   context,
              //   config: config,
              //   showLogs: true,
              // );

              _openMonoConnect(context);
            },
            child: const Text('Link Bank Account'),
          ),



          ElevatedButton(
            onPressed: ()async  {
            await getAccountBalance();
            },
            child: const Text('see balance'),
          ),
        ],
      ),
    );
  }

  Future<void> getAccountBalance() async {
    // Replace 'id' with your actual account ID
    const String accountId = '697547b2260596ade38f26ce';
    final url = Uri.parse('https://api.withmono.com/v2/accounts/$accountId/balance');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'mono-sec-key': 'test_sk_noevtgv5lkd652b3bh1j', // Replace 'string' with your actual key
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