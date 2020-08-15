
// Generated file. Do not edit.

import 'package:flutter/foundation.dart';
import 'package:fast_i18n/fast_i18n.dart';

const String _baseLocale = 'tr';
String _locale = _baseLocale;
Map<String, Strings> _strings = {
	'en': StringsEn.instance,
	'tr': Strings.instance,
};

/// use this to get your translations, e.g. t.someKey.anotherKey
Strings get t {
	return _strings[_locale];
}

class LocaleSettings {

	/// use the locale of the device, fallback to default locale
	static Future<void> useDeviceLocale() async {
		_locale = await FastI18n.findDeviceLocale(_strings.keys.toList(), _baseLocale);
	}

	/// set the locale, fallback to default locale
	static void setLocale(String locale) {
		_locale = FastI18n.selectLocale(locale, _strings.keys.toList(), _baseLocale);
	}

	/// get the current locale
	static String get currentLocale {
		return _locale;
	}

	/// get the base locale
	static String get baseLocale {
		return _baseLocale;
	}

	/// get the supported locales
	static List<String> get locales {
		return _strings.keys.toList();
	}
}

class StringsEn extends Strings {
	static StringsEn _instance = StringsEn();
	static StringsEn get instance => _instance;

	@override StringsLoginScreenEn get loginScreen => StringsLoginScreenEn._instance;
}

class StringsLoginScreenEn extends StringsLoginScreen {
	static StringsLoginScreenEn _instance = StringsLoginScreenEn();
	static StringsLoginScreenEn get instance => _instance;

	@override String get title => 'Login Screen';
	@override String get welcome => 'Welcome to TrackShows App!';
	@override String get username => 'Username:';
	@override String get password => 'Password:';
	@override String get login => 'Login';
}

class Strings {
	static Strings _instance = Strings();
	static Strings get instance => _instance;

	StringsLoginScreen get loginScreen => StringsLoginScreen._instance;
}

class StringsLoginScreen {
	static StringsLoginScreen _instance = StringsLoginScreen();
	static StringsLoginScreen get instance => _instance;

	String get title => 'Giriş Ekranı';
	String get welcome => 'DiziTakip\'e Hoşgeldin!';
	String get username => 'Kullanıcı Adı:';
	String get password => 'Şifre:';
	String get login => 'Giriş Yap';
}
