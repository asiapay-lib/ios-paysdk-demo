# Octopus Pay

## Initialization Step: 

* Add "Domain" – Here you need to specify third level domain. (www/xp1) in paysdk.plist file.


### Initialize PayData
* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: 0.1,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: currencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000),
                                payMethod: "PayMe",
                                lang: Language.ENGLISH,
                                merchantId: "1",
                                remark: "test",
                                payRef: "",
                                resultpage: "F",
                                extraData : [:])

paysdk.paymentDetails.callBackParam = CallBackParam(successUrl : "xxx://abc//success",
                                                    cancelUrl : "xxx://abc//cancelled",
                                                    errorUrl: "xxx://abc//error",
                                                    failUrl : "xxx://abc//fail")
                                                    
paySDK.process()

```
* Objective C Code

```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW                                                                 envType: EnvTypeSANDBOX 
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
                                         extraData: nil];
                                         
paySDK.paymentDetails.callBackParam = [[CallBackParam alloc] initWithsuccessUrl: @"xxx://abc//success"                                                              cancelUrl: @"xxx://abc//cancelled",
                                                             errorUrl : @"xxx://abc//success",
                                                             failUrl : @"xxx://abc//cancelled"];

[paySDK process];
```

