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

    self.env[@">="] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] floatValue] >= [args[1] floatValue]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error >=: too few arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"<"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] floatValue] < [args[1] floatValue]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error <: too few arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"<="] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] floatValue] <= [args[1] floatValue]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error <=: too few arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"="] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] floatValue] == [args[1] floatValue]) {
                v = YES;
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error ==: too few arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"cons"] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 2) {
            NSMutableArray *tmpList = nil;
            if (![args[0] isKindOfClass:[NSArray class]]) {
                tmpList = [NSMutableArray arrayWithObject:args[0]];
            }
            else {
                tmpList = [NSMutableArray arrayWithArray:args[0]];
            }

            if (![args[1] isKindOfClass:[NSArray class]] || [args[1] count]) {
                [tmpList addObject:args[1]];
            }
            v = [NSArray arrayWithArray:tmpList];
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error ==: wrong number of arguments (expected: 2 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return v;
    };

    self.env[@"car"] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 1) {
            NSArray *list = args[0];
            if ([list isKindOfClass:[NSArray class]]) {
                if ([list count]) {
                    v = list[0];
                }
                else {
                    *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error car: attempt to apply car to empty list"] code:-1 userInfo:nil];
                }
            }
            else {
                *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error car: expected list"] code:-1 userInfo:nil];
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error car: too few arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return v;
    };

    self.env[@"cdr"] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 1) {
            NSArray *list = args[0];
            if ([list isKindOfClass:[NSArray class]]) {
                NSInteger length = [list count];
                if (length == 1) {
                    v = [NSNull null];
                }
                else if (length > 1) {
                    v = [list subarrayWithRange:NSMakeRange(1, length-1)];
                }
                else {
                    *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error cdr: attempt to apply cdr to empty list"] code:-1 userInfo:nil];
                }
            }
            else {
                *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error cdr: expected list"] code:-1 userInfo:nil];
            }
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error cdr: too few arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return v;
    };

    self.env[@"null?"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = args[0] == [NSNull null];
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error null?: wrong number of arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"symbol?"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = [args[0] isKindOfClass:[NSString class]];
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error symbol?: wrong number of arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };

    self.env[@"list"] = ^(NSArray *args, NSError **error) {
        return [NSArray arrayWithArray:args];
    };

    self.env[@"list?"] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = [args[0] isKindOfClass:[NSArray class]];
        }
        else {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Error list?: wrong number of arguments (expected: 1 got: %lu)", [args count]] code:-1 userInfo:nil];
        }
        return @(v);
    };
}

@end
