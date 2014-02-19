//
//  RJGreaterThanEqualProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJGreaterThanEqualProcedure.h"

@implementation RJGreaterThanEqualProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    BOOL v = NO;
    if ([values count] == 2) {
        v = ([values[0] floatValue] >= [values[1] floatValue]);
    }
    else {
        tmpError = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@">=" expected:2 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
