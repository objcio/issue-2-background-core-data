//
// Created by chris on 6/16/13.
//

#import "ImportOperation.h"
#import "Store.h"
#import "Stop.h"
#import "Stop+Import.h"
#import "NSString+ParseCSV.h"


static const int ImportBatchSize = 250;

@interface ImportOperation ()
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, strong) Store* store;
@property (nonatomic, strong) NSManagedObjectContext* context;
@end

@implementation ImportOperation
{

}

- (id)initWithStore:(Store*)store fileName:(NSString*)name
{
    self = [super init];
    if(self) {
        self.store = store;
        self.fileName = name;
    }
    return self;
}


- (void)main
{
    // TODO: can we use new in the name? I think it's bad style, any ideas for a better name?
    self.context = [self.store newPrivateContext];
    self.context.undoManager = nil;

    [self.context performBlockAndWait:^
    {
        [self import];
    }];
}

- (void)import
{
    NSString* fileContents = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:NULL];
    NSArray* lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSInteger count = lines.count;
    NSInteger progressGranularity = count/100;
    __block NSInteger idx = -1;
    [fileContents enumerateLinesUsingBlock:^(NSString* line, BOOL* shouldStop)
    {
        idx++;
        if (idx == 0) return; // header line

        if(self.isCancelled) {
            *shouldStop = YES;
            return;
        }

        NSArray* components = [line csvComponents];

        if (components.count < 5) {
            NSLog(@"couldn't parse: %@", components);
            return;
        }

        [Stop importCSVComponents:components intoContext:self.context];

        if (idx % progressGranularity == 0) {
            self.progressCallback(idx / (float) count);
        }
        if (idx % ImportBatchSize == 0) {
            [self.context save:NULL];
        }
    }];
    self.progressCallback(1);
    [self.context save:NULL];
}

@end