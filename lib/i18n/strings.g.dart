
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

	@override StringsGlobalEn get global => StringsGlobalEn._instance;
	@override StringsRegisterScreenEn get registerScreen => StringsRegisterScreenEn._instance;
	@override StringsLoginScreenEn get loginScreen => StringsLoginScreenEn._instance;
	@override StringsSearchScreenEn get searchScreen => StringsSearchScreenEn._instance;
}

class StringsGlobalEn extends StringsGlobal {
	static StringsGlobalEn _instance = StringsGlobalEn();
	static StringsGlobalEn get instance => _instance;

	@override String get error => 'ERROR';
	@override String get warning => 'WARNING';
	@override String get ok => 'OK';
	@override String get close => 'CLOSE';
	@override String get yes => 'YES';
	@override String get NO => 'NO';
	@override String get and => 'and';
	@override String get or => 'or';
	@override String get success => 'SUCCESS';
	@override String get fieldCantBeEmpty => 'This field cannot be left empty.';
}

class StringsRegisterScreenEn extends StringsRegisterScreen {
	static StringsRegisterScreenEn _instance = StringsRegisterScreenEn();
	static StringsRegisterScreenEn get instance => _instance;

	@override String get title => 'Register Screen';
	@override String get register => 'Register';
	@override String get username => 'Username';
	@override String get emailAddress => 'E-Mail';
	@override String get password => 'Password';
	@override String get weakPassword => 'The password provided is too weak.';
	@override String get emailInUse => 'The account already exists for that email.';
	@override String get usernameInUse => 'This username is taken, please pick another one.';
	@override String get emailIsEmpty => 'Email address cannot be empty.';
	@override String get passwordIsEmpty => 'Password cannot be empty.';
	@override String get usernameIsEmpty => 'Username cannot be empty.';
	@override String get emailNotValid => 'Email is not in a valid format.';
	@override String get usernameNotValid => 'Username is not in a valid format.';
	@override String get passwordNotValid => 'Password is not in a valid format.';
	@override String get alreadyHaveAnAccount => 'Already have an account, tap to log in!';
}

class StringsLoginScreenEn extends StringsLoginScreen {
	static StringsLoginScreenEn _instance = StringsLoginScreenEn();
	static StringsLoginScreenEn get instance => _instance;

	@override String get title => 'Login Screen';
	@override String get welcome => 'Welcome to TrackShows App!';
	@override String get username => 'Username:';
	@override String get password => 'Password:';
	@override String get login => 'Login';
	@override String get usernameNotValid => 'Username format is not valid.';
	@override String get cantFindAnAccount => 'There\'s no user with this username.';
	@override String get forgotMyPassword => 'Click to reset your password.';
	@override String get popupPasswordHeader => 'Reset Password';
	@override String get sendMail => 'Reset Password';
	@override String get emailSentIfThereIsACorrespondingUserForEmail => 'If there\'s an account going by this e-mail address, check your inbox for a password reset mail.';
}

class StringsSearchScreenEn extends StringsSearchScreen {
	static StringsSearchScreenEn _instance = StringsSearchScreenEn();
	static StringsSearchScreenEn get instance => _instance;

	@override String get searchForAShow => 'Search for a show.';
	@override String get noShowFound => 'Nothing to show.';
}

class Strings {
	static Strings _instance = Strings();
	static Strings get instance => _instance;

	StringsGlobal get global => StringsGlobal._instance;
	StringsRegisterScreen get registerScreen => StringsRegisterScreen._instance;
	StringsLoginScreen get loginScreen => StringsLoginScreen._instance;
	StringsSearchScreen get searchScreen => StringsSearchScreen._instance;
}

class StringsGlobal {
	static StringsGlobal _instance = StringsGlobal();
	static StringsGlobal get instance => _instance;

	String get error => 'HATA';
	String get warning => 'UYARI';
	String get ok => 'TAMAM';
	String get close => 'VAZGEÇ';
	String get yes => 'EVET';
	String get NO => 'HAYIR';
	String get and => 've';
	String get or => 'veya';
	String get success => 'BAŞARILI';
	String get fieldCantBeEmpty => 'Alan boş bırakılamaz.';
}

class StringsRegisterScreen {
	static StringsRegisterScreen _instance = StringsRegisterScreen();
	static StringsRegisterScreen get instance => _instance;

	String get title => 'Kayıt Ekranı';
	String get register => 'Kayıt Ol';
	String get username => 'Kullanıcı Adı';
	String get emailAddress => 'E-Mail';
	String get password => 'Şifre';
	String get weakPassword => 'Şifreniz yeterince güçlü değil.';
	String get emailInUse => 'Bu mail adresi kullanımdadır.';
	String get usernameInUse => 'Bu kullanıcı adı kullanımdadır, lütfen farklı bir kullanıcı adı seçiniz.';
	String get emailIsEmpty => 'Email adresi boş bırakılamaz.';
	String get passwordIsEmpty => 'Şifre boş bırakılamaz.';
	String get usernameIsEmpty => 'Kullanıcı adı boş bırakılamaz.';
	String get emailNotValid => 'Geçersiz email formatı.';
	String get usernameNotValid => 'Geçersiz kullanıcı adı formatı.';
	String get passwordNotValid => 'Geçersiz şifre formatı.';
	String get alreadyHaveAnAccount => 'Zaten bir hesabın var mı? Giriş Yap!';
}

class StringsLoginScreen {
	static StringsLoginScreen _instance = StringsLoginScreen();
	static StringsLoginScreen get instance => _instance;

	String get title => 'Giriş Ekranı';
	String get welcome => 'DiziTakip\'e Hoşgeldin!';
	String get username => 'Kullanıcı Adı';
	String get password => 'Şifre';
	String get login => 'Giriş Yap';
	String get usernameNotValid => 'Kullanıcı adı geçerli bir formatta değil.';
	String get cantFindAnAccount => 'Bu kullanıcı adı kullanımda değil.';
	String get forgotMyPassword => 'Şifreni sıfırlamak için tıkla.';
	String get popupPasswordHeader => 'Şifre Sıfırla';
	String get sendMail => 'Şifre Sıfırla';
	String get emailSentIfThereIsACorrespondingUserForEmail => 'Bu email adresine ait bir kullanıcı varsa kısa süre içerisinde şifre sıfırlama için mail alacaksınız.';
}

class StringsSearchScreen {
	static StringsSearchScreen _instance = StringsSearchScreen();
	static StringsSearchScreen get instance => _instance;

	String get searchForAShow => 'Dizi ara.';
	String get noShowFound => 'Gösterilecek sonuç bulunamadı.';
}
