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

- (void)initialize
{
    self.env[@"+"] = ^(NSArray *args, NSError **error) {
        float sum = 0;
        for (NSNumber *number in args) {
            sum += [number floatValue];
        }
        return @(sum);
    };

    self.env[@"-"] = ^(NSArray *args, NSError **error) {
        float v = 0;
        if ([args count] == 1) {
            v = -[args[0] floatValue];
        }
        else if ([args count] > 1) {
            v = [args[0] floatValue];
            for (NSInteger i = 1; i < [args count]; i++) {
                v -= [args[i] floatValue];
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error -: too few arguments (at least: 1 got: 0)"] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"*"] = ^(NSArray *args, NSError **error) {
        float prod = 1;
        for (NSNumber *number in args) {
            prod *= [number floatValue];
        }
        return @(prod);
    };

    self.env[@"/"] = ^(NSArray *args, NSError **error) {
        float v = 1;
        if ([args count]) {
            v = [args[0] floatValue];
            for (NSInteger i = 1; i < [args count]; i++) {
                float divisor = [args[i] floatValue];
                if (divisor != 0) {
                    v /= [args[i] floatValue];
                }
                else {
                    *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error /: attempt to divide by zero"] code:-1 userInfo:nil];
                }
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error /: too few arguments (at least: 1 got: 0)"] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"not"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            if (args[0] == [NSNull null]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error not: too few arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@">"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] floatValue] > [args[1] floatValue]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error >: too few arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };
}

@end
