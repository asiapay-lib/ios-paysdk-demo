

# Schedule Pay
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
                                extraData: ["appId" : "SP",
                                            "appRef" : "2018102409220001",
                                            "schType" : "Day",
                                            "schStatus" : "Active",
                                            "nSch" : "3",
                                            "sMonth" : "04",
                                            "sDay" : "20",
                                            "sYear" : "2021",
                                            "eMonth" : "",
                                            "eDay" : "",
                                            "eYear" : "",
                                            "name" : "Julius Jha",
                                            "email" : "julius.jha@gmail.com"])


paySDK.process()

```

<img width="252" alt="image" src="https://user-images.githubusercontent.com/57219862/80248316-4b4bf000-868d-11ea-87cc-7c86135fcc8c.png">

* Objective C Code
```
NSDictionary *dic = @{@"appId" : @"SP",
                      @"appRef" : @"2018102409220001",
                      @"schType" : @"Day",
                      @"schStatus" : @"Active",
                      @"nSch" : @"1",
                      @"sMonth" : @"4",
                      @"sDay" : @"26",
                      @"sYear" : @"2019",
                      @"eMonth" : @"",
                      @"eDay" : @"",
                      @"eYear" : @"",
                      @"name" : @"Name",
                      @"email" : @"name@abc.com"};

extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];

paySDK.paymentDetails.cardDetails = [[CardDetails alloc] initWithCardHolderName:@"Test Card"                                                               cardNo:cardNoText.text                                                                            expMonth:expMonthText.text 
                                                         expYear:expYearText.text securityCode:securityCodeText.text];
                                                         
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT                                                             envType: EnvTypeSANDBOX 
                                         amount: @"2" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: @"2018102409220001” 
                                         payMethod: @"VISA" 
                                         lang: LanguageENGLISH 
                                         merchantId: @"1" 
                                         remark: @"" 
                                         payRef: @"" 
                                         resultpage: @"F" 
                                         showCloseButton: false,
                                         extraData: extraData];
```
