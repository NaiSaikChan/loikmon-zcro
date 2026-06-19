# LOIKMON API ENDPOINTS SUMMARY

## Overview
- **Base URL**: `https://loikmon.org/webapis/`
- **HTTP Library**: `http` package (Dart)
- **Request Format**: JSON wrapped in `{"data": {...}}`
- **Response Format**: JSON with status codes
- **Status Code**: 200 = Success
- **Total Endpoints Documented**: 30+

---

## AUTHENTICATION & ACCOUNT ENDPOINTS

### 1. LOGIN_APP
- **Endpoint**: `loginapp`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "password": "password_hash"
    }
  }
  ```
- **Response**: `{ "status": "ok/error", "message": "...", "user": {...}, "isadminuser": 0 }`
- **Used in**: [AuthPage.dart](lib/screens/AuthPage.dart#L57)
- **Notes**: Also accepts social auth with `type`, `name`, `username`, `phone`

### 2. CREATE_ACCOUNT
- **Endpoint**: `createaccount`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "password": "password_hash",
      "name": "User Name"
    }
  }
  ```
- **Response**: `{ "status": "ok/error", "user": {...} }`
- **Used in**: [AuthPage.dart](lib/screens/AuthPage.dart#L180)

### 3. RESET_PASSWORD
- **Endpoint**: `resetpassword`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [AuthPage.dart](lib/screens/AuthPage.dart#L208)

### 4. RESEND_VERIFY_LINK
- **Endpoint**: `resendVerificationMail`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [AuthPage.dart](lib/screens/AuthPage.dart#L92)

### 5. DELETE_ACCOUNT
- **Endpoint**: `deletemyaccount`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [SettingsPage.dart](lib/screens/SettingsPage.dart#L103)

---

## CONTENT RETRIEVAL ENDPOINTS

### 6. FETCH_BOOKS
- **Endpoint**: `fetchbooks`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "id": "author_id",
      "type": "book_type",
      "page": "0",
      "cat": "category_id",
      "sub": "subcategory_id"
    }
  }
  ```
- **Response**: `{ "books": [...], "subcategories": [...] }`
- **Used in**: [EbooksListModel.dart](lib/providers/EbooksListModel.dart#L96), [BookScreensModel.dart](lib/providers/BookScreensModel.dart#L54)
- **Pagination**: Uses `page` parameter (0-indexed)

### 7. FETCH_ARTICLES
- **Endpoint**: `fetcharticles`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "id": "author_id",
      "type": "article_type",
      "page": "0",
      "cat": "category_id"
    }
  }
  ```
- **Used in**: [ArticlesModel.dart](lib/providers/ArticlesModel.dart#L107), [ArticlesListModel.dart](lib/providers/ArticlesListModel.dart#L92)

### 8. GET_BOOK_CHAPTERS
- **Endpoint**: `getBookChapters`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "bookid": "book_id"
    }
  }
  ```
- **Response**: Array of chapter objects with audio/content URLs
- **Used in**: [EbooksViewerScreen.dart](lib/screens/EbooksViewerScreen.dart#L81), [AppPdfViewer.dart](lib/screens/AppPdfViewer.dart#L46)

### 9. FETCH_CATEGORIES
- **Endpoint**: `fetchcategories`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {}
  }
  ```
- **Response**: `{ "categories": [...] }`
- **Used in**: [CategoriesModel.dart](lib/providers/CategoriesModel.dart#L57), [ArticlesModel.dart](lib/providers/ArticlesModel.dart#L152)

### 10. FETCH_AUTHOR_CATEGORIES
- **Endpoint**: `fetchauthorcategories`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author": "author_id",
      "type": "book",
      "page": 0
    }
  }
  ```
- **Response**: `{ "categories": [...] }`
- **Used in**: [EbooksListModel.dart](lib/providers/EbooksListModel.dart#L187)

### 11. FETCH_AUTHORS
- **Endpoint**: `fetchauthors`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0"
    }
  }
  ```
- **Used in**: [AuthorsModel.dart](lib/providers/AuthorsModel.dart#L80)

### 12. GET_AUTHOR_DATA
- **Endpoint**: `get_author_data`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author_id": "123"
    }
  }
  ```
- **Used in**: [AuthorsListScreen.dart](lib/screens/AuthorsListScreen.dart#L55)

### 13. FETCH_LEAGUES
- **Endpoint**: `fetchleagues`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {}
  }
  ```
- **Response**: `{ "leagues": [...] }`
- **Used in**: [LeaguesModel.dart](lib/providers/LeaguesModel.dart#L65)

### 14. FETCH_OTHER_BOOKS
- **Endpoint**: `fetchotherbooks`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "page": "0"
    }
  }
  ```
- **Used in**: [OtherbooksModel.dart](lib/providers/OtherbooksModel.dart#L87)

### 15. SEARCH
- **Endpoint**: `search`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "offset": 0,
      "type": 0,
      "query": "search_term"
    }
  }
  ```
- **Response**: `{ "books": [...] }` or `{ "articles": [...] }`
- **Used in**: [SearchModel.dart](lib/providers/SearchModel.dart#L58)
- **Notes**: Type 0 = books, Type 1 = articles

---

## PURCHASE & PAYMENT ENDPOINTS

### 16. PURCHASEBOOK
- **Endpoint**: `purchasebook`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "bookid": "book_id",
      "amount": 100
    }
  }
  ```
- **Response**: `{ "status": "ok/error", "message": "..." }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L457)

### 17. PURCHASEARTICLE
- **Endpoint**: `purchasearticle`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "articleid": "article_id",
      "amount": 50
    }
  }
  ```
- **Response**: `{ "status": "ok/error", "message": "..." }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L493)

### 18. PURCHASEMEDIA
- **Endpoint**: `purchase_media`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "book": "media_id",
      "amount": 75
    }
  }
  ```
- **Response**: `{ "status": "ok/error" }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L287), [SubscriptionModel.dart](lib/providers/SubscriptionModel.dart#L201)

### 19. REDEEM_BOOK_COUPON
- **Endpoint**: `subscribeBookCoupon`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "code": "COUPON_CODE",
      "book_id": "book_id"
    }
  }
  ```
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L614)

### 20. PROOFOFPAYMENT (File Upload)
- **Endpoint**: `proofofpayment`
- **HTTP Method**: POST (Multipart)
- **Request Type**: `http.MultipartRequest`
- **Fields**: File attachment for payment proof
- **Used in**: [BuyBook.dart](lib/pages/BuyBook.dart#L634)
- **Notes**: Upload proof of bank transfer

---

## REVIEW & COMMENT ENDPOINTS

### 21. SUBMITREVIEW
- **Endpoint**: `submitreview`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "content": "base64_encoded_review_text",
      "email": "user@example.com",
      "itmid": "item_id",
      "type": "book_or_article",
      "rating": 4.5
    }
  }
  ```
- **Response**: `{ "review": {...} }`
- **Used in**: [CommentsModel.dart](lib/providers/CommentsModel.dart#L119)

### 22. LOADRECENTREVIEWS
- **Endpoint**: `loadrecentreviews`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "id": 0,
      "itmid": "item_id",
      "type": "book_or_article",
      "email": "user@example.com"
    }
  }
  ```
- **Response**: `{ "userreview": 0, "reviews": [...] }`
- **Used in**: [CommentsModel.dart](lib/providers/CommentsModel.dart#L73)

### 23. LOADREVIEWS
- **Endpoint**: `loadreviews`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "type": "book_or_article",
      "itmid": "item_id"
    }
  }
  ```
- **Response**: `{ "reviews": [...] }`
- **Used in**: [CommentsModel.dart](lib/providers/CommentsModel.dart#L303)
- **Pagination**: Uses `page` parameter

### 24. EDITREVIEW
- **Endpoint**: `editreview`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "id": "review_id",
      "content": "base64_encoded_new_content",
      "rating": 4.0
    }
  }
  ```
- **Response**: `{ "status": "ok/error" }`
- **Used in**: [CommentsModel.dart](lib/providers/CommentsModel.dart#L236)

### 25. DELETEREVIEW
- **Endpoint**: `deletereview`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "id": "review_id"
    }
  }
  ```
- **Used in**: [CommentsModel.dart](lib/providers/CommentsModel.dart#L188)

---

## USER DATA & COINS ENDPOINTS

### 26. FETCH_USER_PURCHASES
- **Endpoint**: `fetchuserpurchases`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Response**: `{ "books": ["1", "2", ...], "articles": ["3", "4", ...] }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L247), [PurchasesModel.dart](lib/providers/PurchasesModel.dart#L61)

### 27. FETCH_USER_PURCHASED_BOOKS
- **Endpoint**: `fetchuserpurchasedbooks`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [PurchasesMediaScreensModel.dart](lib/providers/PurchasesMediaScreensModel.dart#L57)

### 28. FETCH_USER_PURCHASED_ARTICLES
- **Endpoint**: `fetchuserpurchasedarticles`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [PurchasesArticleModel.dart](lib/providers/PurchasesArticleModel.dart#L56)

### 29. GETUSERCOINS
- **Endpoint**: `getusercoins`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Response**: `{ "coins": "150" }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L416)

### 30. GET_COINS
- **Endpoint**: `fetchcoins`
- **HTTP Method**: GET
- **Parameters**: None
- **Response**: `{ "coins": [...] }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L380)

---

## ADDITIONAL ENDPOINTS

### 31. DISCOVER/OVERVIEW
- **Endpoint**: `initapp` (DISCOVER), `overview` (OVERVIEW)
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "lastseeninbox": 0
    }
  }
  ```
- **Response**: Complex object with `sliders`, `categories`, `books`, `articles`, `authors`, `leagues`
- **Used in**: [DashboardModel.dart](lib/providers/DashboardModel.dart#L97)

### 32. FETCH_COLLECTIONS
- **Endpoint**: `fetch_collections`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0"
    }
  }
  ```
- **Used in**: [CollectionsScreen.dart](lib/screens/CollectionsScreen.dart#L42)

### 33. FETCHSINGLECHOLLECTION
- **Endpoint**: `fetchSingleCollection`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "collection_id": "123"
    }
  }
  ```
- **Used in**: [CollectionDetailsScreen.dart](lib/screens/CollectionDetailsScreen.dart#L53)

### 34. GET_FAQS
- **Endpoint**: `fetchfaqs`
- **HTTP Method**: GET
- **Response**: `{ "faqs": [...] }`
- **Used in**: [FaqsScreen.dart](lib/screens/FaqsScreen.dart#L87)

### 35. LOADCOUNTRIES
- **Endpoint**: `loadcountries`
- **HTTP Method**: GET
- **Response**: `{ "countries": [...] }`
- **Used in**: [AppStateManager.dart](lib/providers/AppStateManager.dart#L350)

### 36. LOADBANKS
- **Endpoint**: `loadbanks`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "country": "country_id"
    }
  }
  ```
- **Response**: `{ "banks": [...] }`
- **Used in**: [BuyBook.dart](lib/pages/BuyBook.dart#L586)

### 37. RATEBOOK
- **Endpoint**: `ratebook`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "bookid": "book_id",
      "rate": "4.5",
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [EbooksViewerScreen.dart](lib/screens/EbooksViewerScreen.dart#L124)

### 38. UPDATE_TOTAL_VIEWS
- **Endpoint**: `update_total_views`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "bookid": "book_id"
    }
  }
  ```
- **Used in**: [EbooksViewerScreen.dart](lib/screens/EbooksViewerScreen.dart#L143)

### 39. UPDATE_ARTICLE_TOTAL_VIEWS
- **Endpoint**: `update_article_total_views`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "articleid": "article_id"
    }
  }
  ```
- **Used in**: [ArticleViewerScreen.dart](lib/screens/ArticleViewerScreen.dart#L76)

### 40. RELATEDBOOKS
- **Endpoint**: `relatedbooks`
- **HTTP Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "bookid": "book_id",
      "email": "user@example.com"
    }
  }
  ```
- **Response**: `{ "books": [...] }`
- **Used in**: [RelatedBooksListView.dart](lib/screens/RelatedBooksListView.dart#L42)

---

## COMMON RESPONSE HANDLING PATTERN

```dart
if (response.statusCode == 200) {
  Map<String, dynamic> res = json.decode(response.body);
  if (res["status"] == "ok" || res["status"] != "error") {
    // Process successful response
  } else {
    // Handle error from API
    Alerts.showToast(context, res["message"]);
  }
} else {
  // Handle HTTP error
  Alerts.showToast(context, "A network error occured.");
}
```

---

## ENCODING PATTERNS

### Base64 Encoding for Text Fields
- Review content and comments are Base64 encoded before sending
- Decoded using: `Utility.getBase64EncodedString(content)`

### JSON Structure
- All request bodies wrapped in `{"data": {...}}`
- All responses are standard JSON objects
- Arrays in responses typically named by plural or type (e.g., `books`, `articles`, `reviews`)

---

## ERROR HANDLING PATTERNS

1. **Status Code Check**: All endpoints check `response.statusCode == 200`
2. **JSON Parse**: `json.decode(response.body)` for parsing
3. **Error Field**: Some responses have `"status"` field with "ok" or "error"
4. **Message Field**: Error messages in `"message"` field
5. **User Feedback**: Errors typically shown via `Alerts.showToast()` or `Alerts.show()`

---

## PAGINATION PATTERN

- Used in: `FETCH_BOOKS`, `FETCH_ARTICLES`, `FETCH_AUTHORS`, `LOADREVIEWS`
- Parameter: `"page": "0"` (0-indexed)
- Increment page for loading more items
- Controlled via refresh controller: `RefreshController`

---

## NOTES & OBSERVATIONS

1. **Consistent Format**: All POST endpoints use same request wrapper `{"data": {...}}`
2. **No Authentication Headers**: No bearer tokens or API keys seen (may use session/cookies)
3. **Mostly POST**: Most endpoints use POST even for read operations
4. **GET Endpoints**: Only used for simple endpoints like `GET_COINS`, `GET_FAQS`, `loadcountries`
5. **File Uploads**: Multipart requests for proof of payment uploads
6. **Base64 Encoding**: Used for text content (reviews, comments)
7. **Email-based**: Most user endpoints use email as identifier
8. **Type Parameters**: Some endpoints use `type` field for distinguishing book/article/etc.
9. **Response Parsing**: Heavy use of `compute()` for parsing large JSON responses
10. **Error Recovery**: Most endpoints include try-catch with error state management

