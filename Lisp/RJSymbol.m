//
//  RJSymbol.m
//  Lisp
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJSymbol.h"

@implementation RJSymbol

+ (instancetype)symbolWithName:(NSString *)name
{
    RJSymbol *instance = [[self alloc] init];
    instance.name = name;
    return instance;
}

@end
