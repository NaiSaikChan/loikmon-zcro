# Loikmon (လိက်မန်)

A multi-platform Flutter application (mobile, web, desktop) focused on eBook and audio features. The codebase contains audio playback, local persistence, i18n, provider-based state management, and platform-specific integrations.

## Quick links

- Code: `lib/`
- Assets: `assets/`
- Platform folders: `ios/`, `web/`, (Windows support via dependency overrides)
- Config: `config.json`

## Requirements

- Flutter SDK with Dart matching this project's `pubspec.yaml` environment (Dart SDK `>=2.17.0 <3.0.0`).
- macOS required for iOS builds; Android Studio / Android SDK for Android; Chrome for web development.

## Setup (local development)

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. From the project root, get packages:

```bash
flutter pub get
```

3. If the project uses code generation (i18n / build_runner), generate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Run (development)

- Run on Android emulator / connected device:

```bash
flutter run -d android
```

- Run on iOS (macOS only):

```bash
flutter run -d ios
```

- Run on web (Chrome):

```bash
flutter run -d chrome
```

## Build for release

- Android APK / AAB:

```bash
flutter build apk --release
flutter build appbundle --release
```

- iOS (macOS):

```bash
flutter build ios --release
```

- Web:

```bash
flutter build web --release
```

## Project structure (high level)

- `lib/` — application code
	- `audio_player/` — audio UI and playback
	- `database/` — local SQLite provider
	- `i18n/` — translation resources
	- `models/` — data models used across app
	- `pages/`, `screens/` — UI pages and flows
	- `providers/` — state management (Provider)
	- `service/`, `utils/`, `widgets/` — helpers and shared widgets
- `assets/` — images, fonts, lottie animations

## Notable dependencies

- `provider` — state management
- `dio` / `http` — networking (some dependency overrides present)
- `sqflite_common_ffi_web` — SQLite support for web/ffi
- `audioplayers` — audio playback
- `fast_i18n` — localization tooling

## Development notes & recommendations

- README currently replaces the default Flutter stub — update as features evolve.
- Add `analysis_options.yaml` and a linter (recommended: `package:pedantic` or `flutter_lints`) to enforce code quality.
- Consider adding CI (GitHub Actions) to run `flutter analyze`, `flutter test`, and format checks on PRs.
- Review `pubspec.yaml` overrides and upgrade dependencies where possible. Address version conflicts (e.g., `http`) and migrate to latest null-safe releases and Dart 3 when ready.

## Security & configuration

- Do not commit secrets or production API keys into `config.json` or source control. Use environment variables and CI secrets, or `flutter_secure_storage` for runtime secrets.
- Use HTTPS and enable certificate validation / pinning for critical network calls.

## Tests

Run unit & widget tests with:

```bash
flutter test
```

## Troubleshooting

- If i18n or generated files are missing, run `build_runner` (see Setup).
- Web-specific issues can appear in `web/index.html` (meta viewport, lang attribute). See `web/index.html` and move inline styles to CSS.

## Contribution

1. Fork the repo
2. Create a branch: `feature/your-feature`
3. Add tests and follow lint rules
4. Open a PR with a clear description

## API Endpoints Documentation

**Base URL**: `https://loikmon.org/webapis/`

All endpoints accept **POST** requests with JSON body format: `{"data": {...}}` unless otherwise specified.
All responses return HTTP 200 with JSON containing a `status` field ("ok" or "error") and optional `message` field.

### Authentication Endpoints

#### 1. Login
- **Endpoint**: `loginapp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "password": "password123"
    }
  }
  ```
- **Response**:
  ```json
	{
	"status": "ok",
	"message": "User Authenticated",
	"user": {
		"id": "19",
		"seller": "0",
		"author": "0",
		"email": "xxxx@gmail.com",
		"password": "xxxxx",
		"username": "Srbb",
		"phone": "0",
		"firstname": "",
		"lastname": "",
		"thumbnail": "",
		"coins": "0",
		"day": "0",
		"month": "0",
		"year": "0",
		"date": "2023-10-21 06:44:19"
	},
	"isadminuser": "0",
	"statuscode": 0,
	"devices": [
		{
			"id": "9",
			"user_email": "xxxxx@gmail.com",
			"device_id": "BP2A.250605.031.A3",
			"device_model": "SM-S911N",
			"platform": "android",
			"last_login": "2026-04-26 02:48:21"
		},
		{
			"id": "16",
			"user_email": "xxxxx@gmail.com",
			"device_id": "AE3A.240806.036",
			"device_model": "sdk_gphone64_arm64",
			"platform": "android",
			"last_login": "2026-04-25 19:01:59"
		}
	],
	"devices_in_use": 2,
	"device_limit": 2
	}
  ```
- **Used in**: [AuthPage.dart](lib/screens/AuthPage.dart)

#### 2. Create Account
- **Endpoint**: `createaccount`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "firstname": "John",
      "lastname": "Doe",
      "email": "john@example.com",
      "password": "password123",
      "phone": "+1234567890",
      "country": "US"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "message": "Account created successfully"
  }
  ```

#### 3. Reset Password
- **Endpoint**: `resetpassword`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "message": "Password reset link sent to email"
  }
  ```

#### 4. Resend Verification Email
- **Endpoint**: `resendVerificationMail`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 5. Update User Profile
- **Endpoint**: `updateUserProfile`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "firstname": "Jane",
      "lastname": "Smith",
      "phone": "+1987654321",
      "country": "CA"
    }
  }
  ```

#### 6. Delete Account
- **Endpoint**: `deletemyaccount`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "password": "password123"
    }
  }
  ```

---

### Content Fetching Endpoints

#### 7. Fetch Books
- **Endpoint**: `fetchbooks`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "books": [ { "id": 1, "title": "Book 1", ... }, ... ]
  }
  ```
- **Used in**: [BooksScreen.dart](lib/screens/BooksScreen.dart)

#### 8. Fetch Other Users' Books
- **Endpoint**: `fetchotherbooks`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "author_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 9. Fetch Articles
- **Endpoint**: `fetcharticles`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [ArticlesScreen.dart](lib/screens/ArticlesScreen.dart)

#### 10. Fetch Authors
- **Endpoint**: `fetchauthors`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 11. Fetch Categories
- **Endpoint**: `fetchcategories`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 12. Get Book Chapters
- **Endpoint**: `getBookChapters`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 13. Search
- **Endpoint**: `search`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "query": "search term",
      "type": "book|article|author",
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 14. Fetch App Categories
- **Endpoint**: `fetch_app_categories`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 15. Fetch Subcategories
- **Endpoint**: `fetch_sub_categories`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "category_id": "123",
      "email": "user@example.com"
    }
  }
  ```

---

### User Data & Purchases

#### 16. Get User Coins
- **Endpoint**: `getusercoins`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "coins": [ { "id": 1, "type": "premium", "amount": 100, ... }, ... ]
  }
  ```

#### 17. Fetch User Purchases
- **Endpoint**: `fetchuserpurchases`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "page": "0"
    }
  }
  ```

#### 18. Fetch User Purchased Books
- **Endpoint**: `fetchuserpurchasedbooks`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [PurchasedBooks.dart](lib/screens/PurchasedBooks.dart)

#### 19. Fetch User Purchased Articles
- **Endpoint**: `fetchuserpurchasedarticles`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 20. Fetch User Pending Purchases
- **Endpoint**: `fetchuserpendingpurchases`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 21. Get Coins
- **Endpoint**: `fetchcoins`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

---

### Inbox & Notifications

#### 22. Fetch Inbox
- **Endpoint**: `fetch_inbox`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "inbox": [ { "id": 1, "type": "payment", "message": "...", ... }, ... ]
  }
  ```
- **Used in**: [InboxListScreen.dart](lib/screens/InboxListScreen.dart)

#### 23. Fetch Author Inbox
- **Endpoint**: `fetch_author_inbox`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 24. Store FCM Token
- **Endpoint**: `storefcmtoken`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "fcm_token": "firebase_token_here"
    }
  }
  ```
- **Note**: Endpoint defined but **NOT IMPLEMENTED** in app (no Firebase Cloud Messaging integration yet)

---

### Reviews & Comments

#### 25. Submit Review
- **Endpoint**: `submitreview`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "type": "book|article",
      "item_id": "123",
      "email": "user@example.com",
      "rating": 5,
      "review_text": "Base64EncodedText",
      "title": "Review Title"
    }
  }
  ```
- **Used in**: [ReviewsScreen.dart](lib/screens/ReviewsScreen.dart)
- **Note**: Review text is Base64 encoded before sending

#### 26. Load Reviews
- **Endpoint**: `loadreviews`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "type": "book|article",
      "item_id": "123",
      "page": "0"
    }
  }
  ```
- **Response**:
  ```json
  {
    "status": "ok",
    "reviews": [ { "id": 1, "rating": 5, "review_text": "...", ... }, ... ]
  }
  ```

#### 27. Edit Review
- **Endpoint**: `editreview`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "review_id": "123",
      "rating": 4,
      "review_text": "Base64EncodedText",
      "email": "user@example.com"
    }
  }
  ```

#### 28. Delete Review
- **Endpoint**: `deletereview`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "review_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 29. Load User Review
- **Endpoint**: `loaduserreview`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "type": "book|article",
      "item_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 30. Reply to Comment
- **Endpoint**: `replycomment`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "comment_id": "123",
      "reply_text": "Base64EncodedText",
      "email": "user@example.com"
    }
  }
  ```

#### 31. Edit Reply
- **Endpoint**: `editreply`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "reply_id": "123",
      "reply_text": "Base64EncodedText",
      "email": "user@example.com"
    }
  }
  ```

#### 32. Delete Reply
- **Endpoint**: `deletereply`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "reply_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 33. Load Replies
- **Endpoint**: `loadreplies`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "comment_id": "123",
      "page": "0"
    }
  }
  ```

#### 34. Report Comment
- **Endpoint**: `reportcomment`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "comment_id": "123",
      "reason": "inappropriate",
      "email": "user@example.com"
    }
  }
  ```

#### 35. Report Book
- **Endpoint**: `reportbook`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "reason": "inappropriate",
      "email": "user@example.com"
    }
  }
  ```

---

### Purchase & Payment Endpoints

#### 36. Purchase Book
- **Endpoint**: `purchasebook`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "email": "user@example.com",
      "payment_method": "stripe|paypal|coins",
      "amount": 9.99,
      "currency": "USD"
    }
  }
  ```
- **Used in**: [BuyBook.dart](lib/pages/BuyBook.dart)

#### 37. Purchase Article
- **Endpoint**: `purchasearticle`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "article_id": "123",
      "email": "user@example.com",
      "payment_method": "stripe|paypal|coins",
      "amount": 4.99,
      "currency": "USD"
    }
  }
  ```

#### 38. Record Payment
- **Endpoint**: `record_payment`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "transaction_id": "txn_123",
      "amount": 9.99,
      "payment_method": "stripe",
      "status": "completed"
    }
  }
  ```

#### 39. Proof of Payment
- **Endpoint**: `proofofpayment`
- **Method**: POST (Multipart Form Data)
- **Form Data**:
  ```
  email: user@example.com
  payment_id: 123
  proof_file: [image file]
  ```
- **Used in**: Bank payment verification

#### 40. Subscribe/Redeem Coupon
- **Endpoint**: `subscribeCoupon`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "coupon_code": "ABC123",
      "email": "user@example.com"
    }
  }
  ```

#### 41. Redeem Book Coupon
- **Endpoint**: `subscribeBookCoupon` (also used as `REDEEM_BOOK_COUPON`)
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "coupon_code": "BOOK123",
      "email": "user@example.com",
      "book_id": "456"
    }
  }
  ```
- **Used in**: [RedeemBookCouponPage.dart](lib/screens/RedeemBookCouponPage.dart)

#### 42. Pending Bank Payments
- **Endpoint**: `pendingBankPaymentsApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com",
      "page": "0"
    }
  }
  ```
- **Used in**: [PendingBankPaymentsPage.dart](lib/screens/PendingBankPaymentsPage.dart)

#### 43. Approve Bank Payment
- **Endpoint**: `approveBankPaymentsApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "payment_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 44. Delete Bank Payment
- **Endpoint**: `deleteBankPaymentsApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "payment_id": "123",
      "email": "user@example.com"
    }
  }
  ```

---

### Content Interaction Endpoints

#### 45. Rate Book
- **Endpoint**: `ratebook`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "rating": 5,
      "email": "user@example.com"
    }
  }
  ```

#### 46. Get Book Views and Ratings
- **Endpoint**: `getbookviewsrates`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123"
    }
  }
  ```

#### 47. Update Book Total Views
- **Endpoint**: `update_total_views`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: [EbooksViewerScreen.dart](lib/screens/EbooksViewerScreen.dart)

#### 48. Update Article Total Views
- **Endpoint**: `update_article_total_views`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "article_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 49. Get Related Books
- **Endpoint**: `relatedbooks`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "page": "0"
    }
  }
  ```

#### 50. Get Related Magazines
- **Endpoint**: `relatedmagazines`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "magazine_id": "123",
      "page": "0"
    }
  }
  ```

---

### Author Endpoints

#### 51. Get Author Details
- **Endpoint**: `getauthor`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 52. Get Author Data
- **Endpoint**: `get_author_data`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 53. Follow/Unfollow Author
- **Endpoint**: `follow_unfollow_author`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author_id": "123",
      "email": "user@example.com",
      "action": "follow|unfollow"
    }
  }
  ```

#### 54. Fetch Author Categories
- **Endpoint**: `fetchauthorcategories`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "author_id": "123",
      "email": "user@example.com"
    }
  }
  ```

---

### Media/Audio Endpoints

#### 55. Fetch Media
- **Endpoint**: `fetch_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 56. Fetch Artist Media
- **Endpoint**: `fetch_artists_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "artist_id": "123",
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 57. Fetch Categories Media
- **Endpoint**: `fetch_categories_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "category_id": "123",
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 58. Fetch Genre Media
- **Endpoint**: `fetch_genre_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "genre_id": "123",
      "page": "0"
    }
  }
  ```

#### 59. Fetch Albums
- **Endpoint**: `fetch_albums`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 60. Fetch Album Media
- **Endpoint**: `fetch_album_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "album_id": "123",
      "page": "0"
    }
  }
  ```

#### 61. Update Media Total Views
- **Endpoint**: `update_media_total_views`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "media_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 62. Like/Unlike Media
- **Endpoint**: `likeunlikemedia`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "media_id": "123",
      "email": "user@example.com",
      "action": "like|unlike"
    }
  }
  ```

#### 63. Purchase Media
- **Endpoint**: `purchase_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "media_id": "123",
      "email": "user@example.com",
      "payment_method": "coins|stripe",
      "amount": 4.99
    }
  }
  ```

#### 64. Tip Media Creator
- **Endpoint**: `tip_media`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "media_id": "123",
      "email": "user@example.com",
      "tip_amount": 5.00,
      "payment_method": "coins|stripe"
    }
  }
  ```

#### 65. Purchase Album
- **Endpoint**: `purchase_album`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "album_id": "123",
      "email": "user@example.com",
      "payment_method": "coins|stripe",
      "amount": 19.99
    }
  }
  ```

---

### Artist Management Endpoints

#### 66. Create Album
- **Endpoint**: `createAlbumApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "artist@example.com",
      "album_name": "Album Title",
      "description": "Album description",
      "genre_id": "123",
      "cover_image": "base64_or_url"
    }
  }
  ```

#### 67. Edit Album
- **Endpoint**: `editAlbumApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "album_id": "123",
      "email": "artist@example.com",
      "album_name": "Updated Title",
      "description": "Updated description"
    }
  }
  ```

#### 68. Create Media
- **Endpoint**: `createMediaApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "artist@example.com",
      "title": "Media Title",
      "description": "Description",
      "album_id": "123",
      "audio_file": "url_or_base64",
      "duration": 180
    }
  }
  ```

#### 69. Edit Media
- **Endpoint**: `editMediaApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "media_id": "123",
      "email": "artist@example.com",
      "title": "Updated Title",
      "description": "Updated description"
    }
  }
  ```

#### 70. Artist Dashboard
- **Endpoint**: `artistdashboard`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "artist@example.com"
    }
  }
  ```

#### 71. Artist Filter Dashboard
- **Endpoint**: `artistfilterdashboard`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "artist@example.com",
      "filter_by": "date|views|likes",
      "page": "0"
    }
  }
  ```

#### 72. Edit Artist Profile
- **Endpoint**: `editArtistApp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "artist@example.com",
      "artist_name": "New Name",
      "bio": "Artist bio",
      "profile_image": "url_or_base64"
    }
  }
  ```

---

### Utility Endpoints

#### 73. Initialize App
- **Endpoint**: `initapp`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: Dashboard initialization

#### 74. Fetch FAQs
- **Endpoint**: `fetchfaqs`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 75. Load Countries
- **Endpoint**: `loadcountries`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 76. Load Banks
- **Endpoint**: `loadbanks`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "country_code": "US",
      "email": "user@example.com"
    }
  }
  ```

#### 77. Get Item (Book/Article via Deep Link)
- **Endpoint**: `getitem`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "type": "book|article",
      "id": "123",
      "email": "user@example.com"
    }
  }
  ```
- **Used in**: Deep link processing in [MyApp.dart](lib/MyApp.dart)

#### 78. Fetch Contact Us
- **Endpoint**: `fetchcontactus`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "email": "user@example.com"
    }
  }
  ```

#### 79. Fetch Leagues
- **Endpoint**: `fetchleagues`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 80. Fetch Collections
- **Endpoint**: `fetch_collections`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0",
      "email": "user@example.com"
    }
  }
  ```

#### 81. Fetch Single Collection
- **Endpoint**: `fetchSingleCollection`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "collection_id": "123",
      "email": "user@example.com"
    }
  }
  ```

#### 82. Approve Book (Admin)
- **Endpoint**: `approvebook`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "book_id": "123",
      "email": "admin@example.com",
      "status": "approved|rejected"
    }
  }
  ```

#### 83. Delete Proof Request
- **Endpoint**: `deleteproofrequest`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "request_id": "123",
      "email": "user@example.com"
    }
  }
  ```

---

### Static Content Endpoints

#### 84. Terms of Service
- **Endpoint**: `terms`
- **Method**: GET/POST

#### 85. Privacy Policy
- **Endpoint**: `privacy`
- **Method**: GET/POST

#### 86. About Us
- **Endpoint**: `aboutus`
- **Method**: GET/POST

#### 87. Donate
- **Endpoint**: `donate`
- **Method**: POST

#### 88. Trending Media
- **Endpoint**: `getTrendingMedia`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0"
    }
  }
  ```

#### 89. Fetch All Albums
- **Endpoint**: `fetch_all_albums`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0"
    }
  }
  ```

#### 90. Fetch Moods
- **Endpoint**: `fetch_moods`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {}
  }
  ```

#### 91. Fetch Live Streams
- **Endpoint**: `fetch_livestreams`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "page": "0"
    }
  }
  ```

#### 92. Deep Link Handler
- **Endpoint**: `deeplink`
- **Method**: POST
- **Request Body**:
  ```json
  {
    "data": {
      "url": "full_deep_link_url",
      "email": "user@example.com"
    }
  }
  ```

---

## Common Request/Response Patterns

### HTTP Status Codes
- **200 OK**: Request successful (check `status` field in body)
- **400 Bad Request**: Invalid parameters
- **401 Unauthorized**: Invalid credentials
- **500 Server Error**: Server-side issue

### Response Format
All responses follow this structure:
```json
{
  "status": "ok|error",
  "message": "Optional error/success message",
  "data": { ... }  // Optional additional data
}
```

### Common Parameters
- **email**: User email (used as user identifier; no JWT tokens visible)
- **page**: Pagination parameter (0-indexed for load-more functionality)
- **type**: Content type (usually "book" or "article")
- **id**: Item identifier
- **action**: Operation type ("like", "follow", etc.)

### Special Handling
- **Base64 Encoding**: Review text and comments are Base64 encoded before transmission
- **File Uploads**: Some endpoints (e.g., `proofofpayment`) use multipart/form-data
- **Pagination**: Uses page parameter starting from 0 for infinite scroll / load-more

### Error Handling Pattern
```dart
if (response.statusCode == 200) {
  dynamic res = jsonDecode(response.body);
  if (res['status'] == "ok") {
    // Success
  } else {
    // Handle error from res['message']
  }
} else {
  // HTTP error
}
```

---

## License

This repository includes a `LICENSE` file. Follow its terms when contributing or publishing.

---

If you'd like, I can also:
- produce an `analysis_options.yaml` with recommended lints,
- add a basic GitHub Actions CI workflow to run analyze + test,
- open a draft PR with proposed refactors (feature modularization, DI, test harness).
