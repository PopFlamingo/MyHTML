import XCTest

import MyHTMLTests

var tests = [XCTestCaseEntry]()
tests += MyHTMLTests.allTests()
XCTMain(tests)