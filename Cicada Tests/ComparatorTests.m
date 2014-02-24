//
//  ComparatorTests.m
//  Cicada
//
//  Created by Robert Jones on 2/23/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface ComparatorTests : XCTestCase

@end

@implementation ComparatorTests

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

// null?
- (void)testNullPredicate
{
    NSString *exp = @"(null? '())";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(null? 'x)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(null? '(x))";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testNullPredicateErrors
{
    NSError *error = nil;
    NSString *exp = @"(null?)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(null? '() '())";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testNullPredicateDisplay
{
    NSString *exp = @"null?";
    NSString *expectedValue = @"#<Function null?>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// symbol?
- (void)testSymbolPredicate
{
    NSString *exp = @"(symbol? '())";
    NSString *expectedValue = @"#f";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(symbol? 'x)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(symbol? '(x))";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testSymbolPredicateErrors
{
    NSError *error = nil;
    NSString *exp = @"(symbol?)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(symbol? '() '())";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(symbol? yyz)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testSymbolPredicateDisplay
{
    NSString *exp = @"symbol?";
    NSString *expectedValue = @"#<Function symbol?>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// eq?
- (void)testEqPredicate
{
    NSString *exp = @"(eq? 1 1)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(eq? 'x 'x)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(eq? '(x) '(x))";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(eq? '(x) 'x)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(eq? 1 'x)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(eq? \"x\" \"x\")";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(begin (define x \"x\") (define y x) (eq? x y))";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testEqPredicateErrors
{
    NSError *error = nil;
    NSString *exp = @"(eq?)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(eq? 'x)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    exp = @"(eq? 'x 'x 'x)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testEqPredicateDisplay
{
    NSString *exp = @"eq?";
    NSString *expectedValue = @"#<Function eq?>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
