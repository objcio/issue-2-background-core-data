//
// Created by chris on 6/16/13.
//

#import <Foundation/Foundation.h>

@class Store;
@class FetchedResultsTableDataSource;


@interface ImportViewController : UIViewController

@property (nonatomic, strong) Store* store;
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)startImport:(id)sender;
- (IBAction)cancel:(id)sender;

@end