//
//  RJCarProcedure.m
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJCarProcedure.h"

@implementation RJCarProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    id v = nil;
    if ([values count] == 1) {
        NSArray *list = values[0];
        if ([list isKindOfClass:[NSArray class]]) {
            if ([list count]) {
                v = list[0];
            }
            else {
                tmpError = [NSError rjlispEvalErrorWithString:@"Error car: attempt to apply car to empty list"];
            }
        }
        else {
            tmpError = [NSError rjlispEvalErrorWithString:@"Error car: expected list"];
        }
    }
    else {
        tmpError = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"car" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return v;
}

@end
