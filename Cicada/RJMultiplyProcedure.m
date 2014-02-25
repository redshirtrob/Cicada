//
//  RJMultiplyProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJScheme.h"
#import "RJMultiplyProcedure.h"

@implementation RJMultiplyProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError;

    float prod = 1;
    for (NSNumber *number in values) {
        if ([number isKindOfClass:[NSNumber class]]) {
            prod *= [number floatValue];
        }
        else {
            tmpError = [NSError rjschemeEvalErrorWithString:[NSString stringWithFormat:@"Error: expected number but got %@", [RJScheme toString:number]]];
            break;
        }
    }

    COPY_ERROR(error, tmpError);
    return @(prod);
}

@end
