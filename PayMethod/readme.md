# Pay Method

* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount :“1”,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "2018102409220001”,
                                payMethod: "VISA",
                                lang: Language.ENGLISH,
                                merchantId: "88146271",
                                remark: "",
                                payRef: "",
                                resultpage: "F",
                                showCloseButton: false,
                                extraData : [])
                                
paySDK.query(action: "PAYMENT_METHOD")

//NOTE : For allowed Pay Method Response will come in below format 

func payMethodOptions(method: PaymentOptionsDetail) {
        //process the method       
}
```
* Objective C Code
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelNONE
                                         envType: EnvTypeSANDBOX
                                         amount: @"1"
                                         payGate: PayGatePAYDOLLAR
                                         currCode: CurrencyCodeHKD
                                         payType: payTypeNORMAL_PAYMENT
                                         orderRef: "2018102409220001”,
                                         payMethod: @"ALL"
                                         lang: LanguageENGLISH
                                         merchantId: @"1"
                                         remark: @"123"
                                         payRef: @""
                                         resultpage: resultPage
                                         showCloseButton: false
                                         extraData: nil];

[paySDK queryWithAction:@"PAYMENT_METHOD"];

//NOTE : For allowed Pay Method Response will come in below format 
- (void)payMethodOptionsWithMethod:(PaymentOptionsDetail * _Nonnull)method {
        //process the method       
}
```
