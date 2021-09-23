


# Promo Pay
* Swift Code
```
paySDK.cardDetails = CardDetails(cardHolderName: “firstcard”,
                                 cardNo: "4012000000020086”,
                                 expMonth: “07”,
                                 expYear: “2030”,
                                 securityCode: “123”)

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
                                showCloseButton: false,
                                extraData :  extraData: ["promotion ": "T",
                                                         "promotionCode ": "TEST1",
                                                         "promotionRuleCode " : " TESTR25",
                                                         "promotionOriginalAmt ":""])

paySDK.process()

```

<img width="255" alt="image" src="https://user-images.githubusercontent.com/57219862/80248070-dc6e9700-868c-11ea-8479-4bff9cfe0da0.png">


*Objective C Code
```
NSDictionary *dic = @{@"promotion": @"T",
                    @"promotionCode": @"TEST1",
                    @"promotionRuleCode" : @"TESTR25",
                    @"promotionOriginalAmt": @"5"};
                     
extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];

paySDK. paymentDetails.cardDetails = CardDetails(cardHolderName: "abc abc",
                                                 cardNo: "1234567890123456”,
                                                 expMonth: "11",
                                                 expYear: "2011",
                                                 securityCode: "123")
```
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT                                                             envType: EnvTypeSANDBOX 
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
                                         resultpage: "@F" 
                                         showCloseButton: false,
                                         extraData: extraData];

[paySDK process];
```
