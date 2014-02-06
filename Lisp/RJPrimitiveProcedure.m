//
//  RJPrimitiveProcedure.m
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJPrimitiveProcedure.h"

@implementation RJPrimitiveProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    return nil;
}

- (NSString *)stringValue
{
    return [self description];
}

@end
