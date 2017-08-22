//
//  DBActionMenuController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBActionMenuController.h"
#import "UIDevice+Hardware.h"

@interface DBActionMenuController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DBActionMenuController

- (void)initDataSource {
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 1;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDetailButton;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayAPIDomainList);
        d.accessoryTarget = self;
        d.accessoryAction = @selector(displayAddAPIDomainDialog);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"API Domain";
        d.detailText = @"Not Set";
        d;
    }),
                                                                                                                              ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 2;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDetailButton;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayH5APIDomainList);
        d.accessoryTarget = self;
        d.accessoryAction = @selector(displayH5AddAPIDomainDialog);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"H5-API Domain";
        d.detailText = @"Not Set";
        d;
    })],
                                                                                                                          @[
                                                                                                                              ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 3;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayDeviceHardwareDetailsDialog);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Device Hardware";
        d.detailText = @"Click to view details";
        d;
    })],
                                                                                                                          @[
                                                                                                                              ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 4;
        d.style = UITableViewCellStyleDefault;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayBorderForAllVisibleViews);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Display border for all visible views";
        d;
    })]
                                                                                                                          ]];
    self.tableView.qmui_staticCellDataSource = dataSource;
    self.sectionTitles = @[@"API Configuration", @"Device Hardware", @"Tools"];
}

- (void)displayAPIDomainList {
    
}

- (void)displayAddAPIDomainDialog {
    
}

- (void)displayH5APIDomainList {
    
}

- (void)displayH5AddAPIDomainDialog {
    
}

- (void)displayDeviceHardwareDetailsDialog {
    
}

- (void)displayBorderForAllVisibleViews {
    
}

@end
