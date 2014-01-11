//
//  RJEnv.m
//  Lisp
//
//  Created by Robert Jones on 1/9/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJEnv.h"

@interface RJEnv ()

@property (nonatomic, strong) NSMutableDictionary *env;
@property (nonatomic, strong) RJEnv *outerEnvironment;

@end

@implementation RJEnv

- (id)initWithParameters:(NSArray *)parameters values:(NSArray *)values outerEnvironment:(id)outerEnvironment
{
    self = [super init];
    if (self) {
        _env = [NSMutableDictionary dictionaryWithObjects:values forKeys:parameters];
        _outerEnvironment = outerEnvironment;
    }
    return self;
}

- (id)init
{
    return [self initWithParameters:nil values:nil outerEnvironment:nil];
}

- (void)initialize
{
    self.env[@"+"] = ^(NSArray *args) {
        float sum = 0;
        for (NSNumber *number in args) {
            sum += [number floatValue];
        }
        return @(sum);
    };

    self.env[@"*"] = ^(NSArray *args) {
        float prod = 1;
        for (NSNumber *number in args) {
            prod *= [number floatValue];
        }
        return @(prod);
    };
}

- (id)objectForKeyedSubscript:(id)key
{
    return self.env[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey
{
    self.env[aKey] = object;
}

- (instancetype)find:(id)aKey
{
    id instance = self;
    if (!self.env[aKey]) {
        instance = [self.outerEnvironment find:aKey];
    }
    return instance;
}

@end
