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
    
    func nodesWhere(key: String, contains: String, caseInsensitive: Bool) -> NodeCollection {
        let rawCollection = key.withCString { keyCStr in
            return contains.withCString { value in
                return myhtml_get_nodes_by_attribute_value_whitespace_separated(
                    raw,
                    nil,
                    nil,
                    caseInsensitive,
                    keyCStr,
                    key.utf8.count,
                    value,
                    contains.utf8.count,
                    nil
                )
            }
            
        }
        return NodeCollection(raw: rawCollection!)

    }

    
}
