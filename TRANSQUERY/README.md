# Transaction Query

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
                                resultPage: "F"
                                showCloseButton: false,
                                showToolbar: true,
                                webViewClosePrompt: "",
                                extraData : [:])

paySDK.query(action:"TX_QUERY")

 //NOTE : For Trans Query Response will come in below format 
 func transQueryResults(result: TransQueryResults) {
       //PROCESS RESPONSE
 }
 ```
* Objective C Code 
```
paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT
                                                     envType: EnvTypeSANDBOX
                                                      amount: @"1"
                                                     payGate: PayGatePAYDOLLAR
                                                    currCode: CurrencyCodeHKD
                                                     payType: payTypeNORMAL_PAYMENT
                                                    orderRef: @"2018102409220001"
                                                   payMethod: @"ALL"
                                                        lang: LanguageENGLISH
                                                  merchantId: merchantId
                                                      remark: @"123"
                                                      payRef: @"" 
                                                  resultpage: @"F"
                                                  showCloseButton: false
                                                  showToolbar: true
                                                  webViewClosePrompt: @""
                                                   extraData: nil];

[paySDK queryWithAction:@"TX_QUERY"];

//NOTE : For Trans Query Response will come in below format
- (void)transQueryResultsWithResult:(TransQueryResults * _Nonnull)result {
        //PROCESS RESPONSE
}

```
