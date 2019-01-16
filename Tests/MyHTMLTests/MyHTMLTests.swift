import XCTest
import CMyHTML
@testable import MyHTML

final class MyHTMLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let code = """
<!DOCTYPE html>
<html>
<head>
<title>Foo</title>
<meta charset="utf-8">
</head>
<body>
<p class="foo bar">Hey ah ah</p>
<p>Ejkzekj</p><p></p>
</body>
</html>
"""
        do {
            let ctx = try MyHTML(options: .default, threadCount: 1)
            let tree = try Tree(context: ctx, html: code)
            let pNodes = try tree.nodesWithName(name: "p")
            for pNode in pNodes {
                for c in pNode.textChildren {
                    print(c.textContent ?? "Pas de texte")
                }
            }
            
            print(tree.nodesWhere(key: "class", contains: "foo bar", caseInsensitive: false).count)
            
            
        } catch {
            XCTFail("Wasn't able to init, error: \(error)")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
