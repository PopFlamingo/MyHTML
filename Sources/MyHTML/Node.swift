//
//  Node.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

public class Node {
    var raw: OpaquePointer
    init(raw: OpaquePointer) {
        self.raw = raw
    }
    
    public var text: String? {
        guard let rawText = myhtml_node_text(raw, nil) else {
            return nil
        }
        return String(cString: rawText)
    }
    
    public var tagId: Int {
        return myhtml_node_tag_id(raw)
    }
    
    public var children: [Node] {
        return Array(childrenSequence)
    }
    
    // This is closer to the internal representation of
    // the MyHTML C library, might provide better performance
    // if needed, otherwise, convenience array getters enable
    // less verbose code with a performance cost.
    public var childrenSequence: NodeSequence {
        if let rawChild = myhtml_node_child(raw) {
            return NodeSequence(current: Node(raw: rawChild))
        } else {
            return NodeSequence(current: nil)
        }
    }
    
    public var attributes: [Attribute] {
        return Array(attributesSequence)
    }
    
    // This is closer to the internal representation of
    // the MyHTML C library, might provide better performance
    // if needed, otherwise, convenience array getters enable
    // less verbose code with a performance cost.
    public var attributesSequence: Attribute.Sequence {
        if let rawAttribute = myhtml_node_attribute_first(raw) {
            return Attribute.Sequence(current: Node.Attribute(raw: rawAttribute))
        } else {
            return Attribute.Sequence.empty
        }
    }
    
    public var parent: Node? {
        if let rawParent = myhtml_node_parent(raw) {
            return Node(raw: rawParent)
        } else {
            return nil
        }
    }
    
    var namespace: myhtml_namespace_t {
        return myhtml_node_namespace(raw)
    }
    
    var id: Int {
        return myhtml_node_tag_id(raw)
    }
    
    public func isSameNode(as other: Node) -> Bool {
        return self.raw == other.raw
    }
    
    public class Attribute {
        
        var raw: OpaquePointer
        init(raw: OpaquePointer) {
            self.raw = raw
        }
        
        func next() -> Attribute? {
            if let rawNext = myhtml_attribute_next(raw) {
                return Attribute(raw: rawNext)
            } else {
                return nil
            }
        }
        
        func previous() -> Attribute? {
            if let rawPrevious = myhtml_attribute_prev(raw) {
                return Attribute(raw: rawPrevious)
            } else {
                return nil
            }
        }
        
        public var key: String {
            return String(cString: myhtml_attribute_key(raw, nil))
        }
        
        public var value: String? {
            if let rawValue = myhtml_attribute_value(raw, nil) {
                return String(cString: rawValue)
            } else {
                return nil
            }
        }
        
        public struct Sequence: Swift.Sequence, IteratorProtocol {
            
            var current: Attribute?
            
            
            mutating public func next() -> Node.Attribute? {
                if let current = current {
                    defer {
                        self.current = current.next()
                    }
                    return current
                } else {
                    return nil
                }
            }
            
            public static let empty = Sequence(current: nil)
            
            public typealias Element = Attribute
            public typealias Iterator = Sequence
        }
        
        
        
    }
    
}
