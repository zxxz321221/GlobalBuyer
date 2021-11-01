//
//  UIViewController+getContactInfor.m
//  CH_GetContactInfor
//
//  Created by 耗子 on 16/10/21.
//  Copyright © 2016年 DogCat. All rights reserved.
//

#import "UIViewController+getContactInfor.h"

#define Is_up_Ios_9      ([[UIDevice currentDevice].systemVersion floatValue]) >= 9.0

@implementation UIViewController (getContactInfor)

#pragma  mark -获取通讯录联系人
void(^addressBlock)(NSDictionary *);
- (void)CheckAddressBookAuthorizationandGetPeopleInfor:(void (^)(NSDictionary *data))handler{
    addressBlock = [handler copy];
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted)
                {
                    //iOS9 没有权限
                   NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
                }
                else
                {
                    //iOS9 有权限
                    [self methodForNineOrMore];
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            //ios9 有权限
            [self methodForNineOrMore];
        }
        else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted)
                    {
                        // ios9 以下 没权限
                        NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
                    }
                    else
                    {
                        //iOS9以下  有权限
                        [self methodForNineLess];
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            //iOS9以下  有权限
            [self methodForNineLess];
        }else {
           NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

//调起iOS9以上调用通讯录的方法
-(void)methodForNineOrMore{
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [self presentViewController:contactPicker animated:YES completion:nil];
}

//iOS以下
-(void)methodForNineLess{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}
//iOS9 通讯代理
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = phoneNumber.stringValue;
        NSDictionary *dic = @{@"name":text1,@"phone":text2};
        addressBlock(dic);
    }];
}

//iOS9以下代理
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *text2 = (__bridge NSString*)value;
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic = @{@"name":text1,@"phone":text2};
        addressBlock(dic);
    }];
}

@end
