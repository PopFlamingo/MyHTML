import CMyHTML

public enum Error: Swift.Error {
    case cannotCreateBaseStructure
    case statusError(rawValue: UInt32)
}

extension myhtml_namespace_t: Equatable {
    public static func ==(lhs: myhtml_namespace_t, rhs: myhtml_namespace_t) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
