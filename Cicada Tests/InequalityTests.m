//
//  InequalityTests.m
//  Cicada
//
//  Created by Robert Jones on 2/22/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface InequalityTests : XCTestCase

@end

@implementation InequalityTests

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

// >
- (void)testGreaterThan
{
    NSString *exp = @"(> 1 0)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(> 0 1)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    NSError *error = nil;
    exp = @"(> 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testGreaterThanDisplay
{
    NSString *exp = @">";
    NSString *expectedValue = @"#<Function >>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// >=
- (void)testGreaterThanOrEqualTo
{
    NSString *exp = @"(>= 1 0)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(>= 0 1)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(>= 0 0)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    NSError *error = nil;
    exp = @"(>= 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testGreaterThanOrEqualToDisplay
{
    NSString *exp = @">=";
    NSString *expectedValue = @"#<Function >=>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// <
- (void)testLessThan
{
    NSString *exp = @"(< 0 1)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(< 1 0)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    NSError *error = nil;
    exp = @"(< 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testLessThanDisplay
{
    NSString *exp = @"<";
    NSString *expectedValue = @"#<Function <>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// <=
- (void)testLessThanOrEqualTo
{
    NSString *exp = @"(<= 0 1)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(<= 1 0)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(<= 0 0)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    NSError *error = nil;
    exp = @"(<= 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testLessThanOrEqualToDisplay
{
    NSString *exp = @"<=";
    NSString *expectedValue = @"#<Function <=>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// =
- (void)testEqualTo
{
    NSString *exp = @"(= 0 0)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(< 1 0)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    NSError *error = nil;
    exp = @"(= 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testEqualToDisplay
{
    NSString *exp = @"=";
    NSString *expectedValue = @"#<Function =>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
