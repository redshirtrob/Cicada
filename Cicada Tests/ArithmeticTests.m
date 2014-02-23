//
//  ArithmeticTests.m
//  Cicada Tests
//
//  Created by Robert Jones on 2/18/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface ArithmeticTests : XCTestCase

@end

@implementation ArithmeticTests

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

- (void)testAddInteger
{
    NSString *exp = @"(+ 2 2)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @4, @"%@ != %@", exp, number);
}

- (void)testAddFloat
{
    NSString *exp = @"(+ 2.1 2.2)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 4.3f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testAddDisplay
{
    NSString *exp = @"+";
    NSString *expectedValue = @"#<Function +>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testSubtractInteger
{
    NSString *exp = @"(- 2 2)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @0, @"%@ != %@", exp, number);
}

- (void)testSubtractFloat
{
    NSString *exp = @"(- 2.1 1.8)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 0.3f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testSubtractDisplay
{
    NSString *exp = @"-";
    NSString *expectedValue = @"#<Function ->";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testSubtractNegative
{
    NSString *exp = @"(- 2 3)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @(-1), @"%@ != %@", exp, number);
}

- (void)testMultiplyInteger
{
    NSString *exp = @"(* 2 3)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualObjects(number, @6, @"%@ != %@", exp, number);
}

- (void)testMultiplyFloat
{
    NSString *exp = @"(* 2.1 3.2)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 6.72f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testMultiplyDisplay
{
    NSString *exp = @"*";
    NSString *expectedValue = @"#<Function *>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testDivideInteger
{
    NSString *exp = @"(/ 3 3)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 1.0f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testDivideFloat
{
    NSString *exp = @"(/ 6.72 2.1)";
    NSNumber *number = [_scheme evalString:exp error:nil];
    XCTAssertEqualWithAccuracy([number floatValue], 3.2f, FLT_EPSILON, @"%@ !=~ %@", exp, number);
}

- (void)testDivideByZero
{
    NSError *error = nil;
    [_scheme evalString:@"(/ 1 0)" error:&error];
    XCTAssertNotNil(error, @"Divide by zero should throw an error.");
}

- (void)testMDivideDisplay
{
    NSString *exp = @"/";
    NSString *expectedValue = @"#<Function />";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
