//
//  RootViewController.m
//  geobbs
//

#import "NotifViewController.h"

@implementation NotifViewController

@synthesize notifications;
@synthesize locationController;

#pragma mark -
#pragma mark View lifecycle

- (void)newLocation:(CLLocation *)location {
    NSArray *newNotifications = [[[Service getService] getNotificationsList:[User getCurrentUser] withLocation:location] autorelease];
  
    // Don't reload if newNotifications == notification
    if(![newNotifications isEqualToArray:notifications]){
        
        NSArray* diff = [self getDifferenceBetween:notifications andNew:newNotifications];
        
        if([diff count] > 0){
            NSDictionary *item = (NSDictionary *)[diff objectAtIndex:0];
            
            // If the last user check-in isn't the current user
            // TODO: @"4e7f08f0bd99e46165000001" should be the current UserID
            if(![(NSString*)[item valueForKey:@"_userId"] isEqualToString:@"4e7f08f0bd99e46165000001"]){
                NSLog(@"%@", (NSString*)[item valueForKey:@"description"]);
                
                UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"New user around"
                                                                message:[NSString stringWithFormat:@"%@ - %@"
                                                                       ,   [item valueForKeyPath:@"User.login"]
                                                                       ,   [item valueForKey:@"description"]]
                                                                delegate:nil 
                                                                cancelButtonTitle:@"OK!"
                                                                otherButtonTitles:nil];
                [alert show];
            }
        }
        
        // Update the UITableView
        [notifications release];
        notifications = [[NSArray alloc] initWithArray:newNotifications];
        [self.tableView reloadData];
    }
}

// Get the difference between old & new data array
- (NSArray*)getDifferenceBetween:(NSArray*) oldData andNew:(NSArray*) newData{
    
    NSMutableSet *old = [NSMutableSet setWithArray:oldData];
    NSMutableSet *new = [NSMutableSet setWithArray:newData];
    
    [new minusSet:old];
    
    return [new allObjects];
}

- (void)viewDidLoad {
    // Initialize location manager
    locationController = [[CLController alloc] init];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notifications count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (cell == nil) {
        // UITableViewCellStyleSubtitle == 2 labels
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    NSDictionary *item = (NSDictionary *) [self.notifications objectAtIndex:indexPath.row];

    cell.textLabel.text = [item valueForKeyPath:@"User.login"];
    cell.detailTextLabel.text = [item valueForKey:@"description"];


    // Ajout de la flèche bleu
    // cf: http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html#//apple_ref/doc/uid/TP40007451-CH7-SW1
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [locationController release];
    [notifications release];
    [super dealloc];
}


@end

