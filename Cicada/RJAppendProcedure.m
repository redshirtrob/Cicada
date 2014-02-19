//
//  RJAppendProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJAppendProcedure.h"

@implementation RJAppendProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    NSMutableArray *array = [NSMutableArray array];
    for (id arg in values) {
        if ([arg isKindOfClass:[NSArray class]]) {
            [array addObjectsFromArray:arg];
        }
        else {
            tmpError = [NSError rjlispEvalErrorWithString:@"Error append: expected list"];
            array = nil;
            break;
        }
    }

    COPY_ERROR(error, tmpError);
    return array ? [NSArray arrayWithArray:array] : nil;
}

@end
