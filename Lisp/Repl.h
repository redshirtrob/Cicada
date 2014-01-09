//
//  Repl.h
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repl : NSObject

@property (nonatomic, copy) NSString *prompt;

- (id)initWithPrompt:(NSString *)prompt;
- (void)run;

@end
