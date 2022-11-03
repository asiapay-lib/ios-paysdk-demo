# Octopus Pay

## Initialization Step: 

* Add LSApplicationQueriesSchemes in info .plist file 

```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>octopus</string>
</array>
```

### Initialize PayData
* Swift Code
```swift
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: 0.1,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "2018102409220001",
                                payMethod: "OCTOPUS",
                                lang: Language.ENGLISH,
                                merchantId: "1",
                                remark: "test",
                                payRef: "",
                                resultpage: "F",
                                showCloseButton: false,
                                showToolbar: true,
                                webViewClosePrompt: "",
                                extraData : [:])

paysdk.paymentDetails.callBackParam = CallBackParam(successUrl: "xxx://abc//success",
                                                    cancelUrl: "xxx://abc//cancelled",
                                                    errorUrl: "xxx://abc//error",
                                                    failUrl: "xxx://abc//fail")
paySDK.process()

```
* Objective C Code
```objc
NSDictionary *dic =@{@"eVoucher": @"T",
                     @"eVClassCode": @"0001"};
                     
extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
```
```objc
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW                                                            envType: EnvTypeSANDBOX 
                                         amount: @"2.0" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: orderRef 
                                         payMethod: @"OCTOPUS" 
                                         lang: LanguageENGLISH 
                                         merchantId: merchantId 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F"
                                         showCloseButton: false,
                                         showToolbar: true
                                         webViewClosePrompt: @""
                                         extraData: nil];

paySDK.paymentDetails.callBackParam = [[CallBackParam alloc] initWithsuccessUrl: @"xxx://abc//success"
                                                             cancelUrl: @"xxx://abc//cancelled"
                                                             errorUrl: @"xxx://abc//error"
                                                             failUrl: @"xxx://abc//fail"];
[paySDK process];
```

### Collect Payment Result

```swift
    func paymentResult(result: PayResult) {
     //process result here
     
    }


//PaySDK will trigger payment result handle with failed status at WebView integration if the requested url scheme is failed to trigger.

//Merchant can prompt the message for this case and ignore the result handle if they received the error message started with "No app installed to handle the request"


func paymentResult(result: PayResult) {
        if (result.errMsg.starts(with: "No app installed to handle the request with scheme")) {
                // ignore the result or prompt the app is not installed
        } else {
                // process fail or success result here
        }
}
```
* Note: On successfull transaction orderRef and payref will get in callback as url.

Use orderRef and payref from callback url to check [Transaction Status](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/TRANSQUERY).



