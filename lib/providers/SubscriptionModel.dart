import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:loikmon/database/SQLiteDbProvider.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Books.dart';
import 'package:loikmon/models/UserEvents.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/events.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/Strings.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class SubscriptionModel with ChangeNotifier {
  final InAppPurchase? inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  List<String> _consumables = [];
  bool isAvailable = false;
  bool _purchasePending = false;
  bool loading = true;
  String? _queryProductError;
  BuildContext? context;
  Books? books;

  SubscriptionModel() {
    print("initialize purchases");
    //initInAppPurchases();
  }

  setBook(Books books) {
    this.books = books;
    notifyListeners();
  }

  //inapp purchases
  initInAppPurchases(BuildContext context) {
    print("initialize purchases222");
    this.context = context;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          inAppPurchase!.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription!.cancel();
      }, onError: (error) {
        // handle error here.
        print("inapp purchases error");
        print(error);
      });
      initStoreInfo();
    }
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await inAppPurchase!.isAvailable();
    if (!isAvailable) {
      this.isAvailable = isAvailable;
      products = [];
      purchases = [];
      notFoundIds = [];
      _consumables = [];
      _purchasePending = false;
      loading = false;
      notifyListeners();
    }

    ProductDetailsResponse productDetailResponse =
        await inAppPurchase!.queryProductDetails(Strings.productIds.toSet());
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      print(_queryProductError);
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = [];
      _purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      print("products is empty");
      _queryProductError = null;
      this.isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = [];
      notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = [];
      _purchasePending = false;
      loading = false;
      notifyListeners();
      return;
    }

    this.isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    print(products.toString());
    notFoundIds = productDetailResponse.notFoundIDs;
    _purchasePending = false;
    loading = false;
    notifyListeners();
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails != null) {
      Userdata? userdata = await SQLiteDbProvider.db.getUserData();
      print(purchaseDetails.productID);
      String? token = purchaseDetails.purchaseID;
      ProductDetails productDetails =
          getProductFromPurchaseDetails(purchaseDetails.productID);
      print(productDetails.rawPrice);
      double price = productDetails.rawPrice;

      var data = {
        "productid": productDetails.id,
        "amount": price.toString(),
        "reference": token,
        "email": userdata!.email,
        "bookid": books!.id,
      };
      sendPaymentToServer(data);
    }
  }

  void handleError(IAPError error) {
    _purchasePending = false;
    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //Do Nothings
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        //consume purchase
        final InAppPurchaseAndroidPlatformAddition androidAddition =
            inAppPurchase!
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchaseDetails);
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase!.completePurchase(purchaseDetails);
        }
      }
    });
  }

  getProductAmount(Books? books) {
    if (products.length == 0) return null;
    return products.firstWhereOrNull((itm) => (itm.id == books!.product));
  }

  getProductFromPurchaseDetails(String id) {
    if (products.length == 0) return null;
    return products.firstWhereOrNull((itm) => (itm.id == id));
  }

  Future<void> sendPaymentToServer(var data) async {
    Userdata? userdata = await SQLiteDbProvider.db.getUserData();
    if (userdata == null) {
      Alerts.subscriptionloginrequiredhint(context!);
      return;
    }

    Alerts.showProgressDialog(context!, t.processingpleasewait);

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.PURCHASEMEDIA),
        body: jsonEncode({"data": data}),
      );
      Navigator.of(context!).pop();
      final res = jsonDecode(response.body);
      if (res['status'] == "ok") {
        eventBus.fire(OnCoinsPurchase());
        Alerts.show(context, "", t.bookpurchasesuccess);
      } else {
        Alerts.show(context, "", t.bookpurchaseerror);
      }
    } catch (exception) {
      print(exception.toString());
      // I get no exception here
      Navigator.of(context!).pop();
    }
  }
}
