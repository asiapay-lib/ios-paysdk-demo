

# Member Pay

## New Member -
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
                                payRef: "", 
                                resultpage: "F",
                                showCloseButton: false,
                                showToolbar: true,
                                webViewClosePrompt: "",
                                extraData: ["addNewMember": true,
                                            "memberPay_service": "T",
                                            "memberPay_memberId": "Member01",
                                            "memberPay_token":""])

paySDK.process()

```

<img width="243" alt="image" src="https://user-images.githubusercontent.com/57219862/80246803-a7614500-868a-11ea-8563-f912d1696ec3.png">

* Objective C Code
```
NSDictionary *dic = @{@"addNewMember": true,
                    @"memberPay_service": @"T",
                    @"memberPay_memberId" : @"Member01",
                    @"memberPay_token": @""};
                     
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
                                         merchantId: @"1" 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: false
                                         showToolbar: true
                                         webViewClosePrompt: @""
                                         extraData: extraData];

[paySDK process];
```
## Old Member -
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
                                currCode: currencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "2018102409220001”,
                                payMethod: "VISA",
                                lang: Language.ENGLISH,
                                merchantId: "88146271",
                                remark: "",
                                payRef: "",
                                resultpage: "F",
                                showCloseButton: false,
                                extraData: ["addNewMember": false,
                                            "memberPay_service": "T",
                                            "memberPay_memberId": "Member01",
                                            "token":"8de18f7b17fabe5bb682e792e319c0e411b528f5892622"])

paySDK.process()

```

<img width="248" alt="image" src="https://user-images.githubusercontent.com/57219862/80247989-b1844300-868c-11ea-9088-e3872811ee09.png">

* Objective C Code
```
NSDictionary *dic = @{@"addNewMember": false,
                    @"memberPay_service": @"T",
                    @"memberPay_memberId" : @"Member01",
                    @"token": "8de18f7b17fabe5bb682e792e319c0e411b528f5892622"};
                     
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
                                         merchantId: @"1" 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: false,
                                         extraData: extraData];

[paySDK process];
```
