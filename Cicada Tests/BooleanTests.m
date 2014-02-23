//
//  BooleanTests.m
//  Cicada
//
//  Created by Robert Jones on 2/22/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface BooleanTests : XCTestCase

@end

@implementation BooleanTests

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

// #t
- (void)testTrueDisplay
{
    NSString *exp = @"#t";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// #f
- (void)testFalseDisplay
{
    NSString *exp = @"#f";
    NSString *expectedValue = @"#f";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// not
- (void)testNot
{
    NSString *exp = @"(not #t)";
    NSString *expectedValue = @"#f";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(not #f)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testNotDisplay
{
    NSString *exp = @"not";
    NSString *expectedValue = @"#<Function not>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

// boolean?
- (void)testBooleanPredicate
{
    NSString *exp = @"(boolean? #t)";
    NSString *expectedValue = @"#t";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(boolean? #f)";
    expectedValue = @"#t";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(boolean? 1)";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(boolean? '())";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(boolean? \"String\")";
    expectedValue = @"#f";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testBooleanPredicateDisplay
{
    NSString *exp = @"boolean?";
    NSString *expectedValue = @"#<Function boolean?>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
