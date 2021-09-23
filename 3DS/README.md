

# 3DS2.0 Payment
* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount : “10”,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "2018102409220001”,
                                payMethod: "THREEDS2",
                                lang: Language.ENGLISH,
                                merchantId: "1",
                                remark: "",
                                payRef: "",
                                resultpage: "F",
                                showCloseButton: false,
                                extraData :[:])

paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: “abcabc”,
                                                cardNo: "4918914107195011”,
                                                expMonth: “11”,
                                                expYear: “2011”,
                                                securityCode: “123”)
                                                
var threeDSParams = ThreeDSParams()

threeDSParams.threeDSCustomerEmail = "example@example.com"
.
.
.
threeDSParams.threeDSDeliveryEmail = "example1@example.com"

paySDK.paymentDetails.threeDSParams = threeDSParams

paySDK.process();

```

<img width="220" alt="image" src="https://user-images.githubusercontent.com/57219862/80250494-9c5de300-8691-11ea-8f69-70cc480f38ca.png"> <img width="220" alt="image" src="https://user-images.githubusercontent.com/57219862/80250511-a54eb480-8691-11ea-8162-f1cb006680e4.png">
<img width="220" alt="image" src="https://user-images.githubusercontent.com/57219862/80250532-ae3f8600-8691-11ea-90ab-4e887e6e7391.png">

* Objective C Code
```
ThreeDSParams *threeDSParams = [[ThreeDSParams alloc] init];
threeDSParams.threeDSCustomerEmail = @"example@example.com";
.
.
.
threeDSParams.threeDSDeliveryEmail = @"example@example.com";

paySDK.paymentDetails.threeDSParams = threeDSParams;

paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelWEBVIEW
                                         envType: EnvTypeSANDBOX
                                         amount: @"1"
                                         payGate: PayGatePAYDOLLAR
                                         currCode: CurrencyCodeHKD
                                         payType: payTypeNORMAL_PAYMENT
                                         orderRef: orderRef
                                         payMethod: @"THREEDS2"
                                         lang: LanguageENGLISH
                                         merchantId: @"1234"
                                         remark: @"123"
                                         payRef: @""
                                         resultpage: @"F"
                                         showCloseButton: false,
                                         extraData: nil];
                                                   
[paySDK process];
```
