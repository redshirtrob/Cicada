//
//  DivideTests.m
//  Cicada
//
//  Created by Robert Jones on 2/25/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface DivideTests : XCTestCase

@end

@implementation DivideTests

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

- (void)testDivideInteger
{
    NSString *exp = @"(/ 1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @1, @"%@ != %@", exp, number);

    exp = @"(/ 4 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 2.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(/ 8 2 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 2.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(/ 5 4)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.25f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testDivideFloat
{
    NSString *exp = @"(/ 1.0)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(/ 4.2 2.1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 2.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(/ 4.2 2.1 0.4)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 5.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testDivideErrors
{
    NSError *error = nil;
    NSString *exp = @"(/ 0 '())";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(/ 0 \"\")";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(/ 1 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(/ 1.0 0)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(/)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

@end
