//
//  RJEnv.m
//  Lisp
//
//  Created by Robert Jones on 1/9/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJEnv.h"
#import "RJSymbol.h"
#import "NSError+RJLisp.h"

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
    RJEnv * __weak weakSelf = self;

    self.env[[RJSymbol symbolWithName:@"+"]] = ^(NSArray *args, NSError **error) {
        float sum = 0;
        for (NSNumber *number in args) {
            sum += [number floatValue];
        }
        return @(sum);
    };

    self.env[[RJSymbol symbolWithName:@"-"]] = ^(NSArray *args, NSError **error) {
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
            *error = [NSError rjlispTooFewArgumentsErrorForSymbol:@"-" atLeast:1 got:0];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"*"]] = ^(NSArray *args, NSError **error) {
        float prod = 1;
        for (NSNumber *number in args) {
            prod *= [number floatValue];
        }
        return @(prod);
    };

    self.env[[RJSymbol symbolWithName:@"/"]] = ^(NSArray *args, NSError **error) {
        float v = 1;
        if ([args count]) {
            v = [args[0] floatValue];
            for (NSInteger i = 1; i < [args count]; i++) {
                float divisor = [args[i] floatValue];
                if (divisor != 0) {
                    v /= [args[i] floatValue];
                }
                else {
                    *error = [NSError rjlispEvalErrorWithString:@"Error /: attempt to divide by zero"];
                }
            }
        }
        else {
            *error = [NSError rjlispTooFewArgumentsErrorForSymbol:@"/" atLeast:1 got:0];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"not"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = ![args[0] boolValue];
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"not" expected:1 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@">"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            v = ([args[0] floatValue] > [args[1] floatValue]);
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@">" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@">="]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            v = ([args[0] floatValue] >= [args[1] floatValue]);
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@">=" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"<"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            v = ([args[0] floatValue] < [args[1] floatValue]);
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"<" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"<="]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            v = ([args[0] floatValue] <= [args[1] floatValue]);
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"<=" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"="]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            v = ([args[0] floatValue] == [args[1] floatValue]);
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"=" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"cons"]] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 2) {
            if ([args[1] isKindOfClass:[NSArray class]]) {
                /*
                 * (cons 'a '()) => (a)
                 * (cons '() '()) => (())
                 * (cons '() '(a b)) => (() a b)
                 * (cons '(a b) '()) => ((a b))
                 * (cons '(a b) '(c d)) => ((a b) c d)
                 */
                NSMutableArray *tmpList = nil;
                tmpList = [NSMutableArray arrayWithObject:args[0]];
                if ([args[1] count]) {
                    [tmpList addObjectsFromArray:args[1]];
                }
                v = [NSArray arrayWithArray:tmpList];
            }
            else {
                *error = [NSError rjlispParseErrorWithString:@"cons: Expected list"];
            }
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"cons" expected:2 got:[args count]];
        }
        return v;
    };

    self.env[[RJSymbol symbolWithName:@"car"]] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 1) {
            NSArray *list = args[0];
            if ([list isKindOfClass:[NSArray class]]) {
                if ([list count]) {
                    v = list[0];
                }
                else {
                    *error = [NSError rjlispEvalErrorWithString:@"Error car: attempt to apply car to empty list"];
                }
            }
            else {
                *error = [NSError rjlispEvalErrorWithString:@"Error car: expected list"];
            }
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"car" expected:1 got:[args count]];
        }
        return v;
    };

    self.env[[RJSymbol symbolWithName:@"cdr"]] = ^(NSArray *args, NSError **error) {
        id v = nil;
        if ([args count] == 1) {
            NSArray *list = args[0];
            if ([list isKindOfClass:[NSArray class]]) {
                NSInteger length = [list count];
                if (length <= 1) {
                    v = [NSArray array];
                }
                else if (length > 1) {
                    v = [list subarrayWithRange:NSMakeRange(1, length-1)];
                }
            }
            else {
                *error = [NSError rjlispEvalErrorWithString:@"Error cdr: expected list"];
            }
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"cdr" expected:1 got:[args count]];
        }
        return v;
    };

    self.env[[RJSymbol symbolWithName:@"null?"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = args[0] == [NSNull null];
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"null?" expected:1 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"symbol?"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = [args[0] isKindOfClass:[NSString class]];
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"symbol?" expected:1 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"list"]] = ^(NSArray *args, NSError **error) {
        return [NSArray arrayWithArray:args];
    };

    self.env[[RJSymbol symbolWithName:@"list?"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 1) {
            v = [args[0] isKindOfClass:[NSArray class]];
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"list?" expected:1 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"eq?"]] = ^(NSArray *args, NSError **error) {
        BOOL v = NO;
        if ([args count] == 2) {
            if ([args[0] isKindOfClass:[NSNumber class]] && [args[1] isKindOfClass:[NSNumber class]]) {
                lambda eq = weakSelf.env[@"="];
                v = [((NSNumber *)eq(args, error)) boolValue];
            }
            else {
                v = (args[0] == args[1]);
            }
        }
        else {
            *error = [NSError rjlispIncorrectNumberOfArgumentsErrorForSymbol:@"eq?" expected:2 got:[args count]];
        }
        return @(v);
    };

    self.env[[RJSymbol symbolWithName:@"append"]] = ^(NSArray *args, NSError **error) {
        NSMutableArray *array = [NSMutableArray array];
        for (id arg in args) {
            if ([arg isKindOfClass:[NSArray class]]) {
                [array addObjectsFromArray:arg];
            }
            else {
                *error = [NSError rjlispEvalErrorWithString:@"Error append: expected list"];
                array = nil;
            }
        }
        return array ? [NSArray arrayWithArray:array] : nil;
    };

    self.env[[RJSymbol symbolWithName:@"length"]] = ^(NSArray *args, NSError **error) {
        NSNumber *v = nil;
        if ([args[0] isKindOfClass:[NSArray class]]) {
            v = @([args[0] count]);
        }
        else {
            *error = [NSError rjlispEvalErrorWithString:@"Error length: expected list"];
        }
        return v;
    };
}

@end
