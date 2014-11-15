//
//  ViewController.h
//  bluetooth test
//
//  Created by Zehao Zhang on 14-11-14.
//  Copyright (c) 2014年 Zehao Zhang Xin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBPeripheralManagerDelegate>

@property CBPeripheralManager *myPeripheralManager;
@property CBUUID *testServiceUUID;
@property CBMutableCharacteristic *testCharacteristics;
@property CBMutableService *testService;
- (IBAction)click:(id)sender;

@end

