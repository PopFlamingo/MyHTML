import CMyHTML

public class Tree {
    
    public init(context: MyHTML, html: String) throws {
        guard let rawTree = myhtml_tree_create() else {
            throw Error.cannotCreateBaseStructure
        }
        self.rawTree = rawTree
        self.context = context
        let status = myhtml_tree_init(rawTree, context.rawMyHTML)
        guard status == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: status)
        }
        
        let parseResult = html.withCString { strPtr in
            myhtml_parse(rawTree, MyENCODING_UTF_8, strPtr, html.utf8.count)
        }
        guard parseResult == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: parseResult)
        }
        
    }
    
    deinit {
        assert(myhtml_tree_destroy(rawTree) == nil, "Unsuccessful destroy")
    }
    
    
    var rawTree: OpaquePointer
    
    /// The context is a private variable that keeps MyHTML ref count > 0
    /// as long as it is needed, this way, no early call to its C free
    /// functions is done. Test `testRightTimeContextDeinit` attempts
    /// to catch cases where this wouldn't be done correctly;
    private var context: MyHTML
    
    public var htmlNode: Node? {
        guard let rawNode = myhtml_tree_get_node_html(rawTree) else { return nil }
        return Node(rawNode: rawNode, tree: self)
    }
    
    public var headNode: Node? {
        guard let rawNode = myhtml_tree_get_node_head(rawTree) else { return nil }
        return Node(rawNode: rawNode, tree: self)
    }
    
    public var bodyNode: Node? {
        guard let rawNode = myhtml_tree_get_node_body(rawTree) else { return nil }
        return Node(rawNode: rawNode, tree: self)
    }
    
    
    public func children(named name: String) -> Node.Collection {
        let rawPtr = name.withCString { cStr in
            myhtml_get_nodes_by_name(rawTree, nil, cStr, name.utf8.count, nil)
        }
        if let rawPtr = rawPtr {
            return Node.Collection(rawCollection: rawPtr, tree: self)
        } else {
            return Node.Collection.empty
        }
        
    }
    
    public func children(containingAttribute attribute: String,
                         scope: Node? = nil) -> Node.Collection {
        let rawPtr = attribute.withCString { cStr in
            myhtml_get_nodes_by_attribute_key(rawTree, nil, scope?.rawNode, cStr, attribute.utf8.count, nil)
        }
        if let rawPtr = rawPtr {
            return Node.Collection(rawCollection: rawPtr, tree: self)
        } else {
            return Node.Collection.empty
        }
    }
    
    
    public func children(whereAttribute attribute: String,
                            contains value: String,
                            caseInsensitive: Bool = false,
                            scope: Node? = nil) -> Node.Collection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_contain(
                    rawTree,nil, scope?.rawNode, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return Node.Collection(rawCollection: rawCollection, tree: self)
        } else {
            return Node.Collection.empty
        }
    }
    
    public func children(whereAttribute attribute: String,
                            beginsWith value: String,
                            caseInsensitive: Bool = false,
                            scope: Node? = nil) -> Node.Collection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_begin(
                    rawTree, nil, scope?.rawNode, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return Node.Collection(rawCollection: rawCollection, tree: self)
        } else {
            return Node.Collection.empty
        }
    }
    
    public func children(whereAttribute attribute: String,
                            endsWith value: String,
                            caseInsensitive: Bool = false,
                            scope: Node? = nil) -> Node.Collection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_end(
                    rawTree, nil, scope?.rawNode, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return Node.Collection(rawCollection: rawCollection, tree: self)
        } else {
            return Node.Collection.empty
        }
    }
    
    
    
}
