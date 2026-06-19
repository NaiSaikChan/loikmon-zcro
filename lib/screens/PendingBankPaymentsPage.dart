import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/providers/DashboardModel.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:provider/provider.dart';

class PendingBankPaymentsPage extends StatefulWidget {
  static const routeName = "/pendingBankPayments";

  const PendingBankPaymentsPage({Key? key}) : super(key: key);

  @override
  State<PendingBankPaymentsPage> createState() =>
      _PendingBankPaymentsPageState();
}

class _PendingBankPaymentsPageState extends State<PendingBankPaymentsPage> {
  bool loading = true;
  bool error = false;
  List payments = [];

  int? approvingId;
  int? deletingId;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  // ------------------------------------------------------------
  // CONFIRMATION DIALOG
  // ------------------------------------------------------------
  Future<bool> confirmDialog(
      {required String title, required String message}) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(ctx, false),
              ),
              ElevatedButton(
                child: Text("Proceed"),
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ------------------------------------------------------------
  // LOAD PENDING PAYMENTS
  // ------------------------------------------------------------
  Future<void> loadPayments() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      final response = await Dio().get(ApiUrl.pendingBankPaymentsApp);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.data);
        payments = List.from(res['payments']);
        Provider.of<DashboardModel>(context, listen: false)
            .setPendingBankRequests(payments.length);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          error = true;
          loading = false;
        });
      }
    } catch (e) {
      print("Error loading payments: $e");
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  // ------------------------------------------------------------
  // APPROVE PAYMENT
  // ------------------------------------------------------------
  Future<void> approvePayment(int id) async {
    final confirm = await confirmDialog(
      title: "Approve Payment",
      message: "Are you sure you want to approve this payment?",
    );

    if (!confirm) return;

    setState(() => approvingId = id);

    try {
      final response = await Dio().post(
        ApiUrl.approveBankPaymentsApp,
        data: jsonEncode({
          "data": {
            "id": id,
            "action": 1,
          }
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment approved successfully")),
      );
      await loadPayments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to approve payment")),
      );
    }

    setState(() => approvingId = null);
  }

  // ------------------------------------------------------------
  // DELETE PAYMENT
  // ------------------------------------------------------------
  Future<void> deletePayment(int id) async {
    final confirm = await confirmDialog(
      title: "Delete Payment",
      message: "Are you sure you want to delete this payment?",
    );

    if (!confirm) return;

    setState(() => deletingId = id);

    try {
      final response = await Dio().post(
        ApiUrl.deleteBankPaymentsApp,
        data: jsonEncode({
          "data": {
            "id": id,
          }
        }),
      );
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment deleted successfully")),
      );
      await loadPayments();
    } catch (e) {
      if (e is DioException) {
        print(e.error);
        print(e.message);
        print(e.response);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete payment")),
      );
    }

    setState(() => deletingId = null);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Bank Payments"),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Failed to load payment records"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: loadPayments,
                        child: Text("Retry"),
                      )
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 100, right: 100),
                  child: RefreshIndicator(
                    onRefresh: loadPayments,
                    color: Colors.blue,
                    child: payments.isEmpty
                        ? ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 220),
                              Center(child: Text("No pending bank payments")),
                            ],
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: payments.length,
                            itemBuilder: (ctx, index) {
                              final item = payments[index];

                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.only(bottom: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // IMAGE
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: GestureDetector(
                                          onTap: () =>
                                              showFullImage(item["thumbnail"]),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              item["thumbnail"],
                                              height: 250,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                height: 180,
                                                color: Colors.grey.shade300,
                                                child:
                                                    Icon(Icons.image, size: 80),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 12),

                                      // USER DETAILS
                                      Text(
                                        "Email: ${item['email']}",
                                        style: TextStyles.display1(context)
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text("Coins ID: ${item['coinsid']}"),
                                      Text("Value: ${item['value']}"),
                                      Text("Amount: ${item['amount']}"),
                                      Text("Date: ${item['date']}"),

                                      SizedBox(height: 10),

                                      // ACTION BUTTONS
                                      Row(
                                        children: [
                                          // APPROVE BUTTON
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              onPressed:
                                                  approvingId == item["id"]
                                                      ? null
                                                      : () => approvePayment(
                                                          int.parse(item["id"]
                                                              .toString())),
                                              child: approvingId == item["id"]
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.check),
                                                        SizedBox(
                                                          width: 5,
                                                          height: 30,
                                                        ),
                                                        Text("Approve"),
                                                      ],
                                                    ),
                                            ),
                                          ),

                                          SizedBox(width: 10),

                                          // DELETE BUTTON
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed:
                                                  deletingId == item["id"]
                                                      ? null
                                                      : () => deletePayment(
                                                          int.parse(item["id"]
                                                              .toString())),
                                              child: deletingId == item["id"]
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.delete),
                                                        SizedBox(width: 5),
                                                        Text("Delete"),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
    );
  }

  void showFullImage(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // tap to close
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              children: [
                InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white, size: 80),
                        ),
                      ),
                    ),
                  ),
                ),

                // ❌ close button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
