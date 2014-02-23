//
//  RJLengthProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJLengthProcedure.h"

@implementation RJLengthProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    NSNumber *v = nil;
    if ([values count]) {
        if ([values[0] isKindOfClass:[NSArray class]]) {
            v = @([values[0] count]);
        }
        else {
            tmpError = [NSError rjschemeEvalErrorWithString:@"Error length: expected list"];
        }
    }
    else {
        tmpError = [NSError rjschemeIncorrectNumberOfArgumentsErrorForSymbol:@"length" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return v;
}

@end
