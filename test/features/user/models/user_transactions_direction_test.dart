import 'package:flutter_test/flutter_test.dart';
import 'package:open_vts/features/user/models/user_transactions_model.dart';
import 'package:open_vts/features/user/models/user_transactions_state.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

UserTransaction _makeTransaction({
  String id = 'tx1',
  int? fromUserId,
  int? toUserId,
  UserPaymentMode paymentMode = UserPaymentMode.cash,
  String backendPaymentType = 'SYSTEM',
}) {
  return UserTransaction(
    id: id,
    fromUserId: fromUserId,
    toUserId: toUserId,
    recordedById: null,
    amount: '100',
    currency: 'INR',
    paymentType: backendPaymentType,
    paymentMode: paymentMode,
    status: UserTransactionStatus.success,
    reference: '',
    provider: '',
    providerRef: '',
    idempotencyKey: '',
    failureCode: '',
    failureMessage: '',
    meta: const {},
    createdAt: null,
    createdAtRaw: '',
    fromUser: null,
    toUser: null,
    recordedBy: null,
    vehicle: null,
    plan: null,
  );
}

UserTransactionsState _stateWith({
  List<UserTransaction> transactions = const [],
  UserTransactionDirection? selectedDirection,
  UserPaymentMode? selectedPaymentMode,
}) {
  return UserTransactionsState(
    transactions: transactions,
    selectedTransaction: null,
    selectedStatus: null,
    selectedPaymentMode: selectedPaymentMode,
    selectedDirection: selectedDirection,
    searchQuery: '',
    rangePreset: UserTransactionsRangePreset.thisMonth,
    customFrom: null,
    customTo: null,
    page: 1,
    limit: 100,
    total: transactions.length,
    isLoading: false,
    isRefreshing: false,
    errorMessage: null,
    refreshKey: '',
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  const currentUserId = '20';

  group('transactionDirectionFor', () {
    test('returns credit when currentUser is toUserId', () {
      final tx = _makeTransaction(fromUserId: 10, toUserId: 20);
      expect(
        transactionDirectionFor(tx, currentUserId),
        UserTransactionDirection.credit,
      );
    });

    test('returns debit when currentUser is fromUserId', () {
      final tx = _makeTransaction(fromUserId: 20, toUserId: 10);
      expect(
        transactionDirectionFor(tx, currentUserId),
        UserTransactionDirection.debit,
      );
    });

    test('returns null when currentUser matches neither party', () {
      final tx = _makeTransaction(fromUserId: 10, toUserId: 30);
      expect(transactionDirectionFor(tx, currentUserId), isNull);
    });

    test('returns null when currentUserId is null', () {
      final tx = _makeTransaction(fromUserId: 20, toUserId: 10);
      expect(transactionDirectionFor(tx, null), isNull);
    });

    test('returns null when currentUserId is empty', () {
      final tx = _makeTransaction(fromUserId: 20, toUserId: 10);
      expect(transactionDirectionFor(tx, ''), isNull);
    });

    test('self-referential: debit takes precedence (sender checked first)', () {
      final tx = _makeTransaction(fromUserId: 20, toUserId: 20);
      expect(
        transactionDirectionFor(tx, currentUserId),
        UserTransactionDirection.debit,
      );
    });

    test('handles missing fromUserId gracefully', () {
      final tx = _makeTransaction(fromUserId: null, toUserId: 20);
      expect(
        transactionDirectionFor(tx, currentUserId),
        UserTransactionDirection.credit,
      );
    });

    test('handles missing toUserId gracefully', () {
      final tx = _makeTransaction(fromUserId: 20, toUserId: null);
      expect(
        transactionDirectionFor(tx, currentUserId),
        UserTransactionDirection.debit,
      );
    });

    test('handles both parties null — returns null without crash', () {
      final tx = _makeTransaction(fromUserId: null, toUserId: null);
      expect(transactionDirectionFor(tx, currentUserId), isNull);
    });
  });

  group('UserTransactionsState.filteredTransactionsFor', () {
    final credit = _makeTransaction(id: 'c1', fromUserId: 10, toUserId: 20);
    final debit = _makeTransaction(id: 'd1', fromUserId: 20, toUserId: 10);
    final unknown = _makeTransaction(id: 'u1', fromUserId: 5, toUserId: 7);

    test('no direction filter returns all transactions', () {
      final state = _stateWith(transactions: [credit, debit, unknown]);
      expect(
        state.filteredTransactionsFor(currentUserId),
        containsAll([credit, debit, unknown]),
      );
    });

    test('credit filter returns only incoming transactions', () {
      final state = _stateWith(
        transactions: [credit, debit, unknown],
        selectedDirection: UserTransactionDirection.credit,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [credit]);
    });

    test('debit filter returns only outgoing transactions', () {
      final state = _stateWith(
        transactions: [credit, debit, unknown],
        selectedDirection: UserTransactionDirection.debit,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [debit]);
    });

    test('credit filter excludes transactions with unknown parties', () {
      final state = _stateWith(
        transactions: [credit, unknown],
        selectedDirection: UserTransactionDirection.credit,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [credit]);
      expect(result, isNot(contains(unknown)));
    });

    test('debit filter excludes transactions with unknown parties', () {
      final state = _stateWith(
        transactions: [debit, unknown],
        selectedDirection: UserTransactionDirection.debit,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [debit]);
      expect(result, isNot(contains(unknown)));
    });

    test('all filter (null direction) includes unknown-party transactions', () {
      final state = _stateWith(transactions: [credit, debit, unknown]);
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, contains(unknown));
    });

    test('credit + payment mode filters combine correctly', () {
      final creditCash = _makeTransaction(
        id: 'cc',
        fromUserId: 10,
        toUserId: 20,
        paymentMode: UserPaymentMode.cash,
      );
      final creditUpi = _makeTransaction(
        id: 'cu',
        fromUserId: 10,
        toUserId: 20,
        paymentMode: UserPaymentMode.upi,
      );
      final state = _stateWith(
        transactions: [creditCash, creditUpi, debit],
        selectedDirection: UserTransactionDirection.credit,
        selectedPaymentMode: UserPaymentMode.cash,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [creditCash]);
    });

    test('debit + payment mode filters combine correctly', () {
      final debitCash = _makeTransaction(
        id: 'dc',
        fromUserId: 20,
        toUserId: 10,
        paymentMode: UserPaymentMode.cash,
      );
      final debitUpi = _makeTransaction(
        id: 'du',
        fromUserId: 20,
        toUserId: 10,
        paymentMode: UserPaymentMode.upi,
      );
      final state = _stateWith(
        transactions: [debitCash, debitUpi, credit],
        selectedDirection: UserTransactionDirection.debit,
        selectedPaymentMode: UserPaymentMode.upi,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, [debitUpi]);
    });

    test(
        'filter survives load-more: new transactions evaluated with same direction',
        () {
      final newCredit = _makeTransaction(
        id: 'c2',
        fromUserId: 11,
        toUserId: 20,
      );
      final state = _stateWith(
        transactions: [credit, newCredit, debit],
        selectedDirection: UserTransactionDirection.credit,
      );
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, containsAll([credit, newCredit]));
      expect(result, isNot(contains(debit)));
    });

    test('clear (null direction) resets direction filter', () {
      final withDirection = _stateWith(
        transactions: [credit, debit],
        selectedDirection: UserTransactionDirection.credit,
      );
      final cleared = withDirection.copyWith(selectedDirection: null);
      final result = cleared.filteredTransactionsFor(currentUserId);
      expect(result, containsAll([credit, debit]));
    });
  });

  group('backend paymentType field is not affected', () {
    test('paymentType parses and retains SYSTEM', () {
      final tx = _makeTransaction(backendPaymentType: 'SYSTEM');
      expect(tx.paymentType, 'SYSTEM');
    });

    test('paymentType parses and retains MANUAL', () {
      final tx = _makeTransaction(backendPaymentType: 'MANUAL');
      expect(tx.paymentType, 'MANUAL');
    });

    test('paymentType parses and retains ONLINE', () {
      final tx = _makeTransaction(backendPaymentType: 'ONLINE');
      expect(tx.paymentType, 'ONLINE');
    });

    test('direction filter never compares against paymentType', () {
      // A transaction with paymentType == CREDIT should NOT appear under
      // credit filter unless the user is actually the receiver.
      final tx = _makeTransaction(
        fromUserId: 10,
        toUserId: 30,
        backendPaymentType: 'CREDIT',
      );
      final state = _stateWith(
        transactions: [tx],
        selectedDirection: UserTransactionDirection.credit,
      );
      // currentUser (20) is neither from nor to — must be excluded.
      final result = state.filteredTransactionsFor(currentUserId);
      expect(result, isEmpty);
    });
  });
}
