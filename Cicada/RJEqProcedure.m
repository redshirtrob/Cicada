//
//  RJEqProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJEqProcedure.h"

@implementation RJEqProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    BOOL v = NO;
    if ([values count] == 2) {
        if ([values[0] isKindOfClass:[NSNumber class]] && [values[1] isKindOfClass:[NSNumber class]]) {
            v = ([values[0] floatValue] == [values[1] floatValue]);
        }
        else {
            v = (values[0] == values[1]);
        }
    }
    else {
        tmpError = [NSError rjschemeIncorrectNumberOfArgumentsErrorForSymbol:@"eq?" expected:2 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
