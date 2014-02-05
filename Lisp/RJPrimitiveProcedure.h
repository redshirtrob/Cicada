//
//  RJPrimitiveProcedure.h
//  Lisp
//
//  Created by Robert Jones on 2/4/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSError+RJLisp.h"

#define COPY_ERROR(e, t)     \
    do {                     \
        if (e && t) {        \
            *e = t;          \
        }                    \
    }                        \
    while (0)

@interface RJPrimitiveProcedure : NSObject

- (id)evalWithValues:(NSArray *)values error:(NSError **)error;

@end
