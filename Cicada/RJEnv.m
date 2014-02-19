//
//  RJEnv.m
//  Cicada
//
//  Created by Robert Jones on 1/9/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJEnv.h"
#import "RJSymbol.h"

@interface RJEnv ()

@property (nonatomic, strong) NSMutableDictionary *env;
@property (nonatomic, strong) RJEnv *outerEnvironment;

@end

@implementation RJEnv

- (id)initWithParameters:(NSArray *)parameters values:(NSArray *)values outerEnvironment:(id)outerEnvironment
{
    self = [super init];
    if (self) {
        if ([parameters isKindOfClass:[RJSymbol class]]) {
            _env = [NSMutableDictionary dictionaryWithDictionary:@{(RJSymbol *)parameters : values}];
        }
        else {
            _env = [NSMutableDictionary dictionaryWithObjects:values forKeys:parameters];
        }
        _outerEnvironment = outerEnvironment;
    }
    return self;
}

- (id)init
{
    return [self initWithParameters:nil values:nil outerEnvironment:nil];
}

- (id)objectForKeyedSubscript:(id)key
{
    return self.env[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey
{
    self.env[aKey] = object;
}

- (id)find:(id)aKey
{
    id instance = self;
    if (!self.env[aKey]) {
        instance = [self.outerEnvironment find:aKey];
    }
    return instance;
}

@end
