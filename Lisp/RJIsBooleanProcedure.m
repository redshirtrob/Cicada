//
//  RJIsBooleanProcedure.m
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJIsBooleanProcedure.h"

@implementation RJIsBooleanProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    BOOL v = NO;
    if ([values count] == 1) {
        if ([values[0] isKindOfClass:[NSNumber class]]) {
            CFNumberRef number = (__bridge CFNumberRef)values[0];
            if (number == (void *)kCFBooleanTrue || number == (void *)kCFBooleanFalse) {
                v = YES;
            }
        }
    }
    else {
        tmpError = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"boolean?" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
