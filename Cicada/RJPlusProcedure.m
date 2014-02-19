//
//  RJPlusProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJPlusProcedure.h"

@implementation RJPlusProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    float sum = 0;
    for (NSNumber *number in values) {
        sum += [number floatValue];
    }
    return @(sum);
}

@end
