# WeChat

Merchant must provide application bundle id and universal link of app (optional) to PayDollar. PayDollar will provide app key for WeChat Pay services.

## Initialization Step: 

* Add URL Type in info .plist file 

```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>weixinULAPI</string>
	<string>weixin</string>
</array>
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>weixin</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>WECHAT-APP-ID</string>
		</array>
	</dict>
</array>
    
```
![image](https://user-images.githubusercontent.com/57219862/80564609-e20d0980-8a0b-11ea-9779-dbc96a40d4eb.png)
    
* In AppDelegate file add
```
	var paySDK = PaySDKClass.shared

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        	paySDK.processOrder(url: url)
       	 	return true;
	}
    
```
* Initialize PayData
* Swift Code
```
paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                envType: EnvType.SANDBOX,
                                amount: 0.1,
                                payGate: PayGate.PAYDOLLAR,
                                currCode: CurrencyCode.HKD,
                                payType: payType.NORMAL_PAYMENT,
                                orderRef: "2018102409220001",
                                payMethod: "WECHATAPP",
                                lang: Language.ENGLISH,
                                merchantId: "1",
                                remark: "test",
                                payRef: "",
                                resultpage: @"F",
                                showCloseButton: false,
                                showToolbar: true,
                                webViewClosePrompt: "",
                                extraData : ["weChatUniversalLink":"https://<domain-name>.com"])
                                
paySDK.process()

```

* Objective C Code
```
NSDictionary *dic =@{@"wechatUniversalLink": @"https://<domain-name>.com"};

extraData = [[NSMutableDictionary alloc] initWithDictionary: dic];

paySDK.paymentDetails = [[PayData alloc] initWithChannelType: PayChannelDIRECT                                                             
                                         envType: EnvTypeSANDBOX 
                                         amount: @"1.0" 
                                         payGate: PayGatePAYDOLLAR 
                                         currCode: CurrencyCodeHKD 
                                         payType: payTypeNORMAL_PAYMENT 
                                         orderRef: @"2018102409220001" 
                                         payMethod: @"WECHATAPP" 
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
