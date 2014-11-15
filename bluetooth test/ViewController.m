//
//  ViewController.m
//  bluetooth test
//
//  Created by Zehao Zhang on 14-11-14.
//  Copyright (c) 2014年 Zehao Zhang Xin Huang. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)setUpManager {
    _myPeripheralManager =
    [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    _testServiceUUID = [CBUUID UUIDWithString:@"AF84CBDD-C858-427C-8236-D3800A9624AB"];
    _testCharacteristics = [[CBMutableCharacteristic alloc] initWithType:_testServiceUUID properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    _testService = [[CBMutableService alloc] initWithType:_testServiceUUID primary:YES];
    _testService.characteristics = @[_testCharacteristics];
    [_myPeripheralManager addService:_testService];
    [_myPeripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[_testService.UUID]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    if ([request.characteristic.UUID isEqual:_testCharacteristics.UUID]) {
        if (request.offset > _testCharacteristics.value.length) {
            [_myPeripheralManager respondToRequest:request
                                        withResult:CBATTErrorInvalidOffset];
            return;
        }
        request.value = [_testCharacteristics.value
                         subdataWithRange:NSMakeRange(request.offset,
                                                      _testCharacteristics.value.length - request.offset)];
        [_myPeripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
    [_myPeripheralManager respondToRequest:request withResult:CBATTErrorAttributeNotFound];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"Central subscribed to characteristic %@", characteristic);
    NSData *updatedValue = _testCharacteristics.value;
    BOOL didSendValue = [_myPeripheralManager updateValue:updatedValue
                                        forCharacteristic:_testCharacteristics onSubscribedCentrals:nil];
    if (!didSendValue) {
        NSLog(@"Error sending value");
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

- (IBAction)click:(id)sender {
    NSString *str = @"Hello World";
    _testCharacteristics.value = [str dataUsingEncoding:NSUnicodeStringEncoding];
    NSLog(@"%@", _testCharacteristics.value);
}

@end
