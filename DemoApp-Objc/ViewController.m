//
//  ViewController.m
//  ProObjc
//
//  Created by Priyanka  on 11/12/19.
//  Copyright © 2019 Asiapay. All rights reserved.
//

#import "ViewController.h"
#import <AP_PaySDK/AP_PaySDK.h>
#import <AP_PaySDK/AP_PaySDK-Swift.h>
//#import "IQKeyboardManager.h"
//@import IQKeyboardManagerSwift;
@import AP_PaySDK;


@interface ViewController () <PaySDKDelegate, UITextFieldDelegate, UITextViewDelegate> {
    PaySDK *paySDK;
    NSString *memberPayToken;
    PayGate *bb;
    CurrencyCode *bb1;
    BOOL isRamdom;
    UIActivityIndicatorView *activityView;
    NSString *merchantId;
    NSString *resultPage;
    NSMutableDictionary *extraData;
    IBOutlet UIButton *applePayBtn;
    IBOutlet UITextField *mIdText;
    IBOutlet UITextField *cardNoText;
    IBOutlet UITextField *expMonthText;
    IBOutlet UITextField *expYearText;
    IBOutlet UITextField *securityCodeText;
    IBOutlet UITextField *amountText;
    IBOutlet UITextView *payResultTextvW;
    NSTimeInterval timeInSeconds;
    NSString *orderRef;
}

@end


@implementation ViewController {
    
    //    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    paySDK = [PaySDK shared];
    self.title = @"PaySDK Demo";
    //    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithController:self];
    //  returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    orderRef = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000000000];
    
    //    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    //    [[IQKeyboardManager shared] setToolbarManageBehaviour:IQAutoToolbarManageBehaviourByPosition];
    
    UiCustomization *customization = [[UiCustomization alloc] init];
    
    ButtonCustomization *submitButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
    ButtonCustomization *resendButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
    ButtonCustomization *cancelButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
    ButtonCustomization *nextButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
    ButtonCustomization *continueButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
    
    LabelCustomization *labelCustomization = [[LabelCustomization alloc] init:@"Courier" :@"#FF0000" :14 :@"#FF0000":@"Courier" :20];
    TextBoxCustomization *textBoxCustomization = [[TextBoxCustomization alloc] init:@"Courier" :@"FF0000" :14 :4 :@"FF0000" :4];
    // ToolbarCustomization *toolbarCustomization = [[ToolbarCustomization alloc] init:@"Courier" :@"#FFFFFF" :20 :@"#000000" :@"Payment Page"];
    NSError *err;
    [customization setLabelCustomization:labelCustomization error:&err];
    [customization setButtonCustomization:submitButtonCustomization : PaySDKButtonTypeSUBMIT error:&err];
    [customization setButtonCustomization:resendButtonCustomization : PaySDKButtonTypeRESEND error:&err];
    [customization setButtonCustomization:cancelButtonCustomization : PaySDKButtonTypeCANCEL error:&err];
    [customization setButtonCustomization:nextButtonCustomization : PaySDKButtonTypeNEXT error:&err];
    [customization setButtonCustomization:continueButtonCustomization : PaySDKButtonTypeCONTINUE error:&err];
    
    [customization setLabelCustomization:labelCustomization error:&err];
    [customization setTextBoxCustomization:textBoxCustomization error:&err];
    //[customization setToolbarCustomization:toolbarCustomization error:&err];
    [paySDK setUiCustomization:customization];
    
    paySDK.delegate = self;
    paySDK.isBioMetricRequired = YES;
    mIdText.text = @"88146271";
    merchantId = mIdText.text;
    
    
}

- (IBAction)directClick:(id)sender{
    merchantId = mIdText.text;
    resultPage = @"F";
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:amountText.text
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    NSLog(@"%@", cardNoText.text);
    paySDK.paymentDetails.cardDetails = [[CardDetails alloc] initWithCardHolderName:@"Test Card"
                                                                             cardNo:cardNoText.text
                                                                           expMonth:expMonthText.text
                                                                            expYear:expYearText.text
                                                                       securityCode:securityCodeText.text];
    
    
    [paySDK process];
}

- (IBAction)hostedClick:(id)sender {
    merchantId = mIdText.text;
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:amountText.text
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"CC"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}

- (IBAction)schedulePayClick:(id)sender {
    NSDictionary *dic = @{@"appId" : @"SP",
                          @"appRef" : @"txtOrderRef.text!",
                          @"schType" : @"Day",
                          @"schStatus" : @"Active",
                          @"nSch" : @"1",
                          @"sMonth" : @"4",
                          @"sDay" : @"26",
                          @"sYear" : @"2019",
                          @"eMonth" : @"",
                          @"eDay" : @"",
                          @"eYear" : @"",
                          @"name" : @"Name",
                          @"email" : @"name@abc.com"};
    
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:extraData];
    
    [paySDK process];
}

- (IBAction)PromoPayClick:(id)sender {
    NSDictionary *dic = @{@"promotion": @"T",
                          @"promotionCode": @"TEST1",
                          @"promotionRuleCode" : @"TESTR25",//"TESTR50"
                          @"promotionOriginalAmt": @"5"};
    
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:extraData];
    
    [paySDK process];
}

- (IBAction)InstallmentPayClick:(id)sender {
    NSDictionary *dic = @{ @"installment_service" : @"T",
                           @"installment_period" : @6,
                           @"installOnly": @"T"};
    
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW
                                                         envType: EnvTypeSANDBOX
                                                          amount: @"2.0"
                                                         payGate: PayGatePAYDOLLAR
                                                        currCode: CurrencyCodeHKD
                                                         payType: payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef payMethod:@"VISA"
                                                            lang: LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark: @""
                                                          payRef: @""
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData: extraData];
    
    [paySDK process];
}

- (IBAction)NewMemberPayClick:(id)sender {
    resultPage = @"T";
    NSDictionary *dic = @{@"memberPay_memberId" : @"member03",
                          @"addNewMember" : @"true",
                          @"memberPay_service": @"T"};
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:extraData];
    
    [paySDK process];
}

- (IBAction)OldMemberPayClick:(id)sender {
    resultPage = @"T";
    NSDictionary *dic = @{@"memberPay_memberId" : @"member03",
                          @"addNewMember" : @"true",
                          @"memberPay_token" : @"",
                          @"memberPay_service": @"T"};
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:extraData];
    
    [paySDK process];
}

- (IBAction)eVoucherClick:(id)sender {
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}

- (IBAction)octopusPayClick:(id)sender{
    NSDictionary *dic = @{@"eVoucher": @"T",
                          @"eVClassCode": @"0001"};
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"0.1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"OCTOPUS"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"                      extraData:extraData];
    
    [paySDK process];
}

- (IBAction)FPSClick:(id)sender{
    NSDictionary *dic = @{@"fpsQueryUrl" : @"https://fps.paydollar.com/api/fpsQrUrl?encrypted="};
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypePRODUCTION amount:@"2.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef:orderRef
                                                       payMethod:@"FPS"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:dic];
    
    [paySDK process];
}

- (IBAction)alipayHKClick:(id)sender{
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"ALIPAYHKAPP"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData: nil];
    
    [paySDK process];
}

- (IBAction)alipayCNClick:(id)sender{
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1.0"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"ALIPAYCNAPP"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}

- (IBAction)alipayGlobalClick:(id)sender{
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT envType:EnvTypeSANDBOX amount:@"1.0" payGate:PayGatePAYDOLLAR currCode:CurrencyCodeHKD payType:payTypeNORMAL_PAYMENT orderRef: orderRef payMethod:@"ALIPAYAPP" lang:LanguageENGLISH merchantId: merchantId remark:@"" payRef:@"" resultpage:resultPage showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?" extraData:nil];
    
    [paySDK process];
}

- (IBAction)wechatClick:(id)sender{
    
    NSDictionary *dic =@{@"wechatUniversalLink": @"https://paydollarmobileapp/"};
    extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"0.01"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"WECHATAPP"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}

- (IBAction)PayMeClick:(id)sender{
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1.81"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD payType:payTypeNORMAL_PAYMENT orderRef:orderRef
                                                       payMethod:@"PayMe"
                                                            lang:LanguageENGLISH
                                                      merchantId: merchantId
                                                          remark:@""
                                                          payRef:@""
                                                      resultpage:resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?" extraData:nil];
    
    paySDK.paymentDetails.callBackParam = [[CallBackParam alloc] initWithSuccessUrl:@"DemoApp-Objc://success"                                                           cancelUrl : @"DemoApp-Objc://cancel"
                                                                           errorUrl: @"DemoApp-Objc://error"
                                                                           failUrl : @"DemoApp-Objc://fail"];
    
    [paySDK process];
}

- (IBAction)threeDS:(id)sender{
    ThreeDSParams *threeDSParams = [[ThreeDSParams alloc] init];
    threeDSParams.threeDSCustomerEmail = @"example@example.com";
    threeDSParams.threeDSDeliveryEmail = @"example@example.com";
    threeDSParams.threeDSMobilePhoneCountryCode = @"852";
    threeDSParams.threeDSMobilePhoneNumber = @"9000000000";
    threeDSParams.threeDSHomePhoneCountryCode = @"852";
    threeDSParams.threeDSHomePhoneNumber = @"8000000000";
    threeDSParams.threeDSWorkPhoneCountryCode = @"852";
    threeDSParams.threeDSWorkPhoneNumber = @"7000000000";
    threeDSParams.threeDSBillingCountryCode = @"344";
    threeDSParams.threeDSBillingState = @"";
    threeDSParams.threeDSBillingCity = @"Hong Kong";
    threeDSParams.threeDSBillingLine1 = @"threeDSBillingLine1";
    threeDSParams.threeDSBillingLine2 = @"threeDSBillingLine2";
    threeDSParams.threeDSBillingLine3 = @"threeDSBillingLine3";
    threeDSParams.threeDSBillingPostalCode = @"121245";
    threeDSParams.threeDSShippingDetails = @"01";
    threeDSParams.threeDSShippingCountryCode = @"344";
    threeDSParams.threeDSShippingState = @"";
    threeDSParams.threeDSShippingCity = @"Hong Kong";
    threeDSParams.threeDSShippingLine1 = @"threeDSShippingLine1";
    threeDSParams.threeDSShippingLine2 = @"threeDSShippingLine2";
    threeDSParams.threeDSShippingLine3 = @"threeDSShippingLine3";
    threeDSParams.threeDSAcctCreateDate = @"20190401";
    threeDSParams.threeDSAcctAgeInd = @"01";
    threeDSParams.threeDSAcctLastChangeDate = @"20190401";
    threeDSParams.threeDSAcctLastChangeInd = @"01";
    threeDSParams.threeDSAcctPwChangeDate = @"20190401";
    threeDSParams.threeDSAcctPwChangeInd = @"01";
    threeDSParams.threeDSAcctPurchaseCount = @"10";
    threeDSParams.threeDSAcctCardProvisionAttempt = @"0";
    threeDSParams.threeDSAcctNumTransDay = @"0";
    threeDSParams.threeDSAcctNumTransYear = @"1";
    threeDSParams.threeDSAcctPaymentAcctDate = @"20190401";
    threeDSParams.threeDSAcctPaymentAcctInd = @"01";
    threeDSParams.threeDSAcctShippingAddrLastChangeDate = @"20190401";
    threeDSParams.threeDSAcctShippingAddrLastChangeInd = @"01";
    threeDSParams.threeDSAcctIsShippingAcctNameSame = @"T";
    threeDSParams.threeDSAcctIsSuspiciousAcct = @"F";
    threeDSParams.threeDSAcctAuthMethod = @"01";
    threeDSParams.threeDSAcctAuthTimestamp = @"20190401";
    threeDSParams.threeDSDeliveryTime = @"04";
    threeDSParams.threeDSPreOrderReason = @"01";
    threeDSParams.threeDSPreOrderReadyDate = @"20190401";
    threeDSParams.threeDSGiftCardAmount = @"5";
    threeDSParams.threeDSGiftCardCurr = @"344";
    threeDSParams.threeDSGiftCardCount = @"1";
    threeDSParams.threeDSSdkMaxTimeout = @"05";
    threeDSParams.threeDSSdkInterface = @"03";
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"THREEDS2"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"123"
                                                          payRef: @""
                                                      resultpage: resultPage showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    paySDK.paymentDetails.cardDetails = [[CardDetails alloc] initWithCardHolderName:@"Test Card" cardNo:cardNoText.text expMonth:expMonthText.text expYear:expYearText.text securityCode:securityCodeText.text];
    
    paySDK.paymentDetails.threeDSParams = threeDSParams;
    [paySDK process];
    
}


- (IBAction)NewPayment:(id)sender{
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelEASYPAYMENTFORM
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"ALL"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"123"
                                                          payRef: @""
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}


- (IBAction)applePay:(id)sender{
    NSDictionary *arr = @{@"apple_countryCode" : @"US",
                          @"apple_currencyCode" : @"USD",
                          @"apple_billingContactEmail" : @"abc@gmail.com",
                          @"apple_billingContactPhone" : @"1234567890",
                          @"apple_billingContactGivenName" : @"ABC",
                          @"apple_billingContactFamilyName" : @"XYZ",
                          @"apple_requiredBillingAddressFields" : @"",
                          @"apple_merchant_name" : @"Demo",
                          @"apple_merchantId" : @"com.merchant.asiapay.applepay.demo"
    };
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelDIRECT
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000000000]
                                                       payMethod:@"APPLEPAY"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"test"
                                                          payRef: @""
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:arr];
    //paysdk.paymentDetails.cardDetails = [[CardDetails alloc] initWithCardHolderName:@"asd asd" cardNo:@"4444333322221111" expMonth:@"12" expYear:@"2022" securityCode:@"123"];
    [paySDK process];
}


- (IBAction)hostedWithCD:(id)sender{
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelWEBVIEW
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"VISA"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"123"
                                                          payRef: @""
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK process];
}

- (IBAction)payOption:(id)sender{
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelNONE
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"ALL"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"123"
                                                          payRef: @"" //@"7862308"
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK queryWithAction:@"PAYMENT_METHOD"];
}

- (IBAction)transQuery:(id)sender{
    
    paySDK.paymentDetails = [[PayData alloc] initWithChannelType:PayChannelNONE
                                                         envType:EnvTypeSANDBOX
                                                          amount:@"1"
                                                         payGate:PayGatePAYDOLLAR
                                                        currCode:CurrencyCodeHKD
                                                         payType:payTypeNORMAL_PAYMENT
                                                        orderRef: orderRef
                                                       payMethod:@"ALL"
                                                            lang:LanguageENGLISH
                                                      merchantId:merchantId
                                                          remark:@"123"
                                                          payRef: @"" //@"7862308"
                                                      resultpage: resultPage
                                                 showCloseButton: true
                                                     showToolbar: true
                                              webViewClosePrompt: @"Do you want to close?"
                                                       extraData:nil];
    
    [paySDK queryWithAction:@"TX_QUERY"];
}


-(void)paymentResultWithResult:(PayResult * _Nonnull)result {
    NSString *resultString = [NSString stringWithFormat:@"amount - %@ \nsuccessCode - %@ \nmaskedCardNo - %@ \nauthId - %@ \ncardHolder - %@ \ncurrencyCode - %@ \nerrMsg - %@ \nord - %@ \npayRef - %@ \nprc - %@ \nref - %@ \nsrc - %@ \ntransactionTime - %@ \ndescriptionStr - %@", result.amount,result.successCode,result.maskedCardNo,result.authId,result.cardHolder,result.currencyCode,result.errMsg,result.ord,result.payRef,result.prc,result.ref,result.src,result.transactionTime,result.descriptionStr];
    payResultTextvW.text = resultString;
    
    NSLog(@"%@", result.errMsg);
    NSLog(@"%@", result.successCode);
    NSLog(@"%@", result.maskedCardNo);
    NSLog(@"%@", result.ref);
    NSLog(@"%@", result.transactionTime);
    NSLog(@"%@", result.cardHolder);
}

- (void)showProgress {
    
}


- (void)hideProgress {
    
}

- (void)payMethodOptionsWithMethod:(PaymentOptionsDetail * _Nonnull)method {
    NSLog(@"%@", method);
}


- (void)transQueryResultsWithResult:(TransQueryResults * _Nonnull)result {
    NSLog(@"%@", result);
    
    if (result.detail != nil) {
        NSArray *resultArray = result.detail;// ? else { return ["errMsg": "Error"] }
        
        NSLog(@"amount - %@ \norderStatus - %@\nsuccessCode - %@ \nauthId - %@ \nremark - %@ \ncardHolder - %@ \ncurrencyCode - %@ \nerrMsg - %@ \nord -%@ \npayRef - %@\nprc - %@ \nsrc -%@ \ntransactionTime - %@ \ncardIssuingCountry- %@ \nRef -%@ \neci %@ \nipCountry - %@ "")\nchannelType - %@\nmerchantId  - %@ \npayerAuth  - %@ \npanLast4  - %@ \npayMethod  - %@ \nord  - %@\npanFirst4  - %@\nalertCode  - %@ \nsourceIp  - %@",  resultArray[0], resultArray[1],resultArray[2],resultArray[3],resultArray[4],resultArray[5],resultArray[6],resultArray[7],resultArray[8],resultArray[9],resultArray[10],resultArray[11],resultArray[12],resultArray[13],resultArray[14],resultArray[15],resultArray[16],resultArray[17],resultArray[18],resultArray[19],resultArray[20],resultArray[21],resultArray[22],resultArray[23],resultArray[24],resultArray[25]);
    }
}



#pragma mark - textField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == mIdText) {
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == mIdText) {
        
    }
    
    return YES;
}

#pragma mark - textView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    BOOL isResignedFirstResponder = [self resignFirstResponder];
    
    if (isResignedFirstResponder == YES )
    {
        
    }
}
/**     doneAction. Resigning current textField. */
//-(void)doneAction:(IQBarButtonItem*)barButton
//{
//
//    BOOL isResignedFirstResponder = [self resignFirstResponder];
//
//    if (isResignedFirstResponder == YES && barButton.invocation)
//    {
////        [barButton.invocation invokeFrom:self];
//        [barButton.invocation invoke];
//    }
//}


@end



