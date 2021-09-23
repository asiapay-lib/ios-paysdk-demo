

# Direct Payment

* Swift Code
```
paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: “first card”,
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
                                extraData :[:])

paySDK.process()

```
<img width="254" alt="image" src="https://user-images.githubusercontent.com/57219862/80223077-6d317c80-8665-11ea-96c4-61e46dca606a.png">

* Objective C Code
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT                                                              envType: EnvTypeSANDBOX 
                                         amount: amountText.text 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: orderRef 
                                         payMethod: @"VISA" 
                                         lang: LanguageENGLISH 
                                         merchantId: merchantId 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: resultPage 
                                         showCloseButton: false, 
                                         extraData: nil];

paySDK.paymentDetails.cardDetails = [[CardDetails alloc] initWithCardHolderName: @"Test Card"                                                              cardNo: cardNoText.text                                                                           expMonth: expMonthText.text 
                                                         expYear: expYearText.text 
                                                         securityCode: securityCodeText.text];

[paySDK process];
```
