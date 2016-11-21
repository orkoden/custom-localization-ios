
import UIKit

let allLangs = Locale.isoLanguageCodes
allLangs.count
let allRegions = Locale.isoRegionCodes
allRegions.count
let allCurrencies = Locale.isoCurrencyCodes
allCurrencies.count
let allCountries = Locale.commonISOCurrencyCodes
allCountries.count
let allIds = Locale.availableIdentifiers
allIds.count
let preferredLangs = Locale.preferredLanguages
preferredLangs.count





// date and numbers
let numbForm = NumberFormatter()
numbForm.numberStyle = .currencyAccounting
let dateForm = DateFormatter()
dateForm.dateStyle = .long

let en = Locale(identifier: "en")
let pl = Locale(identifier: "pl")

let someLoc = allIds[313] // 739
let loc = Locale(identifier: someLoc)
pl.localizedString(forLanguageCode: loc.languageCode!)
// Pre iOS 10.0 and NSLocale
(en as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: loc.languageCode!)
// language in its own language
loc.localizedString(forLanguageCode: loc.languageCode!)
if let reg = loc.regionCode {
    en.localizedString(forRegionCode: reg)
    pl.localizedString(forRegionCode: reg)
    loc.localizedString(forRegionCode: reg)
}
loc.currencySymbol
loc.decimalSeparator
loc.alternateQuotationBeginDelimiter
loc.groupingSeparator
loc.calendar

numbForm.locale = loc
numbForm.string(from: 2342.99)
dateForm.locale = loc
dateForm.string(from: Date())
dateForm.calendar = Calendar(identifier: .islamic)
dateForm.string(from: Date())





// Choosing the best localization from 2 lists
let appLangs = ["de", "pl", "en"]
// use Locale.preferredLanguages to get these
let userLangs = ["he", "pl"]
Bundle.preferredLocalizations(from: appLangs,
                              forPreferences: userLangs)

let appLocales = appLangs.map {Locale(identifier: $0)}
let langInLang = appLocales.flatMap
    {$0.localizedString(forLanguageCode: $0.languageCode!)}






// Representing your languages
enum AppLanguage: String {
    case polish = "pl"
    case german = "de"
    case undefined // maybe?
    
    static let all: [AppLanguage] = [.polish, .german]
    
    static func bestApplanguage() -> AppLanguage {
        let preferredLangs = Bundle.preferredLocalizations(from: all.map { $0.identifier },
                                      forPreferences: userLangs)
        return preferredLangs.first.flatMap { AppLanguage(rawValue: $0) } ?? .polish
    }
    
    init?(locale: Locale) {
        self.init(rawValue: locale.identifier)
    }
    
    var tableName: String {
        return self.rawValue
    }
    
    var identifier: String {
        return self.rawValue
    }
}

extension Locale {
    init(applanguage: AppLanguage) {
        self.init(identifier: applanguage.identifier)
    }
}

class AppLanguageManager {
    let languageChangedNotification = NSNotification.Name(rawValue: "LanguageChangedNotification")

    var current: AppLanguage = .polish {
        didSet{
            if oldValue != current {
                // save to defaults and post notification
                NotificationCenter.default.post(name: languageChangedNotification, object: nil)
            }
        }
    }
}

var languageManager = AppLanguageManager()
languageManager.current = .german

func AppLocalizedString(forKey key: String) -> String {
    let language = languageManager.current
    return Bundle.main.localizedString(forKey: key, value: nil,
                                           table: language.tableName) // .strings file
}









// use placeholders to change order in strings
let template = "First: %2$@ Second: %1$@"
let stringWithF = String(format: template, "one", "two")


