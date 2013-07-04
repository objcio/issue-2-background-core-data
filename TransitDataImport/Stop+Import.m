//
// Created by chris on 6/16/13.
//

#import "Stop+Import.h"


@implementation Stop (Import)

// Note: don't use this in production code. For large imports, you should implement findOrCreate as per Apple's instructions:
// http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html
+ (instancetype)findOrCreateWithIdentifier:(id)identifier inContext:(NSManagedObjectContext*)context {
    NSString* entityName = NSStringFromClass(self);
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    fetchRequest.fetchLimit = 1;
    id object = [[context executeFetchRequest:fetchRequest error:NULL] lastObject];
    if(object == nil) {
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    }
    return object;
}

+ (void)importCSVComponents:(NSArray*)components intoContext:(NSManagedObjectContext*)context
{
    NSString* identifier = components[0];
    NSString* name = components[2];
    double latitude = [components[4] doubleValue];
    double longitude = [components[5] doubleValue];

    Stop* stop = [self findOrCreateWithIdentifier:identifier inContext:context];
    stop.name = name;
    stop.identifier = identifier;
    stop.latitude = @(latitude);
    stop.longitude = @(longitude);
}

@end