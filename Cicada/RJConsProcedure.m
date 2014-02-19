//
//  RJConsProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJConsProcedure.h"

@implementation RJConsProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    id v = nil;
    if ([values count] == 2) {
        if ([values[1] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tmpList = nil;
            tmpList = [NSMutableArray arrayWithObject:values[0]];
            if ([values[1] count]) {
                [tmpList addObjectsFromArray:values[1]];
            }
            v = [NSArray arrayWithArray:tmpList];
        }
        else {
            tmpError = [NSError rjlispParseErrorWithString:@"cons: Expected list"];
        }
    }
    else {
        tmpError = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"cons" expected:2 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return v;
}

@end
