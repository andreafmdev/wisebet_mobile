import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/offers_repository.dart';
import '../../data/repositories/surebet_repository.dart';
import '../../data/repositories/profit_repository.dart';
import '../../data/repositories/guides_repository.dart';
import '../../data/repositories/subscription_repository.dart';

/// Provider per i repository
final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository();
});

final surebetRepositoryProvider = Provider<SurebetRepository>((ref) {
  return SurebetRepository();
});

final profitRepositoryProvider = Provider<ProfitRepository>((ref) {
  return ProfitRepository();
});

final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  return GuidesRepository();
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository();
});

