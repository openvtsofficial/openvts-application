import 'dart:math' as math;

import 'superadmin_administrator_model.dart';

class SuperadminAdministratorsState {
  const SuperadminAdministratorsState({
    required this.administrators,
    required this.countries,
    required this.mobilePrefixes,
    required this.stateOptions,
    required this.cityOptions,
    required this.searchQuery,
    required this.roleFilter,
    required this.statusFilter,
    required this.sortOption,
    required this.recordsPerPage,
    required this.currentPage,
    required this.isInitialLoading,
    required this.isRefreshing,
    required this.isCatalogLoading,
    required this.isLoadingStates,
    required this.isLoadingCities,
    required this.statesLoadedForCountry,
    required this.citiesLoadedForState,
    required this.isCreating,
    required this.togglingAdministratorId,
    required this.deletingAdministratorId,
    required this.loggingInAdministratorId,
    required this.errorMessage,
  });

  const SuperadminAdministratorsState.initial()
      : administrators = const <SuperadminAdministrator>[],
        countries = const <SuperadminCountryOption>[],
        mobilePrefixes = const <SuperadminMobilePrefixOption>[],
        stateOptions = const <SuperadminStateOption>[],
        cityOptions = const <SuperadminCityOption>[],
        searchQuery = '',
        roleFilter = SuperadminAdministratorRoleFilter.all,
        statusFilter = SuperadminAdministratorStatusFilter.all,
        sortOption = SuperadminAdministratorSortOption.recentLogin,
        recordsPerPage = 10,
        currentPage = 1,
        isInitialLoading = true,
        isRefreshing = false,
        isCatalogLoading = false,
        isLoadingStates = false,
        isLoadingCities = false,
        statesLoadedForCountry = null,
        citiesLoadedForState = null,
        isCreating = false,
        togglingAdministratorId = null,
        deletingAdministratorId = null,
        loggingInAdministratorId = null,
        errorMessage = null;

  static const _unset = Object();

  final List<SuperadminAdministrator> administrators;
  final List<SuperadminCountryOption> countries;
  final List<SuperadminMobilePrefixOption> mobilePrefixes;
  final List<SuperadminStateOption> stateOptions;
  final List<SuperadminCityOption> cityOptions;
  final String searchQuery;
  final SuperadminAdministratorRoleFilter roleFilter;
  final SuperadminAdministratorStatusFilter statusFilter;
  final SuperadminAdministratorSortOption sortOption;
  final int recordsPerPage;
  final int currentPage;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isCatalogLoading;

  /// True while the states API call is in-flight for the currently selected country.
  final bool isLoadingStates;

  /// True while the cities API call is in-flight for the currently selected state.
  final bool isLoadingCities;

  /// The country code for which [stateOptions] was last successfully loaded.
  /// Null means states have never been fetched yet (or were cleared).
  final String? statesLoadedForCountry;

  /// The state code for which [cityOptions] was last successfully loaded.
  /// Null means cities have never been fetched yet (or were cleared).
  final String? citiesLoadedForState;

  final bool isCreating;
  final String? togglingAdministratorId;
  final String? deletingAdministratorId;
  final String? loggingInAdministratorId;
  final String? errorMessage;

  /// True only when states were successfully loaded and the list is non-empty.
  bool get hasStates =>
      statesLoadedForCountry != null && stateOptions.isNotEmpty;

  /// True only when cities were successfully loaded and the list is non-empty.
  bool get hasCities => citiesLoadedForState != null && cityOptions.isNotEmpty;

  bool get hasItems => administrators.isNotEmpty;

  List<SuperadminAdministrator> get filteredAdministrators {
    final filtered = administrators.where((administrator) {
      final matchesQuery = administrator.matchesQuery(searchQuery);
      final matchesRole = switch (roleFilter) {
        SuperadminAdministratorRoleFilter.all => true,
        SuperadminAdministratorRoleFilter.superadmin =>
          administrator.isSuperAdmin,
        SuperadminAdministratorRoleFilter.admin => !administrator.isSuperAdmin,
      };
      final matchesStatus = switch (statusFilter) {
        SuperadminAdministratorStatusFilter.all => true,
        SuperadminAdministratorStatusFilter.active => administrator.isActive,
        SuperadminAdministratorStatusFilter.inactive => !administrator.isActive,
      };

      return matchesQuery && matchesRole && matchesStatus;
    }).toList(growable: false);

    filtered.sort((left, right) {
      switch (sortOption) {
        case SuperadminAdministratorSortOption.recentLogin:
          final leftValue =
              left.lastLoginAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final rightValue =
              right.lastLoginAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return rightValue.compareTo(leftValue);
        case SuperadminAdministratorSortOption.nameAscending:
          return left.name.toLowerCase().compareTo(right.name.toLowerCase());
        case SuperadminAdministratorSortOption.nameDescending:
          return right.name.toLowerCase().compareTo(left.name.toLowerCase());
        case SuperadminAdministratorSortOption.vehiclesDescending:
          return right.totalVehicles.compareTo(left.totalVehicles);
        case SuperadminAdministratorSortOption.usersDescending:
          return right.totalUsers.compareTo(left.totalUsers);
      }
    });

    return filtered;
  }

  int get filteredCount => filteredAdministrators.length;

  int get pageCount =>
      math.max<int>(1, (filteredCount / recordsPerPage).ceil());

  int get safeCurrentPage {
    return currentPage.clamp(1, pageCount);
  }

  List<SuperadminAdministrator> get visibleAdministrators {
    final start = (safeCurrentPage - 1) * recordsPerPage;
    if (start >= filteredCount) {
      return const <SuperadminAdministrator>[];
    }
    return filteredAdministrators
        .skip(start)
        .take(recordsPerPage)
        .toList(growable: false);
  }

  int get showingCount => visibleAdministrators.length;

  bool isToggling(String administratorId) =>
      togglingAdministratorId == administratorId;

  bool isDeleting(String administratorId) =>
      deletingAdministratorId == administratorId;

  bool isLoggingIn(String administratorId) =>
      loggingInAdministratorId == administratorId;

  SuperadminAdministratorsState copyWith({
    List<SuperadminAdministrator>? administrators,
    List<SuperadminCountryOption>? countries,
    List<SuperadminMobilePrefixOption>? mobilePrefixes,
    List<SuperadminStateOption>? stateOptions,
    List<SuperadminCityOption>? cityOptions,
    String? searchQuery,
    SuperadminAdministratorRoleFilter? roleFilter,
    SuperadminAdministratorStatusFilter? statusFilter,
    SuperadminAdministratorSortOption? sortOption,
    int? recordsPerPage,
    int? currentPage,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isCatalogLoading,
    bool? isLoadingStates,
    bool? isLoadingCities,
    Object? statesLoadedForCountry = _unset,
    Object? citiesLoadedForState = _unset,
    bool? isCreating,
    Object? togglingAdministratorId = _unset,
    Object? deletingAdministratorId = _unset,
    Object? loggingInAdministratorId = _unset,
    Object? errorMessage = _unset,
  }) {
    return SuperadminAdministratorsState(
      administrators: administrators ?? this.administrators,
      countries: countries ?? this.countries,
      mobilePrefixes: mobilePrefixes ?? this.mobilePrefixes,
      stateOptions: stateOptions ?? this.stateOptions,
      cityOptions: cityOptions ?? this.cityOptions,
      searchQuery: searchQuery ?? this.searchQuery,
      roleFilter: roleFilter ?? this.roleFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      sortOption: sortOption ?? this.sortOption,
      recordsPerPage: recordsPerPage ?? this.recordsPerPage,
      currentPage: currentPage ?? this.currentPage,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCatalogLoading: isCatalogLoading ?? this.isCatalogLoading,
      isLoadingStates: isLoadingStates ?? this.isLoadingStates,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      statesLoadedForCountry: identical(statesLoadedForCountry, _unset)
          ? this.statesLoadedForCountry
          : statesLoadedForCountry as String?,
      citiesLoadedForState: identical(citiesLoadedForState, _unset)
          ? this.citiesLoadedForState
          : citiesLoadedForState as String?,
      isCreating: isCreating ?? this.isCreating,
      togglingAdministratorId: identical(togglingAdministratorId, _unset)
          ? this.togglingAdministratorId
          : togglingAdministratorId as String?,
      deletingAdministratorId: identical(deletingAdministratorId, _unset)
          ? this.deletingAdministratorId
          : deletingAdministratorId as String?,
      loggingInAdministratorId: identical(loggingInAdministratorId, _unset)
          ? this.loggingInAdministratorId
          : loggingInAdministratorId as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
