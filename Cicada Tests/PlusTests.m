//
//  PlusTests.m
//  Cicada
//
//  Created by Robert Jones on 2/23/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface PlusTests : XCTestCase

@end

@implementation PlusTests

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

- (void)testPlusInteger
{
    NSString *exp = @"(+)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @0, @"%@ != %@", exp, number);

    exp = @"(+ 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @2, @"%@ != %@", exp, number);

    exp = @"(+ 2 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @4, @"%@ != %@", exp, number);

    exp = @"(+ 2 2 2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @6, @"%@ != %@", exp, number);
}

- (void)testPlusFloat
{
    NSString *exp = @"(+ 2.1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 2.1f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(+ 2.1 2.2)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 4.3f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(+ 2.1 2.2 3.01)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 7.31f, 3, @"%@ !=~ %@", exp, number);
}

- (void)testPlusErrors
{
    NSError *error = nil;
    NSString *exp = @"(+ 0 '())";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(+ 0 \"\")";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testPlusDisplay
{
    NSString *exp = @"+";
    NSString *expectedValue = @"#<Function +>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
