
# EVoucher
* Swift Code
```
extraData = ["eVoucher": "T",
             "eVClassCode": "0001"]
```

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
                                resultpage: "F",
                                showCloseButton: false,
                                extraData: extraData)

                
paySDK.process();

```
* Objective C Code
```
NSDictionary *dic =@{@"eVoucher": @"T",
                     @"eVClassCode": @"0001"};
                     
extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];
```
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW                                                            envType: EnvTypeSANDBOX 
                                         amount: @"2.0" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: orderRef 
                                         payMethod: @"VISA" 
                                         lang: LanguageENGLISH 
                                         merchantId: merchantId 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: false,
                                         extraData: nil];

[paySDK process];
```

