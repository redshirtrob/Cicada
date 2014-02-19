//
//  RJIsListProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJIsListProcedure.h"

@implementation RJIsListProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    BOOL v = NO;
    if ([values count] == 1) {
        v = [values[0] isKindOfClass:[NSArray class]];
    }
    else {
        tmpError = [NSError rjschemeIncorrectNumberOfArgumentsErrorForSymbol:@"list?" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
