
## PaySDK   
##### iOS SDK which seamlessly integrate PayDollar Payment Gateway

### Overview

##### AsiaPay offers comprehensive and flexible payment services and solutions.Via our state-of the-art secure multi-currency, multi-lingual and multi-channel processing platform, we offer payment acceptance flexibility for Direct Merchant Account or Master Account offerings, with options for credit card and direct debit acceptance, whether online, MOTO or call centre and popular mobile wallets.

### How it works
#### The cardholder inputs their bank account/card details on the PayDollar Checkout form in order to pay for a product/service.The transaction amount is routed via the card networks to PayDollar's acquiring banking partners. Once PayDollar receives the amount, it is settled to your bank account after fees deduction.

### Get Started

1. [PaySdk Configuration](#paysdk-configuration)
2. [Add Security Key](#add-security-key)
3. [Initialize PaySdk](#initialize-paysdk)
4. [Initialize Payload](#initialize-payload)
5. [Collect Payment Result](#collect-payment-result)

### PaySdk Configuration

*  Requirements
Swift Version: 4.0 and above
iOS Version: 11.0 and above


* Download the latest sdk from https://github.com/asiapay-lib/paysdk-ios-lib

* Add `AP_PaySDK.framework` file into your project by adding the dependencies in Build Phases / Link Binary With Libraries
 
* Or use CocoaPods. CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit https://guides.cocoapods.org/using/using-cocoapods.html for more detail. To integrate PaySDK into your Xcode project using CocoaPods, specify it in your Podfile:

  ```
    pod 'AP_PaySDK', '2.6.19'
    
  ```
 
  ![image](https://user-images.githubusercontent.com/57219862/81049934-cb1f5900-8edc-11ea-9c95-9dfa2bb3833a.png)

* Import sdk into the class

   import AP_PaySDK
 
 NOTE - Due to the limitation of App Transport Security(ATS) on http in iOS9.0, we need to add exception for paydollar.com, pesopay.com, siampay.com, alipay.com, alipayobjects.com in info.list

```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSExceptionDomains</key>
<dict>
<key>paydollar.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
<key>xecure3d.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
<key>pesopay.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
<key>siampay.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
<key>alipay.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
<key>alipayobjects.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSTemporaryExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
<false/>
</dict>
</dict>
</dict>

```
Also Merchant can disable ATS by 

```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key><true/>
</dict>

```


### Add Security Key

Create the paysdk.plist file in the app with the following attributes      
    
RSA Public Key(SDK_RSA_Publickey) :- Here you need to specify the RSA Public Key without header and Merchant_ID(optional)
Doamin URL (Domain): Custom Domain name, The value of the key can be blank.
e.g


<img width="406" alt="Screenshot 2021-01-22 at 1 51 30 AM" src="https://user-images.githubusercontent.com/57219862/105408838-80ee2b80-5c55-11eb-8f5b-085ddbf88615.png">

### Initialize PaySdk

* Add implementation of PaySDK protocol –

class ViewController: UIViewController , PaySDKDelegate

* Instantiate PaySDK class with context.

 var paySDK = PaySDK.shared       (Swift Code)
 or 
 paySDK = [PaySDK shared];          (Objective C Code)

* Set paySDK delegate

paySDK.delegate = self


#### For UICustomization

* Swift Code
```
let customization = UiCustomization()

let submitButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
let resendButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
let cancelButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
let nextButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
let continueButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
let labelCustomization = LabelCustomization("Courier", "FF0000", 14, "FF0000", "Courier", 20)
let textboxCustomization = TextBoxCustomization("Courier", "#FF0000", 14, 5, "#d3d3d3", 4)
let toolBarCustomization = ToolbarCustomization("Courier", "#FFFFFF", 20, "#000000", "Header Text", "Close Button Text"))

try! customization.setButtonCustomization(submitButtonCustomization, .SUBMIT)
try! customization.setButtonCustomization(resendButtonCustomization, .RESEND)
try! customization.setButtonCustomization(cancelButtonCustomization, .CANCEL)
try! customization.setButtonCustomization(nextButtonCustomization, .NEXT)
try! customization.setButtonCustomization(continueButtonCustomization, .CONTINUE)
try! customization.setLabelCustomization(labelCustomization)
try! customization.setTextBoxCustomization(textboxCustomization)
try! customization.setToolbarCustomization(toolBarCustomization)

paySDK.uiCustomization = customization
```

* Objective C Code
```
UiCustomization *customization = [[UiCustomization alloc] init];

ButtonCustomization *submitButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
ButtonCustomization *resendButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
ButtonCustomization *cancelButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
ButtonCustomization *nextButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
ButtonCustomization *continueButtonCustomization = [[ButtonCustomization alloc] init:@"Courier" :@"#FF0000" :15 :@"#d3d3d3" :4];
LabelCustomization *labelCustomization = [[LabelCustomization alloc] init:@"Courier" :@"#FF0000" :14 :@"#FF0000":@"Courier" :20];
TextBoxCustomization *textBoxCustomization = [[TextBoxCustomization alloc] init:@"Courier" :@"FF0000" :14 :4 :@"FF0000" :4];
ToolbarCustomization *toolbarCustomization = [[ToolbarCustomization alloc] init:@"Courier" :@"#FFFFFF" :20 :@"#000000" :@"Payment Page", @"Close Button Text")];
 
NSError *err;

[customization setLabelCustomization:labelCustomization error:&err];
[customization setButtonCustomization:submitButtonCustomization : PaySDKButtonTypeSUBMIT error:&err];
[customization setButtonCustomization:resendButtonCustomization : PaySDKButtonTypeRESEND error:&err];
[customization setButtonCustomization:cancelButtonCustomization : PaySDKButtonTypeCANCEL error:&err];
[customization setButtonCustomization:nextButtonCustomization : PaySDKButtonTypeNEXT error:&err];
[customization setButtonCustomization:continueButtonCustomization : PaySDKButtonTypeCONTINUE error:&err];
[customization setTextBoxCustomization:textBoxCustomization error:&err];
[customization setToolbarCustomization:toolbarCustomization error:&err];

[paySDK setUiCustomization:customization];
```

### Initialize Payload

* Use following payment services.
 
Payment Services | Example
--- | --- 
Direct Payment | [Direct Payment](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/DirectPay/README.md)
Webview Payment | [Webview Payment](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/WebView/README.md)
3Ds 2.0 Extra Paramters | [3DS](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/3DS/README.md)
Alipay  | [Alipay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/AliPay/README.md)
WeChat Pay | [WeChat Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/WeChat/README.md)
Apple Pay | [Apple Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/ApplePay/README.md)
Octopus | [Octopus](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/Octopus%20Pay/README.md)
Member Pay | [Member Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/MemberPay/README.md)
Installment Pay | [Installmet Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/InstallmentPay/README.md)
Schedule Pay | [Schedule Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/SchedulePay/README.md)
Promo Pay | [Promo Pay](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/PromoPay/README.md)
EVoucher | [EVoucher](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/EVoucher)
PayMe |  [PayMe](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/PayMe/README.md)
Transaction Query | [Transaction Query](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/TRANSQUERY)
Payment Methods Query | [Payment Methods Query](https://github.com/asiapay-lib/paysdk-ios-demo/blob/master/PayMethod)


### Collect Payment Result

```
    func paymentResult(result: PayResult) {
     //process result here
     
    }
    
    //PaySDK will trigger payment result handle with failed status at WebView integration if the requested url scheme is failed to trigger.

    //Merchant can prompt the message for this case and ignore the result handle if they received the error message started with "No app installed to handle the request"


    func paymentResult(result: PayResult) {
            if (result.errMsg.starts(with: "No app installed to handle the request with scheme")) {
                    // ignore the result or prompt the app is not installed
            } else {
                    // process fail or success result here
            }
    }
    
```

# Set card networks and capabilities (ApplePay only)

Set available card scheme or capabilities for payment transaction on ApplePay as below

```
var supportedNetworksData :[PKPaymentNetwork] = [.visa, .masterCard, .discover, .amex, .JCB]

var merchantCapabilitiesData : PKMerchantCapability = [.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV]
```

# Whitelisting for boc pay app (BoCPay on WebView Call only)

Add whitelist url scheme of BoCPay app on LSApplicationQueriesSchemes property in info.plist.

# Related Sample
[DeepLink Demo](https://github.com/asiapay-lib/ios-deeplink-demo)


### Support
Asiapay is a tech company. All our engineers handle support too. You can write to us at it@pesopay.com ,it@paydollar.com , it@siampy.com and expect a response from the devs from the iOS SDK.

### License
MIT Licensed. LICENSE file added to repo.



