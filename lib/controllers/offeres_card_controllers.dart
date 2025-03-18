
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/offers_card_data.dart';
import '../model/offers_card_model.dart';

class OffersNotifyer extends StateNotifier<List<OffersModel>> {
  OffersNotifyer() : super(offersModel);
}

final OfferscardNotifyerProvider =
    StateNotifierProvider<OffersNotifyer, List<OffersModel>>((ref) {
  return OffersNotifyer();
});
