//
//  RJMinusProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJMinusProcedure.h"

@implementation RJMinusProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    float v = 0;
    if ([values count] == 1) {
        v = -[values[0] floatValue];
    }
    else if ([values count] > 1) {
        v = [values[0] floatValue];
        for (NSInteger i = 1; i < [values count]; i++) {
            v -= [values[i] floatValue];
        }
    }
    else {
        tmpError = [NSError rjschemeTooFewArgumentsErrorForSymbol:@"-" atLeast:1 got:0];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
