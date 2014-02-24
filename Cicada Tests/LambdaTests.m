//
//  LambdaTests.m
//  Cicada
//
//  Created by Robert Jones on 2/23/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RJScheme.h"
#import "RJProcedure.h"
#import "NSError+RJScheme.h"

static RJScheme *_scheme = nil;

@interface LambdaTests : XCTestCase

@end

@implementation LambdaTests

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

- (void)testLambda
{
    NSString *exp = @"(lambda x 1)";
    id actualValue = [_scheme evalString:exp error:nil];
    XCTAssert([actualValue isKindOfClass:[RJProcedure class]], @"%@ != %@", exp, actualValue);

    exp = @"((lambda (x) (+ x x)) 2)";
    NSString *expectedValue = @"4";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);

    exp = @"((lambda (x) (begin (define y x) (* y 2))) 5)";
    expectedValue = @"10";
    actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

- (void)testLambdaErrors
{
    NSError *error = nil;
    NSString *exp = @"(lambda)";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"(lambda (x))";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);

    error = nil;
    exp = @"((lambda (x) (+ x x)))";
    [_scheme evalString:exp error:&error];
    XCTAssertNotNil(error, @"Function should throw error for expression: %@", exp);
}

- (void)testLambdaDisplay
{
    NSString *exp = @"lambda";
    NSString *expectedValue = @"#<Syntax lambda>";
    NSString *actualValue = [_scheme testEvalWithString:exp error:nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"%@ != %@", exp, actualValue);
}

@end
