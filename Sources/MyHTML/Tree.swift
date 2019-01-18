import CMyHTML

public class Tree {
    var raw: OpaquePointer
    public init(context: MyHTML, html: String) throws {
        guard let raw = myhtml_tree_create() else {
            throw Error.cannotCreateBaseStructure
        }
        self.raw = raw
        let status = myhtml_tree_init(raw, context.raw)
        guard status == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: status)
        }
        
        let parseResult = html.withCString { strPtr in
            myhtml_parse(raw, MyENCODING_UTF_8, strPtr, html.utf8.count)
        }
        guard parseResult == MyHTML_STATUS_OK.rawValue else {
            throw Error.statusError(rawValue: parseResult)
        }
        
    }
    
    deinit {
        myhtml_tree_destroy(raw)
    }
    
    public var htmlNode: Node? {
        guard let rawNode = myhtml_tree_get_node_html(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    public var headNode: Node? {
        guard let rawNode = myhtml_tree_get_node_head(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    public var bodyNode: Node? {
        guard let rawNode = myhtml_tree_get_node_body(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    
    public func getChildNodes(named name: String) -> NodeCollection {
        let rawPtr = name.withCString { cStr in
            myhtml_get_nodes_by_name(raw, nil, cStr, name.utf8.count, nil)
        }
        if let rawPtr = rawPtr {
            return NodeCollection(raw: rawPtr)
        } else {
            return NodeCollection.empty
        }
        
    }
    
    public func getChildNodesContaining(attribute: String) -> NodeCollection {
        let rawPtr = attribute.withCString { cStr in
            myhtml_get_nodes_by_attribute_key(raw, nil, nil, cStr, attribute.utf8.count, nil)
        }
        if let rawPtr = rawPtr {
            return NodeCollection(raw: rawPtr)
        } else {
            return NodeCollection.empty
        }
    }

    
    public func getChildNodesWhere(attribute: String,
                            contains value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_contain(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return NodeCollection(raw: rawCollection)
        } else {
            return NodeCollection.empty
        }
    }
    
    public func getChildNodesWhere(attribute: String,
                            beginsWith value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_begin(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return NodeCollection(raw: rawCollection)
        } else {
            return NodeCollection.empty
        }
    }
    
    public func getChildNodesWhere(attribute: String,
                            endsWith value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_end(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        if let rawCollection = rawCollection {
            return NodeCollection(raw: rawCollection)
        } else {
            return NodeCollection.empty
        }
    }
    

    
}
