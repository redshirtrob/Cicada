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

+ (instancetype)EOFSymbol
{
    return [RJSymbol symbolWithName:@"#<eof-object>"];
}

- (BOOL)isEqual:(RJSymbol *)symbol
{
    return [self.name isEqualToString:symbol.name];
}

- (NSUInteger)hash
{
    return [self.name hash];
}

@end
