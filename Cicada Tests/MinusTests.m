//
//  MinusTests.m
//  Cicada
//
//  Created by Robert Jones on 2/24/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface MinusTests : XCTestCase

@end

@implementation MinusTests

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

- (void)testMinusInteger
{
    NSString *exp = @"(- 1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @(-1), @"%@ != %@", exp, number);

    exp = @"(- 2 1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @1, @"%@ != %@", exp, number);

    exp = @"(- 5 2 1)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @2, @"%@ != %@", exp, number);

    exp = @"(- 2 3)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @(-1), @"%@ != %@", exp, number);
}

- (void)testSubtractFloat
{
    NSString *exp = @"(- 2.1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], -2.1f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(- 2.1 1.8)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 0.3f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(- 6.1 2.1 1.8)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 2.2f, FLT_EPSILON, @"%@ !=~ %@", exp, number);

    exp = @"(- 2.1 2.8)";
    number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], -0.7f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testSubtractDisplay
{
    NSString *exp = @"-";
    NSString *expectedValue = @"#<Function ->";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
