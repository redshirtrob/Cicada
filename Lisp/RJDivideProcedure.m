//
//  RJDivideProcedure.m
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJDivideProcedure.h"

@implementation RJDivideProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    float v = 1;
    if ([values count]) {
        v = [values[0] floatValue];
        for (NSInteger i = 1; i < [values count]; i++) {
            float divisor = [values[i] floatValue];
            if (divisor != 0) {
                v /= [values[i] floatValue];
            }
            else {
                tmpError = [NSError rjlispEvalErrorWithString:@"Error /: attempt to divide by zero"];
            }
        }
    }
    else {
        tmpError = [NSError rjlispTooFewArgumentsErrorForSymbol:@"/" atLeast:1 got:0];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
