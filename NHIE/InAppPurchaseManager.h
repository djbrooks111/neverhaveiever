//
//  InAppPurchaseManager.h
//  NHIE
//
//  Created by David Brooks on 12/31/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

// Public Methods
-(void)loadStore;
-(BOOL)canMakePurchases;
-(void)purchaseProUpgrade;
-(void)restorePurchases;

@end
