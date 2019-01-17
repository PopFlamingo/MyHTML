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
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", contains: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "charset", contains: "utf", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "foo", contains: "bar", caseInsensitive: false).count, 0)
    }
    
    func testContainsAttribute() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildNodesContaining(attribute: "charset").count, 1)
        XCTAssertEqual(tree.getChildNodesContaining(attribute: "foo").count, 0)
    }
    
    func testAttributeStartsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", beginsWith: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", beginsWith: "bar", caseInsensitive: false).count, 0)
    }
    
    
    func testAttributeEndsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", endsWith: "foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", endsWith: "bar", caseInsensitive: false).count, 1)
    }
    
    func testCompareCaseSensitivity() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        
        // Contains attribute
        XCTAssertEqual(tree.getChildNodesContaining(attribute: "charset").count, 1)
        XCTAssertEqual(tree.getChildNodesContaining(attribute: "CHaRSeT").count, 1)
        
        // Contains
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", contains: "fOo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", contains: "fOo", caseInsensitive: true).count, 1)
        
        // Begins
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", beginsWith: "Foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", beginsWith: "Foo", caseInsensitive: true).count, 1)
        
        // Ends
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", endsWith: "Bar", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildNodesWhere(attribute: "class", endsWith: "Bar", caseInsensitive: true).count, 1)
    }
    
    func testGetNodeByName() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.nodesWithName(name: "head").count, 1)
        XCTAssertEqual(tree.nodesWithName(name: "p").count, 3)
        XCTAssertEqual(tree.nodesWithName(name: "P").count, 3)
        XCTAssertEqual(tree.nodesWithName(name: "bar").count, 0)
    }

    static var allTests = [
        ("testAttributeContainsValue", testAttributeContainsValue),
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
        </body>
    </html>
    """
}
