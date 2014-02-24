//
//  SetTests.m
//  Cicada
//
//  Created by Robert Jones on 2/23/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface SetTests : XCTestCase

@end

@implementation SetTests

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

- (void)testSet
{
    NSString *exp = @"(begin (define x 0) (set! x 1) x)";
    NSString *expectedValue = @"1";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testSetErrors
{
    NSError *error = nil;
    NSString *exp = @"(set!)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(set! y)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(set! z 1)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testSetDisplay
{
    NSString *exp = @"set!";
    NSString *expectedValue = @"#<Syntax set!>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
