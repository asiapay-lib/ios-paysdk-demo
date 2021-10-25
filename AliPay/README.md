
# AliPay

## Initialization Step: 

* Add URL Type in info .plist file 

![image](https://user-images.githubusercontent.com/57220911/79874665-475a6c80-8406-11ea-9023-91ea84b50dac.png)

* In AppDelegate file add

var paySDK = PaySDKClass.shared


func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
			paySDK.processOrder(url: url)
			return true
}

* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: "10",
                                payGate: PayGate.PAYDOLLAR,
                                currCode:CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "560200353Ref",
                                payMethod: "ALIPAYHKAPP", // FOR ALIPAY HK
                                //payMethod: "ALIPAYCNAPP" // FOR ALIPAY CN
                                //payMethod: "ALIPAYAPP" // FOR ALIPAY GLOBAL
                                lang: Language.ENGLISH, 
                                merchantId: "560200353",
                                remark: "test",
                                payRef: "",
                                resultPage: "F",
                                showCloseButton: false,
                                showToolbar: false,
                                webViewClosePrompt: "",
                                extraData : [:])

paySDK.process();

```

* Objective C Code
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT 
                                         envType: EnvTypeSANDBOX 
                                         amount: @"1.0" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: orderRef 
                                         payMethod: @"ALIPAYHKAPP" // FOR ALIPAY HK
                                         //payMethod: @"ALIPAYCNAPP" // FOR ALIPAY CN
                                         //payMethod: @"ALIPAYAPP" // FOR ALIPAY GLOBAL
                                         lang: LanguageENGLISH 
                                         merchantId: merchantId 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: false
                                         showToolbar: false
                                         webViewClosePrompt: @""
                                         extraData: nil];

[paySDK process];
```
