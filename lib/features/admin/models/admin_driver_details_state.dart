import 'admin_driver_details_model.dart';
import 'admin_drivers_model.dart';

enum AdminDriverDetailsTab { profile, documents, users }

class AdminDriverDetailsState {
  const AdminDriverDetailsState({
    required this.driverId,
    required this.driver,
    this.initialDriver,
    this.linkedUserCount,
    required this.selectedTab,
    required this.documents,
    required this.documentTypes,
    required this.linkedUsers,
    required this.unlinkedUsers,
    required this.isLoadingDriver,
    required this.isRefreshingDriver,
    required this.isSavingProfile,
    required this.isUpdatingStatus,
    required this.isUpdatingPassword,
    required this.isDeletingDriver,
    required this.isLoadingDocuments,
    required this.isUploadingDocument,
    required this.isDeletingDocument,
    required this.isLoadingUsers,
    required this.isAssigningUser,
    required this.unassigningUserIds,
    required this.errorMessage,
    required this.sectionErrorMessage,
    this.profileUpdatedAt,
  });

  const AdminDriverDetailsState.initial({required this.driverId})
      : driver = null,
        initialDriver = null,
        linkedUserCount = null,
        selectedTab = AdminDriverDetailsTab.profile,
        documents = const <AdminDriverDocument>[],
        documentTypes = const <AdminDriverDocumentType>[],
        linkedUsers = const <AdminDriverLinkedUser>[],
        unlinkedUsers = const <AdminDriverLinkedUser>[],
        isLoadingDriver = false,
        isRefreshingDriver = false,
        isSavingProfile = false,
        isUpdatingStatus = false,
        isUpdatingPassword = false,
        isDeletingDriver = false,
        isLoadingDocuments = false,
        isUploadingDocument = false,
        isDeletingDocument = false,
        isLoadingUsers = false,
        isAssigningUser = false,
        unassigningUserIds = const <String>{},
        errorMessage = null,
        sectionErrorMessage = null,
        profileUpdatedAt = null;

  static const Object _unset = Object();

  final String driverId;
  final AdminDriverDetails? driver;
  final AdminDriverListItem? initialDriver;
  final int? linkedUserCount;
  final AdminDriverDetailsTab selectedTab;
  final List<AdminDriverDocument> documents;
  final List<AdminDriverDocumentType> documentTypes;
  final List<AdminDriverLinkedUser> linkedUsers;
  final List<AdminDriverLinkedUser> unlinkedUsers;
  final bool isLoadingDriver;
  final bool isRefreshingDriver;
  final bool isSavingProfile;
  final bool isUpdatingStatus;
  final bool isUpdatingPassword;
  final bool isDeletingDriver;
  final bool isLoadingDocuments;
  final bool isUploadingDocument;
  final bool isDeletingDocument;
  final bool isLoadingUsers;
  final bool isAssigningUser;
  final Set<String> unassigningUserIds;
  final String? errorMessage;
  final String? sectionErrorMessage;

  /// Effective Driver Updated timestamp resolved as:
  ///   server updatedAt → persisted local edit time → createdAt.
  /// Persisted via AdminDriverTimestampStorage so it survives provider
  /// recreation and app restart. Restored during every loadProfile call.
  final DateTime? profileUpdatedAt;

  bool get hasDriver => driver != null;

  bool get effectiveIsActive =>
      driver?.isActive ?? initialDriver?.isActive ?? false;

  int? get resolvedLinkedUserCount =>
      linkedUserCount ??
      (linkedUsers.isNotEmpty ? linkedUsers.length : null) ??
      (initialDriver?.primaryUserUid.isNotEmpty == true ? 1 : null);

  bool get hasKnownData => driver != null || initialDriver != null;

  bool get hasLoadedUsers => linkedUsers.isNotEmpty || unlinkedUsers.isNotEmpty;

  AdminDriverDetailsState copyWith({
    Object? driver = _unset,
    Object? initialDriver = _unset,
    Object? linkedUserCount = _unset,
    AdminDriverDetailsTab? selectedTab,
    List<AdminDriverDocument>? documents,
    List<AdminDriverDocumentType>? documentTypes,
    List<AdminDriverLinkedUser>? linkedUsers,
    List<AdminDriverLinkedUser>? unlinkedUsers,
    bool? isLoadingDriver,
    bool? isRefreshingDriver,
    bool? isSavingProfile,
    bool? isUpdatingStatus,
    bool? isUpdatingPassword,
    bool? isDeletingDriver,
    bool? isLoadingDocuments,
    bool? isUploadingDocument,
    bool? isDeletingDocument,
    bool? isLoadingUsers,
    bool? isAssigningUser,
    Set<String>? unassigningUserIds,
    Object? errorMessage = _unset,
    Object? sectionErrorMessage = _unset,
    Object? profileUpdatedAt = _unset,
  }) {
    return AdminDriverDetailsState(
      driverId: driverId,
      driver: identical(driver, _unset)
          ? this.driver
          : driver as AdminDriverDetails?,
      initialDriver: identical(initialDriver, _unset)
          ? this.initialDriver
          : initialDriver as AdminDriverListItem?,
      linkedUserCount: identical(linkedUserCount, _unset)
          ? this.linkedUserCount
          : linkedUserCount as int?,
      selectedTab: selectedTab ?? this.selectedTab,
      documents: documents ?? this.documents,
      documentTypes: documentTypes ?? this.documentTypes,
      linkedUsers: linkedUsers ?? this.linkedUsers,
      unlinkedUsers: unlinkedUsers ?? this.unlinkedUsers,
      isLoadingDriver: isLoadingDriver ?? this.isLoadingDriver,
      isRefreshingDriver: isRefreshingDriver ?? this.isRefreshingDriver,
      isSavingProfile: isSavingProfile ?? this.isSavingProfile,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
      isDeletingDriver: isDeletingDriver ?? this.isDeletingDriver,
      isLoadingDocuments: isLoadingDocuments ?? this.isLoadingDocuments,
      isUploadingDocument: isUploadingDocument ?? this.isUploadingDocument,
      isDeletingDocument: isDeletingDocument ?? this.isDeletingDocument,
      isLoadingUsers: isLoadingUsers ?? this.isLoadingUsers,
      isAssigningUser: isAssigningUser ?? this.isAssigningUser,
      unassigningUserIds: unassigningUserIds ?? this.unassigningUserIds,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      sectionErrorMessage: identical(sectionErrorMessage, _unset)
          ? this.sectionErrorMessage
          : sectionErrorMessage as String?,
      profileUpdatedAt: identical(profileUpdatedAt, _unset)
          ? this.profileUpdatedAt
          : profileUpdatedAt as DateTime?,
    );
  }
}
