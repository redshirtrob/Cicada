//
//  MultiplyTests.m
//  Cicada
//
//  Created by Robert Jones on 2/25/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface MultiplyTests : XCTestCase

@end

@implementation MultiplyTests

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

- (void)testMultiplyInteger
{
    NSString *exp = @"(*)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @1, @"%@ != %@", exp, number);

    exp = @"(* 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @2, @"%@ != %@", exp, number);

    exp = @"(* 2 3)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @6, @"%@ != %@", exp, number);

    exp = @"(* 2 3 4)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @24, @"%@ != %@", exp, number);

    exp = @"(* 2 3 4 -1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @(-24), @"%@ != %@", exp, number);
}

- (void)testMultiplyFloat
{
    NSString *exp = @"(* 1.1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.1f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(* 1.1 1.1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.21f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(* 1.1 1.1 1.1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.331f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(* 1.1 1.1 -1.1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], -1.331f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testMultiplyErrors
{
    NSError *error = nil;
    NSString *exp = @"(* 0 '())";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(* 0 \"\")";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testMultiplyDisplay
{
    NSString *exp = @"*";
    NSString *expectedValue = @"#<Function *>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
