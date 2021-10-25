# Apple Pay

## Initialization Step: 

 1. Add framework to the App
      `PassKit.framework`

 2. In Xcode , Under “Capabilities”, turn on Apple Pay, and ensure that you have selected the correct merchant ID
    (If you don’t see yours, try tapping the + and enter the name of your merchant ID).
    
    <img width="451" alt="ApplePay1" src="https://user-images.githubusercontent.com/57219862/86749288-c00eb380-c05a-11ea-83f2-55e7f011547a.png">

3. Add merchant ID in app entitlements file

    <img width="451" alt="ApplePay2" src="https://user-images.githubusercontent.com/57219862/86733970-41604900-c04f-11ea-9f8f-99887444e894.png">


### Set the Apple Pay button:
   Set the button type and button style for the button as
   

    btnApplePay.setApplePayButton(btnType: ApplePayButtonType.Buy, btnStyle: ApplePayButtonStyle.Black, view : self.view)
    
### SDK Side Call
#### Swift Code
    Note: It is mandatory to add "apple_merchantId" in extraData.
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: "10",
                                payGate: PayGate.PAYDOLLAR,
                                currCode:CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "560200353Ref",
                                payMethod: "APPLEPAY",
                                lang: Language.ENGLISH, 
                                merchantId: "560200353",
                                remark: "test",
                                payRef: "",
                                resultpage: "F",
                                showCloseButton: false,
                                showToolbar: false,
                                webViewClosePrompt: "",
                                extraData : ["apple_countryCode" : "HK",
                                             "apple_currencyCode" : "HKD",
                                             "apple_billingContactEmail" : "abc@gmail.com",
                                             "apple_billingContactPhone" : "1234567890",
                                             "apple_billingContactGivenName" : "ABC",
                                             "apple_billingContactFamilyName" : "XYZ",
                                             "apple_requiredBillingAddressFields" : "",
                                             "apple_merchant_name" : "AsiapayDemo",
                                             "apple_merchantId" : "com.merchant.asiapay.applepay.demo"])

paySDK.process()
```

#### Objective C Code
    Note: It is mandatory to add "apple_merchantId" in extraData.
```
NSDictionary *arr = @{@"apple_countryCode" : @"HK",
                      @"apple_currencyCode" : @"HKD",
                      @"apple_billingContactEmail" : @"abc@gmail.com",
                      @"apple_billingContactPhone" : @"1234567890",
                      @"apple_billingContactGivenName" : @"ABC",
                      @"apple_billingContactFamilyName" : @"XYZ",
                      @"apple_requiredBillingAddressFields" : @"",
                      @"apple_merchant_name" : @"Asiapay",
                      @"apple_merchantId" : @"com.merchant.asiapay.applepay.demo"
};
                      
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT
                                         envType: EnvTypeSANDBOX
                                         amount: @"1"
                                         payGate: PayGatePAYDOLLAR
                                         currCode: CurrencyCodeHKD
                                         payType: payTypeNORMAL_PAYMENT
                                         orderRef: [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000000000]
                                         payMethod: @"APPLEPAY"
                                         lang: LanguageENGLISH
                                         merchantId: @"1"
                                         remark: @"test"
                                         payRef: @""
                                         resultpage: resultPage
                                         showCloseButton: false
                                         showToolbar: false
                                         webViewClosePrompt: ""
                                         extraData: arr];

[paySDK process];
```

### Merchant Side Call
#### Swift Code

- Generate eWalletPaymentData as 
```
func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void)
{
    var dicStr = ""
    var parameterDict = [String: Any]()
    
    do {
        let paymentDataDic = try JSONSerialization.jsonObject(with: payment.token.paymentData, options:[]) as! [String : Any]
        let paymentDataJson = ["token": ["paymentData":paymentDataDic,
                                         "transactionIdentifier":payment.token.transactionIdentifier,
                                         "paymentMethod" : [
                                         "displayName":payment.token.paymentMethod.displayName,
                                         "network":payment.token.paymentMethod.network?.rawValue,
                                         "type":"\(payment.token.paymentMethod.type.rawValue)"]]] as [String : Any]
        
        b64TokenStr = try! JSONSerialization.data(withJSONObject: paymentDataJson, options: []).base64URLEncodedString()
   } catch _ { }
}
```
- Pass the generated b64TokenStr to extraData as eWalletPaymentData 

```
paysdk.paymentDetails = PayData(channelType: .DIRECT,
                                envType: .SANDBOX,
                                amount: "1",
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000),
                                payMethod: "",
                                lang: Language.ENGLISH,
                                merchantId: merchantId,
                                remark: "123",
                                payRef: "",
                                resultpage: resultPage,
                                showCloseButton: false,
                                showToolbar: false,
                                webViewClosePrompt: "",
                                extraData: ["eWalletPaymentData" : b64TokenStr])
paysdk.process()
```
#### Objective C Code
- Generate eWalletPaymentData as 
```
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion
{
     do {
         let paymentDataDic = try JSONSerialization.jsonObject(with: payment.token.paymentData, options:[]) as! [String : Any]
         let paymentDataJson = ["token": ["paymentData":paymentDataDic,
                                          "transactionIdentifier":payment.token.transactionIdentifier,
                                          "paymentMethod" : [
                                          "displayName":payment.token.paymentMethod.displayName,
                                          "network":payment.token.paymentMethod.network?.rawValue,
                                          "type":"\(payment.token.paymentMethod.type.rawValue)"]]] as [String : Any]
         
         b64TokenStr = try! JSONSerialization.data(withJSONObject: paymentDataJson, options: []).base64URLEncodedString()
    } catch _ { }
}

```
- Pass the generated b64TokenStr to extraData as eWalletPaymentData 

```
NSDictionary *arr = @{@"eWalletPaymentData" : b64TokenStr};
                      
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT
                                         envType: EnvTypeSANDBOX
                                         amount: @"1"
                                         payGate: PayGatePAYDOLLAR
                                         currCode: CurrencyCodeHKD
                                         payType: payTypeNORMAL_PAYMENT
                                         orderRef: [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000000000]
                                         payMethod: @"APPLEPAY"
                                         lang: LanguageENGLISH
                                         merchantId: @"1"
                                         remark: @"test"
                                         payRef: @""
                                         resultpage: resultPage
                                         showCloseButton: false
                                         showToolbar: false
                                         webViewClosePrompt: @""
                                         extraData: arr];

[paySDK process];
```
