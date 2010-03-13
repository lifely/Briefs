//
//  BFBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefCellController.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFPresentationDispatch.h"
#import "BFDataManager.h"
#import "BFColor.h"


@implementation BFBriefCellController
@synthesize brief;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithNameOfBrief:(BriefRef *)ref
{
    self = [super init];
    if (self != nil) {
        self.brief = ref;
    }
    return self;
}

- (void)dealloc
{
    [self.brief release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefsCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"BriefsCell"] autorelease];
    }
    cell.textLabel.text = [self.brief title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pathToDictionary = [[[BFDataManager sharedBFDataManager] documentDirectory] stringByAppendingPathComponent:[self.brief filePath]];
    
    // setup scene view controller
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
    
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
    
    if ([[tv delegate] isKindOfClass:[UIViewController class]]) {
        UIViewController *tvc = (UIViewController *) [tv delegate];
        [tvc.navigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:YES];
    }
    
    [controller release];
    [manager release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [[BFDataManager sharedBFDataManager] removeBrief:self.brief];
}


///////////////////////////////////////////////////////////////////////////////

@end
