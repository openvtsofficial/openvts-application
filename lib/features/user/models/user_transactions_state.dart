import 'user_transactions_model.dart';

enum UserTransactionsRangePreset {
  thisMonth,
  last30Days,
  thisYear,
  custom,
}

class UserTransactionsState {
  const UserTransactionsState({
    required this.transactions,
    required this.selectedTransaction,
    required this.selectedStatus,
    required this.selectedPaymentMode,
    required this.selectedDirection,
    required this.searchQuery,
    required this.rangePreset,
    required this.customFrom,
    required this.customTo,
    required this.page,
    required this.limit,
    required this.total,
    required this.isLoading,
    required this.isRefreshing,
    required this.errorMessage,
    required this.refreshKey,
  });

  const UserTransactionsState.initial()
      : transactions = const <UserTransaction>[],
        selectedTransaction = null,
        selectedStatus = null,
        selectedPaymentMode = null,
        selectedDirection = null,
        searchQuery = '',
        rangePreset = UserTransactionsRangePreset.thisMonth,
        customFrom = null,
        customTo = null,
        page = 1,
        limit = 100,
        total = 0,
        isLoading = false,
        isRefreshing = false,
        errorMessage = null,
        refreshKey = '';

  static const Object _unset = Object();

  final List<UserTransaction> transactions;
  final UserTransaction? selectedTransaction;
  final UserTransactionStatus? selectedStatus;
  final UserPaymentMode? selectedPaymentMode;
  final UserTransactionDirection? selectedDirection;
  final String searchQuery;
  final UserTransactionsRangePreset rangePreset;
  final DateTime? customFrom;
  final DateTime? customTo;
  final int page;
  final int limit;
  final int total;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final String refreshKey;

  bool get hasTransactions => transactions.isNotEmpty;

  bool get hasMore => page * limit < total;

  bool get hasActiveFilters {
    return selectedStatus != null ||
        selectedPaymentMode != null ||
        selectedDirection != null ||
        searchQuery.trim().isNotEmpty ||
        rangePreset != UserTransactionsRangePreset.thisMonth;
  }

  /// Returns the filtered list of transactions for [currentUserId].
  ///
  /// Credit/Debit direction is derived from [fromUserId]/[toUserId] relative
  /// to the authenticated user — it is never compared against
  /// [UserTransaction.paymentType], which holds unrelated backend values
  /// (SYSTEM / MANUAL / ONLINE).
  List<UserTransaction> filteredTransactionsFor(String? currentUserId) {
    final modeFilter = selectedPaymentMode;
    final directionFilter = selectedDirection;

    if (modeFilter == null && directionFilter == null) {
      return transactions;
    }

    return transactions.where((transaction) {
      if (modeFilter != null && transaction.paymentMode != modeFilter) {
        return false;
      }

      if (directionFilter != null) {
        final direction = transactionDirectionFor(transaction, currentUserId);
        if (direction != directionFilter) {
          return false;
        }
      }

      return true;
    }).toList(growable: false);
  }

  UserTransactionsState copyWith({
    List<UserTransaction>? transactions,
    Object? selectedTransaction = _unset,
    Object? selectedStatus = _unset,
    Object? selectedPaymentMode = _unset,
    Object? selectedDirection = _unset,
    String? searchQuery,
    UserTransactionsRangePreset? rangePreset,
    Object? customFrom = _unset,
    Object? customTo = _unset,
    int? page,
    int? limit,
    int? total,
    bool? isLoading,
    bool? isRefreshing,
    Object? errorMessage = _unset,
    String? refreshKey,
  }) {
    return UserTransactionsState(
      transactions: transactions ?? this.transactions,
      selectedTransaction: identical(selectedTransaction, _unset)
          ? this.selectedTransaction
          : selectedTransaction as UserTransaction?,
      selectedStatus: identical(selectedStatus, _unset)
          ? this.selectedStatus
          : selectedStatus as UserTransactionStatus?,
      selectedPaymentMode: identical(selectedPaymentMode, _unset)
          ? this.selectedPaymentMode
          : selectedPaymentMode as UserPaymentMode?,
      selectedDirection: identical(selectedDirection, _unset)
          ? this.selectedDirection
          : selectedDirection as UserTransactionDirection?,
      searchQuery: searchQuery ?? this.searchQuery,
      rangePreset: rangePreset ?? this.rangePreset,
      customFrom: identical(customFrom, _unset)
          ? this.customFrom
          : customFrom as DateTime?,
      customTo:
          identical(customTo, _unset) ? this.customTo : customTo as DateTime?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      refreshKey: refreshKey ?? this.refreshKey,
    );
  }
}
