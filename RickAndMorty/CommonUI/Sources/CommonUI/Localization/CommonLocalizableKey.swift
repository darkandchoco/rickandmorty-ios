import Foundation
// swiftlint: disable identifier_name

public enum CommonLocalizableKey: String, LocalizableKey {
    case status_label
    
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
