import CMyHTML

public class MyHTML {
    
    var raw: OpaquePointer
    
    public init(options: Options,
         threadCount: Int,
         queueSize: Int = 4096) throws {
        guard let raw = myhtml_create() else {
            throw Error.cannotCreateBaseStructure
        }
        self.raw = raw
        
        
        let status = myhtml_init(raw, myhtml_options(rawValue: options.rawValue), threadCount, queueSize)
        
        guard status == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: status)
        }
        
    }
    
    init(raw: OpaquePointer) {
        self.raw = raw
    }
    
    deinit {
        assert(myhtml_destroy(raw) == nil, "Unsuccessful destroy")
    }
    

    public enum Options: RawRepresentable {
        public init?(rawValue: UInt32) {
            switch rawValue {
            case MyHTML_OPTIONS_PARSE_MODE_SEPARATELY.rawValue:
                self = .separately
            case MyHTML_OPTIONS_PARSE_MODE_SINGLE.rawValue:
                self = .single
            case MyHTML_OPTIONS_PARSE_MODE_ALL_IN_ONE.rawValue:
                self = .allInOne
            case MyHTML_OPTIONS_DEFAULT.rawValue:
                self = .default
            default:
                return nil
            }
        }
        
        public var rawValue: UInt32 {
            switch self {
            case .separately:
                return MyHTML_OPTIONS_PARSE_MODE_SEPARATELY.rawValue
            case .single:
                return MyHTML_OPTIONS_PARSE_MODE_SINGLE.rawValue
            case .allInOne:
                return MyHTML_OPTIONS_PARSE_MODE_ALL_IN_ONE.rawValue
            case .default:
                return MyHTML_OPTIONS_DEFAULT.rawValue
            }
        }
        
        
        case separately
        case single
        case allInOne
        case `default`
        
    }
    
}
