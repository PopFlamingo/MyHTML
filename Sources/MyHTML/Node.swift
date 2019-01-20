import CMyHTML

public class Node {
    
    init(rawNode: OpaquePointer, tree: Tree) {
        self.rawNode = rawNode
        self.tree = tree
    }
    
    var rawNode: OpaquePointer
    var tree: Tree
    
    public var text: String? {
        guard let rawText = myhtml_node_text(rawNode, nil) else {
            return nil
        }
        return String(cString: rawText)
    }
    
    public var children: [Node] {
        return Array(childrenSequence)
    }
    
    // This is closer to the internal representation of
    // the MyHTML C library, might provide better performance
    // if needed, otherwise, convenience array getters enable
    // less verbose code with a performance cost.
    public var childrenSequence: Node.Sequence {
        if let rawChild = myhtml_node_child(rawNode) {
            return Node.Sequence(current: Node(rawNode: rawChild, tree: tree))
        } else {
            return Node.Sequence(current: nil)
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
        if let rawAttribute = myhtml_node_attribute_first(rawNode) {
            return Attribute.Sequence(current: Node.Attribute(raw: rawAttribute))
        } else {
            return Attribute.Sequence.empty
        }
    }
    
    public var parent: Node? {
        if let rawParent = myhtml_node_parent(rawNode) {
            return Node(rawNode: rawParent, tree: tree)
        } else {
            return nil
        }
    }
    
    var namespace: myhtml_namespace_t {
        return myhtml_node_namespace(rawNode)
    }
    
    public var tagId: Int {
        return myhtml_node_tag_id(rawNode)
    }
    
    public func isSameNode(as other: Node) -> Bool {
        return self.rawNode == other.rawNode
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
    
    public class Collection: Swift.Collection {
        
        var rawCollection: UnsafeMutablePointer<myhtml_collection>?
        var tree: Tree!
        
        init(rawCollection: UnsafeMutablePointer<myhtml_collection>, tree: Tree?) {
            self.rawCollection = rawCollection
            self.tree = tree
        }
        
        private init(raw: UnsafeMutablePointer<myhtml_collection>?, tree: Tree?) {
            self.rawCollection = raw
            self.tree = tree
        }
        
        static let empty = Node.Collection(raw: nil, tree: nil)
        
        deinit {
            assert(myhtml_collection_destroy(rawCollection) == nil, "Unsuccessful destroy")
        }
        
        public var count: Int {
            return rawCollection?.pointee.length ?? 0
        }
        
        public func index(after i: Int) -> Int {
            return i+1
        }
        
        public subscript(position: Int) -> Node {
            guard let raw = self.rawCollection,
                position >= startIndex && position < endIndex else {
                    fatalError("Out of bound access")
            }
            return Node(rawNode: raw.pointee.list[position]!, tree: tree)
        }
        
        public var startIndex: Int = 0
        
        public var endIndex: Int {
            return rawCollection?.pointee.length ?? 0
        }
        
        
        
        public typealias Element = Node
        public typealias Index = Int
        
    }
    
    public struct Sequence: Swift.Sequence, IteratorProtocol {
        
        init(current: Node?) {
            self.current = current
        }
        
        var current: Node?
        
        public typealias Element = Node
        public typealias Iterator = Node.Sequence
        public mutating func next() -> Node? {
            if let current = current {
                defer {
                    if let rawNext = myhtml_node_next(current.rawNode) {
                        self.current = Node(rawNode: rawNext, tree: current.tree)
                    } else {
                        self.current = nil
                    }
                }
                return current
            } else {
                return nil
            }
        }
    }

    
}
