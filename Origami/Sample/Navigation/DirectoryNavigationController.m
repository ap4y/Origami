    //
//  DirectoryNavigationController.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectoryNavigationController.h"
#import "NSString+URLEncode.h"
#import "TableTrackItem.h"
//#import "TableUrlItem.h"
#import "LibraryModelCommon.h"

@implementation DirectoryNavigationController

- (void)dealloc {
    [_folder release];    
    [_currentUrl release];
    [_addBtn release];
    [super dealloc];
}

-(void)directoryModel:(DirectoryNavigationModel *)directoryModel didLoadUpnpFolderData:(NSString *)objId {
    NSLog(@"items count now %i", _navigationModel.items.count);

    [self.tableView reloadData];
    [self invalidateView];
    [self reload];
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    /*if ([object isKindOfClass:[TableUrlItem class]]) {
        TableUrlItem* item = (TableUrlItem*)object;
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            //[_selectedTracks removeObject:item.track];
            [_selectedTracks addObject:item];            
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //[_selectedTracks addObject:item.track];            
            [_selectedTracks addObject:item];            
        }
        
        
        if (_selectedTracks.count == 0)
            self.navigationItem.rightBarButtonItem = nil;
        else
            self.navigationItem.rightBarButtonItem = _addBtn;
    }*/
    
    if ([object isKindOfClass:[TableTrackItem class]]) {
        TableTrackItem* item = (TableTrackItem*)object;
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_navigationModel.selectedTracks removeObjectForKey:[NSNumber numberWithUnsignedInteger:indexPath.row]];
        }
        else {            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_navigationModel.selectedTracks setObject:item.track forKey:[NSNumber numberWithUnsignedInteger:indexPath.row]];
        }
        
        
        if (_navigationModel.selectedTracks.count == 0)
            self.navigationItem.rightBarButtonItem = nil;
        else
            self.navigationItem.rightBarButtonItem = _addBtn;
    }

}

- (void)didShowModel:(BOOL)firstTime {
    for (id item in _navigationModel.items) {
        [self didSelectObject:item atIndexPath:[NSIndexPath indexPathForRow:[_navigationModel.items indexOfObject:item] inSection:0]];
    }
}

- (void)createModel {
    if (_currentUrl == nil)
        _navigationModel = [DirectoryNavigationModel dataSourceFromUPNPFolder:_folder];
    else
        _navigationModel = [DirectoryNavigationModel dataSourceFromUrl:_currentUrl];        

    _navigationModel.directoryDelegate = self;
    self.dataSource = _navigationModel;  
    
    NSLog(@"items count was %i", _navigationModel.items.count);
}

- (id)initWithUrl:(NSString*)url query:(NSDictionary*)query {
    self = [super init];
    if (self) {
        if (url != nil) {
            NSString* urlPath = [[NSString stringWithSpecialDencodeOfString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", urlPath);
            if ([urlPath rangeOfString:@"upnp"].location != NSNotFound) {
                _currentUrl = nil;                
                _folder = [[query objectForKey:@"Folder"] retain];                                
            }
            else {
                _currentUrl = [[NSURL URLWithString:urlPath] retain];                
                _folder = nil;
            }
            
            self.title = _currentUrl.lastPathComponent;            
            _addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTracks:)];    
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)addTracks:(id)sender {
    /*NSMutableArray* tracks = [[[NSMutableArray alloc] init] autorelease];
    for (id object in _selectedTracks) {
        if ([object isKindOfClass:[TableUrlItem class]]) {
            TableUrlItem* item = (TableUrlItem*)object;
            Track* track = [AudioMetadataReader trackmetadataForURL:item.url];
            [tracks addObject:track];
        }
        else
            [tracks addObject:object];
    }
    
    [[MediaLibrary defaultLibrary] addTracks:tracks];*/
    //[_selectedTracks removeAllObjects];
    [[MediaLibrary defaultLibrary] addTracks:_navigationModel.selectedTracks.allValues];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
