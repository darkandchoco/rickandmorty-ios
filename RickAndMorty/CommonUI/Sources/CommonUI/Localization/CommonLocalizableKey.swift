import Foundation
// swiftlint: disable identifier_name

public enum CommonLocalizableKey: String, LocalizableKey {
    case status_label
    case gender_label
    case name_label
    case origin_label
    case species_label
    case type_label
    case location_label
    
    var tableName: String {
        "Common"
    }
    
    public func localize() -> String {
        return NSLocalizedString(self.rawValue, tableName: tableName, bundle: .common, comment: "")
    }
    
    public func localizeWith(arguments: CVarArg...) -> String {
           return String(format: self.localize(), arguments: arguments)
    }
}

extension Bundle {
    public static let common = Bundle.module
}

protocol LocalizableKey {
    var tableName: String { get }
    func localize() -> String
    func localizeWith(arguments: CVarArg...) -> String
}
