import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:provider/provider.dart';

class RedeemBookCouponPage extends StatefulWidget {
  final Books book;

  const RedeemBookCouponPage({super.key, required this.book});

  @override
  State<RedeemBookCouponPage> createState() => _RedeemBookCouponPageState();
}

class _RedeemBookCouponPageState extends State<RedeemBookCouponPage> {
  final TextEditingController _couponController = TextEditingController();
  bool _loading = false;

  Future<void> _redeem() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter a coupon code")));
      return;
    }

    setState(() => _loading = true);

    try {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      final email = userdata?.email ?? "";

      final response = await Dio().post(
        ApiUrl.REDEEM_BOOK_COUPON,
        data: json.encode({
          "data": {
            "email": email,
            "book_id": widget.book.id.toString(),
            "code": code,
          }
        }),
      );

      // 👇 FIXED HERE
      final raw = response.data;
      final data = raw is String ? jsonDecode(raw) : raw;

      if (data["status"] == "ok") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data["msg"])));
        await Provider.of<AppStateManager>(context, listen: false)
            .getUserpurchases();

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data["msg"] ?? "Failed")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Network error")));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Books book = widget.book;

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 112, 111, 111),
      appBar: AppBar(
        title: const Text("Redeem Coupon"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// BOOK IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.coverphoto ?? "",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: const Color.fromARGB(255, 206, 204, 204),
                  child: const Icon(Icons.menu_book, size: 50),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// TITLE
            Text(
              book.title ?? "",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'style2'),
            ),

            const SizedBox(height: 10),

            /// DESCRIPTION
            Text(
              book.description ?? "",
              maxLines: 3,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),

            const SizedBox(height: 30),

            const Text(
              "Enter Coupon Code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            /// INPUT FIELD
            TextField(
              controller: _couponController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
                hintText: "Example: AB123XYZ",
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _redeem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 242, 241, 241),
                      )
                    : Text(
                        "Redeem",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 243, 243, 243),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'style2',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
