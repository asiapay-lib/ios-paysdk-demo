

# Webview Payment
* Swift Code
```
paySDK.paymentDetails = PayData(channelType : PayChannel.WEBVIEW,
                                envType : EnvType.SANDBOX,
                                amount :"1"
                                payGate : PayGate.PAYDOLLAR,
                                currCode : CurrencyCode.HKD,
                                payType : payType.NORMAL_PAYMENT,
                                orderRef : “2018102409220001”,
                                payMethod : "CC",
                                lang : Language.ENGLISH,
                                merchantId : "88144121",
                                remark : "",
                                payRef: "",
                                resultPage:"F",
                                showCloseButton: true,
                                showToolbar: true,
                                webViewClosePrompt: "Do you want to close?",
                                extraData:[:])

//For giving the merchant app rootviewcontroller to present webview. Its an optional parameter.
paysdk.paymentDetails.presentController = PresentViewController(presentViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
                
paySDK.process();

```
![image](https://user-images.githubusercontent.com/57220911/79873293-8e476280-8404-11ea-8817-59081fa87b1f.png)![image](https://user-images.githubusercontent.com/57220911/79873309-943d4380-8404-11ea-98d0-e6ae7814472c.png)


* Objective C Code
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW                                                            envType: EnvTypeSANDBOX 
                                         amount: @"10" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: @"abcde12345" 
                                         payMethod: @"CC" 
                                         lang: LanguageENGLISH 
                                         merchantId: @"1" 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: true,
                                         showToolbar: true,
                                         webViewClosePrompt: @"Do you want to close?",
                                         extraData: nil];
                                         
 //For giving the merchant app rootviewcontroller to present webview. Its an optional parameter.
paysdk.paymentDetails.presentController = [[PresentViewController alloc]    initWithPresentViewController:[[[UIApplication sharedApplication]keyWindow]rootViewController]];

[paySDK process];
```

//PaySDK will trigger payment result handle with failed status at WebView integration if the requested url scheme is failed to trigger.

//Merchant can prompt the message for this case and ignore the result handle if they received the error message started with "No app installed to handle the request"

```
func paymentResult(result: PayResult) {
        if (result.errMsg.starts(with: "No app installed to handle the request with scheme")) {
                // ignore the result or prompt the app is not installed
        } else {
                // process fail or success
        }
}
```
