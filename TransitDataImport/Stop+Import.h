//
// Created by chris on 6/16/13.
//

#import <Foundation/Foundation.h>
#import "Stop.h"

@interface Stop (Import)
+ (void)importCSVComponents:(NSArray*)components intoContext:(NSManagedObjectContext*)context;
@end