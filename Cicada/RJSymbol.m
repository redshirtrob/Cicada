//
//  RJSymbol.m
//  Cicada
//
//  Created by Robert Jones on 1/11/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJSymbol.h"
#import "NSString+RJScheme.h"

@implementation RJSymbol

+ (instancetype)symbolWithName:(NSString *)name
{
    RJSymbol *instance = [[self alloc] init];
    instance.name = name;
    return instance;
}

+ (instancetype)EOFSymbol
{
    static dispatch_once_t pred = 0;
    static id __strong  _sharedObject = nil;
    dispatch_once(&pred, ^{
            _sharedObject = [RJSymbol symbolWithName:@"#<eof-object>"];
        });
    return _sharedObject;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[self class] symbolWithName:self.name];
}

- (BOOL)isEqual:(RJSymbol *)symbol
{
    if ([symbol isKindOfClass:[RJSymbol class]]) {
        return [self.name isEqualToString:symbol.name];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.name hash];
}

- (NSString *)description
{
    return self.name;
}

- (BOOL)isSyntax
{
    return ([self.name isEqualToString:@"quote"] ||
            [self.name isEqualToString:@"if"] ||
            [self.name isEqualToString:@"set!"] ||
            [self.name isEqualToString:@"define"] ||
            [self.name isEqualToString:@"lambda"] ||
            [self.name isEqualToString:@"begin"] ||
            [self.name isEqualToString:@"define-macro"]);
}

- (NSString *)stringValue
{
    return self.name;
}

- (NSString *)scalarStringValue
{
    return [self isSyntax] ? [NSString stringWithFormat:@"#<Syntax %@>", self.name] : self.name;
}

@end
