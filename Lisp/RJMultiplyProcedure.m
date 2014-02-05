//
//  RJMultiplyProcedure.m
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJMultiplyProcedure.h"

@implementation RJMultiplyProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    float prod = 1;
    for (NSNumber *number in values) {
        prod *= [number floatValue];
    }
    return @(prod);
}

@end
