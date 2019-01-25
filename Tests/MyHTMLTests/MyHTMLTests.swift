import XCTest
import CMyHTML
@testable import MyHTML

final class MyHTMLTests: XCTestCase {
    
    var myHTML: MyHTML!
    
    override func setUp() {
        self.myHTML = try! MyHTML(options: .single, threadCount: 1)
    }
    
    override func tearDown() {
        self.myHTML = nil
    }
    
    func testAttributeContainsValue() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(whereAttribute: "class", contains: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.children(whereAttribute: "charset", contains: "utf", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.children(whereAttribute: "foo", contains: "bar", caseInsensitive: false).count, 0)
    }
    
    func testContainsAttribute() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(containingAttribute: "charset").count, 1)
        XCTAssertEqual(tree.children(containingAttribute: "charsetz").count, 0)
        XCTAssertEqual(tree.children(containingAttribute: "foo").count, 0)
    }
    
    func testAttributeStartsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "bar", caseInsensitive: false).count, 0)
    }
    
    func testAttributeEndsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "bar", caseInsensitive: false).count, 1)
    }
    
    func testCompareCaseSensitivity() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        
        // Contains attribute
        XCTAssertEqual(tree.children(containingAttribute: "charset").count, 1)
        XCTAssertEqual(tree.children(containingAttribute: "CHaRSeT").count, 1)
        
        // Contains
        XCTAssertEqual(tree.children(whereAttribute: "class", contains: "fOo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.children(whereAttribute: "class", contains: "fOo", caseInsensitive: true).count, 1)
        
        // Begins
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "Foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "Foo", caseInsensitive: true).count, 1)
        
        // Ends
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "Bar", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "Bar", caseInsensitive: true).count, 1)
    }
    
    func testGetNodeByName() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(named: "head").count, 1)
        XCTAssertEqual(tree.children(named: "p").count, 3)
        XCTAssertEqual(tree.children(named: "P").count, 3)
        XCTAssertEqual(tree.children(named: "bar").count, 0)
    }
    
    func testGetNodeTextContent() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(Array(tree.children(named: "title").first!.children).first?.text, "Foo")
        XCTAssertEqual(Array(tree.children(named: "p")[1].children).first?.text, "Cools")
        XCTAssertEqual(Array(tree.children(named: "p")[2].children).first?.text, nil)
    }
    
    func testNodeIdentity() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        let head1 = tree.children(named: "head")[0]
        let head2 = tree.children(named: "head")[0]
        XCTAssertTrue(head1.isSameNode(as: head2))
        
        let divs = tree.children(named: "div")
        XCTAssertFalse(divs[0].isSameNode(as: divs[1]))
    }
    
    func testAttributesCount() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        let paragraphs = tree.children(named: "p")
        XCTAssertEqual(paragraphs[0].attributes.count, 1)
        let divs = tree.children(named: "div")
        XCTAssertEqual(divs[1].attributes.count, 2)
    }
    
    func testAttributesValues() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.children(named: "img")[0].attributes[0].value,
                       "automn.jpg")
        XCTAssertEqual(tree.children(named: "img")[0].attributes[1].value,
                       nil)
    }
    
    
    func testRightTimeContextDeinit() throws {
        func create() throws -> (Tree, OpaquePointer) {
            let fooHtml = try MyHTML(options: .single, threadCount: 1)
            return try (Tree(context: fooHtml, html: sampleCodeA), fooHtml.rawMyHTML)
        }
        
        let (tree, htmlPointer) = try create()
        let htmlPointerThroughC: OpaquePointer? = myhtml_tree_get_myhtml(tree.rawTree)
        XCTAssertNotNil(htmlPointerThroughC)
        XCTAssertEqual(htmlPointer, htmlPointerThroughC)
        let rawTree = myhtml_tree_create()
        myhtml_tree_init(rawTree, htmlPointerThroughC) // Should fail if early free
        myhtml_tree_destroy(rawTree)
    }
    
    func testNodeParentGetter() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertTrue(tree.children(named: "p")[0].parent!.isSameNode(as: tree.bodyNode!))
        XCTAssertNil(tree.htmlNode!.parent!.parent)
    }
    
    func testRightTimeTreeDeinit() throws {
        let node: Node
        do {
            let tree = try Tree(context: myHTML, html: sampleCodeA)
            node = tree.children(named: "p")[0]
        }
        let rawTree = myhtml_node_tree(node.rawNode)
        let name = "id"
        name.withCString { cStr in
            XCTAssertNotNil(myhtml_get_nodes_by_attribute_key(rawTree, nil, nil, cStr, name.utf8.count, nil))
        }
    }
    
    
    func testScopeNode() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeB)
        let firstDiv = tree.children(whereAttribute: "id", contains: "firstDiv")[0]
        XCTAssertEqual(tree.children(whereAttribute: "class", contains: "bar").count, 3)
        XCTAssertEqual(tree.children(whereAttribute: "class", contains: "bar", scope: firstDiv).count, 2)
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "foo", caseInsensitive: false, scope: tree.headNode!).count, 0)
        XCTAssertEqual(tree.children(whereAttribute: "class", beginsWith: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "bar", caseInsensitive: false).count, 3)
        XCTAssertEqual(tree.children(whereAttribute: "class", endsWith: "bar", caseInsensitive: false, scope: firstDiv).count, 2)
    }
    
    
    func testNodeId() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.htmlNode!.parent!.tagId, 0)
    }
    
    static var allTests = [
        ("testAttributeContainsValue", testAttributeContainsValue),
        ("testContainsAttribute", testContainsAttribute),
        ("testAttributeStartsWith", testAttributeStartsWith),
        ("testAttributeEndsWith", testAttributeEndsWith),
        ("testCompareCaseSensitivity", testCompareCaseSensitivity),
        ("testGetNodeByName", testGetNodeByName),
        ("testGetNodeTextContent", testGetNodeTextContent),
        ("testNodeIdentity", testNodeIdentity),
        ("testAttributesCount", testAttributesCount),
        ("testAttributesValues", testAttributesValues),
        ("testRightTimeContextDeinit", testRightTimeContextDeinit),
        ("testNodeParentGetter", testNodeParentGetter),
        ("testRightTimeTreeDeinit", testRightTimeTreeDeinit),
        ("testScopeNode", testScopeNode),
        ("testNodeId", testNodeId)
    ]
    
    let sampleCodeA = """
    <!DOCTYPE html>
    <html>
        <head>
            <title>Foo</title>
            <meta charset="utf-8">
        </head>
        <body>
            <p class="foo bar">Hey</p>
            <p>Cools</p>
            <p></p>
            <div></div>
            <div id="hey" class="amazing"></div>
            <img src="automn.jpg" hidden>
        </body>
    </html>
    """
    
    let sampleCodeB = """
    <!DOCTYPE html>
    <html>
        <head>
            <title>Foo</title>
            <meta charset="utf-8">
        </head>
        <body>
            <div id="firstDiv">
                <p class="foo bar">Hey</p>
                <p class="baz bar">Cools</p>
            </div>
            <p></p>
            <div></div>
            <div id="hey" class="amazing bar"></div>
            <img src="automn.jpg" hidden>
        </body>
    </html>
    """
}
