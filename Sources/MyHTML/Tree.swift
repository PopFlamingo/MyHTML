import CMyHTML

class Tree {
    var raw: OpaquePointer
    init(context: MyHTML, html: String) throws {
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
    
    var htmlNode: Node? {
        guard let rawNode = myhtml_tree_get_node_html(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    var headNode: Node? {
        guard let rawNode = myhtml_tree_get_node_head(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    var bodyNode: Node? {
        guard let rawNode = myhtml_tree_get_node_body(raw) else { return nil }
        return Node(raw: rawNode)
    }
    
    
    func nodesWithName(name: String) throws -> NodeCollection {
        let rawPtr = name.withCString { cStr in
            myhtml_get_nodes_by_name(raw, nil, cStr, name.utf8.count, nil)
        }
        return NodeCollection(raw: rawPtr!)
    }
    
    func getChildNodesContaining(attribute: String) throws -> NodeCollection {
        let rawPtr = attribute.withCString { cStr in
            myhtml_get_nodes_by_attribute_key(raw, nil, nil, cStr, attribute.utf8.count, nil)
        }
        return NodeCollection(raw: rawPtr!)
    }

    
    func getChildNodesWhere(attribute: String,
                            contains value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_contain(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        return NodeCollection(raw: rawCollection!)
    }
    
    func getChildNodesWhere(attribute: String,
                            beginsWith value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_begin(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        return NodeCollection(raw: rawCollection!)
    }
    
    func getChildNodesWhere(attribute: String,
                            endWith value: String,
                            caseInsensitive: Bool,
                            scopeNode: Node? = nil) -> NodeCollection {
        let rawCollection = attribute.withCString { attributeCStr in
            value.withCString { valueCStr in
                myhtml_get_nodes_by_attribute_value_end(
                    raw,nil, scopeNode?.raw, caseInsensitive, attributeCStr, attribute.utf8.count, valueCStr, value.utf8.count, nil)
            }
        }
        return NodeCollection(raw: rawCollection!)
    }
    

    
}
