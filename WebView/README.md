

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
                                extraData:[:])

                
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
                                         extraData: nil];

[paySDK process];
```
