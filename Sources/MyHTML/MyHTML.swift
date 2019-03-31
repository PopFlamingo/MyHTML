/*
 Copyright 2019 Trevör Anne Denise
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import CMyHTML

public class MyHTML {
    
    var rawMyHTML: OpaquePointer
    
    public init(options: Options,
                threadCount: Int,
                queueSize: Int = 4096) throws {
        guard let raw = myhtml_create() else {
            throw Error.cannotCreateBaseStructure
        }
        self.rawMyHTML = raw
        
        
        let status = myhtml_init(raw, myhtml_options(rawValue: options.rawValue), threadCount, queueSize)
        
        guard status == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: status)
        }
        
    }
    
    init(rawMyHTML: OpaquePointer) {
        self.rawMyHTML = rawMyHTML
    }
    
    deinit {
        assert(myhtml_destroy(rawMyHTML) == nil, "Unsuccessful destroy")
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
