//
//  ListTests.m
//  Cicada
//
//  Created by Robert Jones on 2/21/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface ListTests : XCTestCase

@end

@implementation ListTests

+ (void)setUp
{
    _scheme = [[RJScheme alloc] init];
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

// list?
- (void)testListPredicate
{
    NSString *exp = @"(list? '())";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list? 'a)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testListPredicateDisplay
{
    NSString *exp = @"list?";
    NSString *expectedValue = @"#<Function list?>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// list
- (void)testList
{
    NSString *exp = @"(list 'a)";
    NSString *expectedValue = @"(a)";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list 'a 'b)";
    expectedValue = @"(a b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list 'a 'b 'c)";
    expectedValue = @"(a b c)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list 'a '(b))";
    expectedValue = @"(a (b))";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list '(a) 'b)";
    expectedValue = @"((a) b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list '(a) '(b))";
    expectedValue = @"((a) (b))";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(list '() '())";
    expectedValue = @"(() ())";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testListDisplay
{
    NSString *exp = @"list";
    NSString *expectedValue = @"#<Function list>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// cons
- (void)testCons
{
    NSString *exp = @"(cons 'a '())";
    NSString *expectedValue = @"(a)";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(cons 'a '(b))";
    expectedValue = @"(a b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(cons '(a) '(b))";
    expectedValue = @"((a) b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testConsDisplay
{
    NSString *exp = @"cons";
    NSString *expectedValue = @"#<Function cons>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// car
- (void)testCar
{
    NSString *exp = @"(car '(a))";
    NSString *expectedValue = @"a";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(car '(a b))";
    expectedValue = @"a";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(car '((a)))";
    expectedValue = @"(a)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testCarDisplay
{
    NSString *exp = @"car";
    NSString *expectedValue = @"#<Function car>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// car
- (void)testCdr
{
    NSString *exp = @"(cdr '(a))";
    NSString *expectedValue = @"()";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(cdr '(a b))";
    expectedValue = @"(b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(cdr '())";
    expectedValue = @"()";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testCdrDisplay
{
    NSString *exp = @"cdr";
    NSString *expectedValue = @"#<Function cdr>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// append

- (void)testAppend
{
    NSString *exp = @"(append '() '())";
    NSString *expectedValue = @"()";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(append '(a) '())";
    expectedValue = @"(a)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(append '() '(a))";
    expectedValue = @"(a)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(append '(a) '(b))";
    expectedValue = @"(a b)";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testAppendErrors
{
    NSError *error = nil;
    NSString *exp = @"(append '())";
    [_scheme testEvalWithString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(append 'a 'b)";
    [_scheme testEvalWithString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(append '() 'a)";
    [_scheme testEvalWithString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(append 'a '())";
    [_scheme testEvalWithString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testAppendDisplay
{
    NSString *exp = @"append";
    NSString *expectedValue = @"#<Function append>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// length
- (void)testLength
{
    NSString *exp = @"(length '(a))";
    NSString *expectedValue = @"1";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(length '())";
    expectedValue = @"0";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testLengthErrors
{
    NSError *error = nil;
    NSString *exp = @"(length)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(length 1)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testLengthDisplay
{
    NSString *exp = @"length";
    NSString *expectedValue = @"#<Function length>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
