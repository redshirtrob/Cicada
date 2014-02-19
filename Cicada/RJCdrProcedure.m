//
//  RJCdrProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJCdrProcedure.h"

@implementation RJCdrProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    id v = nil;
    if ([values count] == 1) {
        NSArray *list = values[0];
        if ([list isKindOfClass:[NSArray class]]) {
            NSInteger length = [list count];
            if (length <= 1) {
                v = [NSArray array];
            }
            else if (length > 1) {
                v = [list subarrayWithRange:NSMakeRange(1, length-1)];
            }
        }
        else {
            tmpError = [NSError rjschemeEvalErrorWithString:@"Error cdr: expected list"];
        }
    }
    else {
        tmpError = [NSError rjschemeIncorrectNumberOfArgumentsErrorForSymbol:@"cdr" expected:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return v;
}

@end
