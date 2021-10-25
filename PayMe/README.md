# PayMe

### Initialize PayData
* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: 0.1,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000),
                                payMethod: "PayMe",
                                lang: Language.ENGLISH,
                                merchantId: "1",
                                remark: "test",
                                payRef: "",
                                resultpage: resultPage,
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

```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT
                                         envType: EnvTypeSANDBOX 
                                         amount: @"2.0" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: orderRef 
                                         payMethod: @"PayMe" 
                                         lang: LanguageENGLISH 
                                         merchantId: 1 
                                         remark: @"test" 
                                         payRef: ""
                                         resultpage: resultPage
                                         showCloseButton: false
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

```
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
* Note: On successfull transaction orderId will get in PayResult as OrderId.

Use OrderId from PayResult to check [Transaction Status](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/TRANSQUERY).



