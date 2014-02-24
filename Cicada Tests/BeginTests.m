//
//  BeginTests.m
//  Cicada
//
//  Created by Robert Jones on 2/23/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface BeginTests : XCTestCase

@end

@implementation BeginTests

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

- (void)testBegin
{
    NSString *exp = @"(begin)";
    NSString *expectedValue = nil;
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(begin '())";
    expectedValue = @"()";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(begin (define x 1) x)";
    expectedValue = @"1";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"(begin (define x 1) (set! x 2) x)";
    expectedValue = @"2";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testBeginDisplay
{
    NSString *exp = @"begin";
    NSString *expectedValue = @"#<Syntax begin>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
