import 'package:loikmon/models/Articles.dart';
import 'package:loikmon/models/Books.dart';

import 'Userdata.dart';

class UserLoggedInEvent {
  Userdata user;
  UserLoggedInEvent(this.user);
}

class OnRequestPayment {
  Books media;
  OnRequestPayment(this.media);
}

class OnRequestArticlePayment {
  Articles media;
  OnRequestArticlePayment(this.media);
}

class OnCoinsPurchase {
  OnCoinsPurchase();
}

class OnMediaUpload {
  OnMediaUpload();
}

class OnVideoStarted {
  OnVideoStarted();
}

class OnTipMedia {
  Books media;
  OnTipMedia(this.media);
}

class OnNavigateArticle {
  int pos;
  OnNavigateArticle(this.pos);
}
