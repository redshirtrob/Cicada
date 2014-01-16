//
//  RJInPort.m
//  Lisp
//
//  Created by Robert Jones on 1/15/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJInPort.h"
#import "NSFileHandle+RJLisp.h"

/*
 * Peter Norvig's Lisp Regex
 *
 *                    1            3              3                    1
 * tokenizer = r'''\s*(,@|[('`,)]|"(?:[\\].|[^\\"])*"|;.*|[^\s('"`,;)]*)(.*)'''
 *                        2     2     4  4  5    5        6          6  7  7
 *
 * Briefly this means match:
 *  - Any number of whitespace characters, followed by
 *  - One of (Capturing):
 *    - ',@' (Lisp ,@exp form)
 *    - Either a left parenthesis ((), single quote ('), backtick (`), comma (,) or right parenthesis ()) character
 *    - A double quote (") followed by zero or more of the following and closed with another double quote ("):
 *      - A backslash (\) followed by a single character, or
 *      - A non backslash character
 *    - A semicolon (;) followed by zero or more characters
 *    - Zero or more characters that are not one of the followinjg:
 *      - Whitespace
 *      - Left parenthesis (()
 *      - Single quote (')
 *      - Double quote (")
 *      - Backtick (`)
 *      - Comma (,)
 *      - Semicolon (;)
 *      - Right parenthesis ())
 *  - Zero or more characters (Capturing)
 */

static NSString *const PNTokenizerRegEx = @"\\s*(,@|[('`,)]|\"(?:[\\\\].|[^\\\\\"])*\"|;.*|[^\\s('\"`,;)]*)(.*)";

@interface RJInPort ()

@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSString *line;
@property (nonatomic, strong) NSRegularExpression *regex;

@end

@implementation RJInPort

+ (instancetype)inPortWithStandardInput
{
    return [[RJInPort alloc] initWithFileHandle:[NSFileHandle fileHandleWithStandardInput]];
}

+ (instancetype)inPortWithStandardOutput
{
    return [[RJInPort alloc] initWithFileHandle:[NSFileHandle fileHandleWithStandardOutput]];
}

- (id)initWithFileHandle:(NSFileHandle *)fileHandle
{
    self = [super init];
    if (self) {
        _fileHandle = fileHandle;
        _line = @"";

        NSError *error;
        _regex = [NSRegularExpression regularExpressionWithPattern:PNTokenizerRegEx options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
            self = nil;
        }
    }
    return self;
}

- (RJSymbol *)nextToken
{
    while (YES) {
        if (![self.line length]) {
            self.line = [self.fileHandle readline];
        }
        if (![self.line length]) {
            return [RJSymbol EOFSymbol];
        }

        NSArray *matches = [self.regex matchesInString:self.line options:0 range:NSMakeRange(0, [self.line length])];
        if ([matches count] == 2) {
            NSTextCheckingResult *result = matches[0];
            NSString *token = [self.line substringWithRange:result.range];

            result = matches[1];
            self.line = [self.line substringWithRange:result.range];

            if ([token length] && ![token hasPrefix:@";"]) {
                return [RJSymbol symbolWithName:token];
            }
        }
    }
    return nil;
}

@end
