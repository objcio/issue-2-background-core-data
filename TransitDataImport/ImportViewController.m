//
// Created by chris on 6/16/13.
//

#import "ImportViewController.h"
#import "Store.h"
#import "ImportOperation.h"
#import "FetchedResultsTableDataSource.h"
#import "Stop.h"


@interface ImportViewController ()
@property (nonatomic, strong) NSOperationQueue* operationQueue;
@property (nonatomic, strong) FetchedResultsTableDataSource* dataSource;
@end

@implementation ImportViewController
{
}

- (id)init {
    self = [super initWithNibName:@"ImportViewController" bundle:nil];
    if(self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.store.mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:self.tableView fetchedResultsController:fetchedResultsController];
    self.dataSource.configureCellBlock = ^(UITableViewCell*  cell, Stop* item)
    {
        cell.textLabel.text = item.name;
    };
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


- (IBAction)startImport:(id)sender {
    self.progressIndicator.progress = 0;
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
    ImportOperation* operation = [[ImportOperation alloc] initWithStore:self.store fileName:fileName];
    operation.progressCallback = ^(float progress) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            self.progressIndicator.progress = progress;
        }];
    };
    [self.operationQueue addOperation:operation];
}

- (IBAction)cancel:(id)sender {
    [self.operationQueue cancelAllOperations];
}

@end