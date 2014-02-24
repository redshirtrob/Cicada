//
//  RJPlusProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJScheme.h"
#import "RJPlusProcedure.h"

@implementation RJPlusProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    float sum = 0;
    for (NSNumber *number in values) {
        if ([number isKindOfClass:[NSNumber class]]) {
            sum += [number floatValue];
        }
        else {
            tmpError = [NSError rjschemeEvalErrorWithString:[NSString stringWithFormat:@"Error: expected number but got %@", [RJScheme toString:number]]];
            break;
        }
    }

    COPY_ERROR(error, tmpError);
    return @(sum);
}

@end
