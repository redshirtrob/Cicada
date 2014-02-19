//
//  RJIsNullProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJIsNullProcedure.h"

@implementation RJIsNullProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    BOOL v = NO;
    if ([values count] == 1) {
        v = ([values[0] isKindOfClass:[NSArray class]] && ![(NSArray *)values[0] count]);
    }
    else {
        tmpError = [NSError rjschemeIncorrectNumberOfArgumentsErrorForSymbol:@"null?" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return @(v);
}

@end
