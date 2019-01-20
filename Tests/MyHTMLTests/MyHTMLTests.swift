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
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", contains: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildren(whereAttribute: "charset", contains: "utf", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildren(whereAttribute: "foo", contains: "bar", caseInsensitive: false).count, 0)
    }
    
    func testContainsAttribute() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildren(containingAttribute: "charset").count, 1)
        XCTAssertEqual(tree.getChildren(containingAttribute: "foo").count, 0)
    }
    
    func testAttributeStartsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", beginsWith: "foo", caseInsensitive: false).count, 1)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", beginsWith: "bar", caseInsensitive: false).count, 0)
    }
    
    func testAttributeEndsWith() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", endsWith: "foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", endsWith: "bar", caseInsensitive: false).count, 1)
    }
    
    func testCompareCaseSensitivity() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        
        // Contains attribute
        XCTAssertEqual(tree.getChildren(containingAttribute: "charset").count, 1)
        XCTAssertEqual(tree.getChildren(containingAttribute: "CHaRSeT").count, 1)
        
        // Contains
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", contains: "fOo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", contains: "fOo", caseInsensitive: true).count, 1)
        
        // Begins
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", beginsWith: "Foo", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", beginsWith: "Foo", caseInsensitive: true).count, 1)
        
        // Ends
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", endsWith: "Bar", caseInsensitive: false).count, 0)
        XCTAssertEqual(tree.getChildren(whereAttribute: "class", endsWith: "Bar", caseInsensitive: true).count, 1)
    }
    
    func testGetNodeByName() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildNodes(named: "head").count, 1)
        XCTAssertEqual(tree.getChildNodes(named: "p").count, 3)
        XCTAssertEqual(tree.getChildNodes(named: "P").count, 3)
        XCTAssertEqual(tree.getChildNodes(named: "bar").count, 0)
    }
    
    func testGetNodeTextContent() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(Array(tree.getChildNodes(named: "title").first!.children).first?.textContent, "Foo")
        XCTAssertEqual(Array(tree.getChildNodes(named: "p")[1].children).first?.textContent, "Cools")
        XCTAssertEqual(Array(tree.getChildNodes(named: "p")[2].children).first?.textContent, nil)
    }
    
    func testNodeIdentity() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        let head1 = tree.getChildNodes(named: "head")[0]
        let head2 = tree.getChildNodes(named: "head")[0]
        XCTAssertTrue(head1.isSameNode(as: head2))
        
        let divs = tree.getChildNodes(named: "div")
        XCTAssertFalse(divs[0].isSameNode(as: divs[1]))
    }
    
    func testAttributesCount() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        let paragraphs = tree.getChildNodes(named: "p")
        XCTAssertEqual(paragraphs[0].attributes.count, 1)
        let divs = tree.getChildNodes(named: "div")
        XCTAssertEqual(divs[1].attributes.count, 2)
    }
    
    func testAttributesValues() throws {
        let tree = try Tree(context: myHTML, html: sampleCodeA)
        XCTAssertEqual(tree.getChildNodes(named: "img")[0].attributes[0].value,
                       "automn.jpg")
        XCTAssertEqual(tree.getChildNodes(named: "img")[0].attributes[1].value,
                       nil)
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
        ("testAttributesValues", testAttributesValues)
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
}
