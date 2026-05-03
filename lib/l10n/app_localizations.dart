import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @tabTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tabTrips;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get tabExpenses;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get filterLive;

  /// No description provided for @filterDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get filterDrafts;

  /// No description provided for @filterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get filterPast;

  /// No description provided for @tripsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trips here yet'**
  String get tripsEmpty;

  /// No description provided for @startNewTrip.
  ///
  /// In en, this message translates to:
  /// **'Start a new trip'**
  String get startNewTrip;

  /// No description provided for @proHeadline.
  ///
  /// In en, this message translates to:
  /// **'Travel without limits'**
  String get proHeadline;

  /// No description provided for @proFeatureMaps.
  ///
  /// In en, this message translates to:
  /// **'Offline maps for 200+ cities'**
  String get proFeatureMaps;

  /// No description provided for @proFeatureUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited trips & members'**
  String get proFeatureUnlimited;

  /// No description provided for @proFeatureNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads, ever'**
  String get proFeatureNoAds;

  /// No description provided for @proFeatureSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get proFeatureSupport;

  /// No description provided for @proPricing.
  ///
  /// In en, this message translates to:
  /// **'14 days free · €4.99/mo after'**
  String get proPricing;

  /// No description provided for @proCardTagline.
  ///
  /// In en, this message translates to:
  /// **'Offline maps, unlimited trips, no ads.'**
  String get proCardTagline;

  /// No description provided for @proCardCta.
  ///
  /// In en, this message translates to:
  /// **'Try Pro free'**
  String get proCardCta;

  /// No description provided for @proCtaPrimary.
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get proCtaPrimary;

  /// No description provided for @proCtaSecondary.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get proCtaSecondary;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get languageEnglish;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get languageThai;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languagePickerTitle;

  /// No description provided for @settingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get settingCurrency;

  /// No description provided for @currencyPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get currencyPickerTitle;

  /// No description provided for @currencyTHB.
  ///
  /// In en, this message translates to:
  /// **'Thai Baht (฿)'**
  String get currencyTHB;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (\$)'**
  String get currencyUSD;

  /// No description provided for @newTripScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get newTripScreenTitle;

  /// No description provided for @newTripFieldName.
  ///
  /// In en, this message translates to:
  /// **'Trip name'**
  String get newTripFieldName;

  /// No description provided for @newTripFieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bali weekend'**
  String get newTripFieldNameHint;

  /// No description provided for @newTripFieldStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get newTripFieldStartDate;

  /// No description provided for @newTripFieldEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get newTripFieldEndDate;

  /// No description provided for @newTripFieldBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get newTripFieldBudget;

  /// No description provided for @newTripFieldBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get newTripFieldBudgetHint;

  /// No description provided for @newTripFieldCover.
  ///
  /// In en, this message translates to:
  /// **'Cover color'**
  String get newTripFieldCover;

  /// No description provided for @newTripButtonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create trip'**
  String get newTripButtonCreate;

  /// No description provided for @newTripValidationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a trip name'**
  String get newTripValidationName;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get profileSectionPreferences;

  /// No description provided for @profileSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get profileSectionAbout;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get profilePersonalInfo;

  /// No description provided for @profilePersonalInfoSub.
  ///
  /// In en, this message translates to:
  /// **'Name, email, location'**
  String get profilePersonalInfoSub;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Itinerary changes, balances'**
  String get profileNotificationsSub;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @profilePrivacySub.
  ///
  /// In en, this message translates to:
  /// **'Who can see your trips'**
  String get profilePrivacySub;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get profileHelpCenter;

  /// No description provided for @profileRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate Tripmate'**
  String get profileRateApp;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogOut;

  /// No description provided for @appearancePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearancePickerTitle;

  /// No description provided for @appearanceSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get appearanceSystem;

  /// No description provided for @appearanceLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceLight;

  /// No description provided for @appearanceDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceDark;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get personalInfoTitle;

  /// No description provided for @personalInfoNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get personalInfoNameLabel;

  /// No description provided for @personalInfoUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get personalInfoUsernameLabel;

  /// No description provided for @personalInfoLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get personalInfoLocationLabel;

  /// No description provided for @personalInfoEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get personalInfoEmailLabel;

  /// No description provided for @personalInfoSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get personalInfoSave;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifTitle;

  /// No description provided for @notifItinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary changes'**
  String get notifItinerary;

  /// No description provided for @notifBalances.
  ///
  /// In en, this message translates to:
  /// **'Balance updates'**
  String get notifBalances;

  /// No description provided for @notifNewMember.
  ///
  /// In en, this message translates to:
  /// **'New trip members'**
  String get notifNewMember;

  /// No description provided for @notifReminders.
  ///
  /// In en, this message translates to:
  /// **'Travel reminders'**
  String get notifReminders;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyTripVisibility.
  ///
  /// In en, this message translates to:
  /// **'Trip visibility'**
  String get privacyTripVisibility;

  /// No description provided for @privacyEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get privacyEveryone;

  /// No description provided for @privacyFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends only'**
  String get privacyFriends;

  /// No description provided for @privacyOnlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get privacyOnlyMe;

  /// No description provided for @privacyShowLocation.
  ///
  /// In en, this message translates to:
  /// **'Show my location'**
  String get privacyShowLocation;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpTitle;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I share a trip?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'Open the trip, tap the share icon, then invite by email or link.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'Can I use Tripmate offline?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'Maps and itineraries are available offline with Tripmate Pro.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Go to Privacy > Account > Delete account. This action is permanent.'**
  String get helpFaq3A;

  /// No description provided for @rateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Tripmate'**
  String get rateTitle;

  /// No description provided for @rateMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Tripmate? Your review helps us grow!'**
  String get rateMessage;

  /// No description provided for @rateCta.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get rateCta;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutTitle;

  /// No description provided for @logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutMessage;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutConfirm;

  /// No description provided for @logOutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logOutCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
