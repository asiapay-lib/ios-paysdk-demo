//
//  ViewController.swift
//  ProSwift
//
//  Created by Asiapay on 11/12/19.
//  Copyright © 2019 Asiapay. All rights reserved.
//

import UIKit
import AP_PaySDK
import Eureka
import NVActivityIndicatorView
import PassKit
import CoreLocation
		
class ViewController: FormViewController, PKPaymentAuthorizationControllerDelegate,PKPaymentAuthorizationViewControllerDelegate {
    
    
   
    var paySDK = PaySDK.shared
    var form1 : Form?
    var memberPayToken = ""
    var payGateForPG : PayGate?
    var currCode : CurrencyCode?
    var isUIRamdom : Bool =     false
    var isLoaderRamdom : Bool = false
    var VASService : String = ""
    let loadview = LoadingView()
    var VASData : [String : Any]?
//    var threeDSParams : ThreeDSParams?
    var payref: String = "1693993799956"//"11793068"
    var resultPage: String = "F"
    var b64TokenStr: String?
    var locationManager: CLLocationManager?
    var authorizationStatus: Bool = true
    var extraData: [String: Any]?
    var status: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SDK Version: \(paySDK.getSDKVersion())")
        let customization = UiCustomization()
        
        let submitButtonCustomization = ButtonCustomization("Courier", "#FFFFFF", 15, "#000000", 4)
        let resendButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
        let cancelButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
        let nextButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
        let continueButtonCustomization = ButtonCustomization("Courier", "#FF0000", 15, "#d3d3d3", 4)
        let labelCustomization = LabelCustomization("Courier", "FF0000", 14, "FF0000", "Courier", 20)
        let textboxCustomization = TextBoxCustomization("Courier", "#FF0000", 14, 5, "#d3d3d3", 4)
        let toolBarCustomization = ToolbarCustomization("Courier", "#FFFFFF", 20, "#000000", "Payment Page", "")
        
        try! customization.setButtonCustomization(submitButtonCustomization, .SUBMIT)
        try! customization.setButtonCustomization(resendButtonCustomization, .RESEND)
        try! customization.setButtonCustomization(cancelButtonCustomization, .CANCEL)
        try! customization.setButtonCustomization(nextButtonCustomization, .NEXT)
        try! customization.setButtonCustomization(continueButtonCustomization, .CONTINUE)
        try! customization.setLabelCustomization(labelCustomization)
        try! customization.setTextBoxCustomization(textboxCustomization)
        try! customization.setToolbarCustomization(toolBarCustomization)
        paySDK.uiCustomization = customization
        paySDK.delegate = self
        paySDK.isBioMetricRequired = false
        paySDK.useSDKProgressScreen = true
        let serialGroup = DispatchGroup()
        
        locationManager = CLLocationManager()
        //Make sure to set the delegate, to get the call back when the user taps Allow option
        locationManager?.delegate = self
       
        self.currCode = CurrencyCode.HKD
        form1 =  form +++ Section("payment details")
            <<< SegmentedRow<String>() { row in
                row.options = ["PAYDOLLAR","PESOPAY","SIAMPAY"]
                row.value = "PAYDOLLAR"
            }
            <<< TextRow() { row in
                row.title = "merchant id"
                row.placeholder = "Enter text here"
                row.value = "88145735" //"88154745"
                    //"88618350"
                    //"88146271"
//                row.value = "88627221"
//                row.value =  "88155597"
                
            }
            
            <<< TextRow() { row in
                row.title = "orderRef"
                row.placeholder = "Enter text here"
                row.value = "123456"
            }
            <<< PhoneRow() {
                $0.title = "card number"
                $0.placeholder = "And numbers here"
                // $0.value = "4012000000020084"
//                  $0.value = "4012000000020086"
            }
            <<< TextRow() { row in
                row.title = "card holder"
                row.placeholder = "Enter text here"
//                row.value = "first last"
            }
            <<< PhoneRow() {
                $0.title = "exp month"
                $0.placeholder = "And numbers here"
//                $0.value = "07"
            }
            <<< PhoneRow() {
                $0.title = "exp year"
                $0.placeholder = "And numbers here"
//                $0.value = "2030"
            }
            <<< PhoneRow() {
                $0.title = "amount"
                $0.placeholder = "And numbers here"
                $0.value = "100"
            }
            <<< PasswordRow() {
                $0.title = "security code"
                $0.placeholder = "And numbers here"
//                $0.value = "123"
            }
         
            <<< PickerInputRow<String>("Picker Input Row1") {
                $0.title = "Currency"
                $0.options = ["HKD","RMB","USD","SGD","CNY","YEN","JPY","TWD","AUD","EUR","GBP","CAD","MOP","PHP","THB","IDR","BND","MYR","BRL","INR","TRY","ZAR","VND","LKR","KWD","NZD"]
                $0.value = $0.options.first
                
            }.onChange({ (str) in
                switch str.value {
                case "HKD" :   self.currCode = CurrencyCode.HKD
                case "USD" :   self.currCode = CurrencyCode.USD
                case "SGD" :   self.currCode = CurrencyCode.SGD
                case "RMB" , "CNY" :   self.currCode = CurrencyCode.RMB
                case "YEN" , "JPY" :   self.currCode = CurrencyCode.JPY
                case "TWD" :   self.currCode = CurrencyCode.TWD
                case "AUD" :   self.currCode = CurrencyCode.AUD
                case "EUR" :   self.currCode = CurrencyCode.EUR
                case "GBP" :   self.currCode = CurrencyCode.GBP
                case "CAD" :   self.currCode = CurrencyCode.CAD
                case "MOP" :   self.currCode = CurrencyCode.MOP
                case "PHP" :   self.currCode = CurrencyCode.PHP
                case "THB" :   self.currCode = CurrencyCode.THB
                case "IDR" :   self.currCode = CurrencyCode.IDR
                case "BND" :   self.currCode = CurrencyCode.BND
                case "MYR" :   self.currCode = CurrencyCode.MYR
                case "BRL" :   self.currCode = CurrencyCode.BRL
                case "INR" :   self.currCode = CurrencyCode.INR
                case "TRY" :   self.currCode = CurrencyCode.TRY
                case "ZAR" :   self.currCode = CurrencyCode.ZAR
                case "VND" :   self.currCode = CurrencyCode.VND
                case "LKR" :   self.currCode = CurrencyCode.LKR
                case "KWD" :   self.currCode = CurrencyCode.KWD
                case "NZD" :   self.currCode = CurrencyCode.NZD
                case .none:    self.currCode = CurrencyCode.HKD
                    
                case .some(_): break
                    
                }
            })
            <<< SegmentedRow<String>() { row in
                row.options = ["BioMetric","Non-BioMetric"]
                row.value = "Non-BioMetric"
            }
            <<< TextAreaRow() { row in
                row.value = ""
                row.disabled = true
            }
            
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "Merchant APPLEPAY"
            }.onCellSelection({ (str, row) in
                self.generateApplePayRequest()
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "TRANS QUERY"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.payRef = self.payref
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.transQuery()
            })
           
        serialGroup.notify(queue: DispatchQueue.main) {

           print("All Groups request completed.....")

        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager?.delegate = self
    }
    
    func toJson(result: PayResult) -> String {
        let dic = [
            "amount":result.amount,
            "successCode":result.successCode,
            "maskedCardNo":result.maskedCardNo,
            "authId":result.authId,
            "cardHolder":result.cardHolder,
            "currencyCode":result.currencyCode,
            "errMsg":result.errMsg,
            "ord":result.ord,
            "payRef":result.payRef,
            "prc":result.prc,
            "ref":result.ref,
            "src":result.src,
            "transactionTime":result.transactionTime,
            "descriptionStr":result.descriptionStr
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
        return jsonStr
    }
    
    func toQueryJson(result: TransQueryResults) -> String {
        if result.detail != nil && result.detail!.count > 0 {
        let dic = [
            "amount":result.detail?[0].amt,
            "successCode":result.detail?[0].successcode,
            "ipCountry":result.detail![0].ipCountry,
            "authId":result.detail![0].authId,
            "cardIssuingCountry":result.detail![0].cardIssuingCountry,
            "currencyCode":result.detail![0].cur,
            "errMsg":result.detail![0].errMsg,
            "ord":result.detail![0].ord,
            "payRef":result.detail![0].payRef,
            "prc":result.detail![0].prc,
            "ref":result.detail![0].ref,
            "src":result.detail![0].src,
            "transactionTime":result.detail![0].txTime,
            "descriptionStr":result.detail![0].description
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonStr
        }
        return ""
    }
    
    func toPayMethodJson(result: PaymentOptionsDetail) -> String {
        let dic = [
            "card":result.methods.card[0],
            "netbanking":result.methods.netbanking[0],
            "other": result.methods.other[0]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
        return jsonStr
    }
    
    @IBAction func processDirect(_ sender: Any?) {
        let extraData = getValues()
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "VISA",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really want to close?",
                                        extraData :  extraData)
        if form1?.allSections[0][3].baseValue != nil {
            paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: (form1?.allSections[0][4].baseValue as? String) ?? "",
                                                            cardNo: (form1?.allSections[0][3].baseValue as? String) ?? "",
                                                            expMonth: (form1?.allSections[0][5].baseValue as? String) ?? "",
                                                            expYear: (form1?.allSections[0][6].baseValue as? String) ?? "",
                                                            securityCode: (form1?.allSections[0][8].baseValue as? String) ?? "")
        }
        paySDK.process()
    }
    
    @IBAction func applyCustom(_ sender: UIBarButtonItem) {
        isUIRamdom = !isUIRamdom
        if isUIRamdom == false {
            sender.title = "Random UI : OFF"
        } else {
            sender.title = "Random UI : ON"
        }
    }
    
    @IBAction func processHosted(_ sender: Any?) {
        let extraData = getValues()
        paySDK.paymentDetails = PayData(channelType: PayChannel.WEBVIEW,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: true,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData)
//        paySDK.paymentDetails = PayData(channelType: PayChannel.WEBVIEW,
//                                            envType: EnvType.SANDBOX,
//                                            amount :"100",
//                                            payGate: PayGate.PAYDOLLAR,
//                                            currCode: .HKD,
//                                            payType: payType.NORMAL_PAYMENT,
//                                            orderRef: "2018102409220001",
//                                            payMethod: "VISA",
//                                            lang: Language.ENGLISH,
//                                            merchantId: "88155155",  ///88593126. ///88620594 ///UAT MID 88593126
//                                            remark: "",
//                                            payRef: "",
//                                            resultpage: "F",
//                                            extraData :[:])
        paySDK.process()
    }
    
        func generateApplePayRequest() {
            var shopArr = [PKPaymentSummaryItem(label: "asiapay" , amount: NSDecimalNumber(string: "1"))]
            if PKPaymentAuthorizationViewController.canMakePayments() {
                let paymentReq = PKPaymentRequest()
                let shipContact = PKContact()
                let billContact = PKContact()
                //shipContact.emailAddress = payDetails.extraData["apple_shippingContactEmail"] as? String
                //shipContact.phoneNumber = CNPhoneNumber(stringValue: payDetails.extraData["apple_shippingContactPhone"] as! String)
                let address =  CNPostalAddress()
                shipContact.postalAddress = address
                let SCName = PersonNameComponents()
                //SCName.givenName = payDetails.extraData["apple_shippingContactGivenName"] as? String
                //SCName.familyName = payDetails.extraData["apple_shippingContactFamilyName"] as? String
                shipContact.name = SCName
                var BCName = PersonNameComponents()
                BCName.givenName = "ABC"
                BCName.familyName = "XYZ"
                billContact.name = BCName
                billContact.emailAddress = "abc@mail.com"
                billContact.phoneNumber = CNPhoneNumber(stringValue: "9876543210")
                //if #available(iOS 10.3, *) {
                paymentReq.supportedNetworks = [.amex, .chinaUnionPay, .visa, .masterCard, .discover, .idCredit, .privateLabel, .suica, .quicPay]
                //} else {
                //paymentReq.supportedNetworks = [.amex, .chinaUnionPay, .visa, .masterCard]
                //}
                paymentReq.countryCode = "HK"
                paymentReq.currencyCode = "HKD"
                paymentReq.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV]
                paymentReq.merchantIdentifier = "merchant.com.asiapay.applepay.test"
                //"merchant.com.asiapay.merchantforCN"//"merchant.com.asiapay.ApplePayDemoStripe" //"merchant.com.asiapay.applePayPD"
                //paymentReq.requiredBillingAddressFields = .all
                //paymentReq.requiredShippingAddressFields = .all
                //paymentReq.shippingType = .shipping
                //paymentReq.shippingContact = shipContact
                //paymentReq.billingContact = billContact
                //shopArr = [PKPaymentSummaryItem(label: "amount", amount: NSDecimalNumber(string: "11.00")),PKPaymentSummaryItem(label: "total", amount: NSDecimalNumber(string: "11.00")),PKPaymentSummaryItem(label: "total1", amount: NSDecimalNumber(string: "11.00")),PKPaymentSummaryItem(label: "total2", amount: NSDecimalNumber(string: "11.00"))]
                //let shopArr1 = [PKPaymentSummaryItem(label: "total", amount: NSDecimalNumber(string: "12.00"))]
                paymentReq.paymentSummaryItems = shopArr
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentReq.supportedNetworks, capabilities: paymentReq.merchantCapabilities) {
                    //print("supported")
                }
                guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentReq) else {
                   print("Can not start Apple Pay")
                    return
                }
                paymentVC.delegate = self
                UIApplication.shared.keyWindow?.rootViewController?.present(paymentVC, animated: true, completion: nil)
            }
        }
//        extraData = getValues()
//        print("Token \(String(describing: b64TokenStr))")
//        extraData = ["eWalletPaymentData" : b64TokenStr as Any,
//                    "eWalletService": "T",
//                    "eWalletBrand": "APPLEPAY"]
        
        
    
    
    @IBAction func  processVAS(sender: String) {
        extraData = getValues()
        if sender == "APPLEPAY" {
            extraData = ["apple_countryCode" : "HK",
                         "apple_currencyCode" : "HKD",
                         "apple_billingContactEmail" : "abc@gmail.com",
                         "apple_billingContactPhone" : "1234567890",
                         "apple_billingContactGivenName" : "ABC",
                         "apple_billingContactFamilyName" : "XYZ",
                         "apple_requiredBillingAddressFields" : "",
                         "apple_merchant_name" : "Demo",
                         "apple_merchantId" : "merchant.com.asiapay.applepay.test"]
        } else if sender == "WECHATAPP" {
            extraData = [
                "wechatUniversalLink": "https://paydollarmobileapp/"
            ]
        } else if sender == "OCTOPUS" {
            extraData = ["eVoucher": "T",
                         "eVClassCode": "0001"]
        } else if sender == "FPS" {
             extraData = ["fpsQueryUrl" : "https://fps.paydollar.com/api/fpsQrUrl?encrypted="]
        }
        else {
           
        }
        self.paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "APPLEPAY",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "",
                                        extraData :  extraData)
    
       self.paySDK.process()
       
    }
    
    
    func eASYPAYMENTFORM() {
        let extraData = getValues()
        paySDK.paymentDetails = PayData(channelType: PayChannel.EASYPAYMENTFORM,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "",
                                        extraData :  extraData)
        paySDK.process()
    }
    
    
    func payMe() {
        let extraData = ["":""]
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: .SANDBOX, //.SANDBOX,
                                        amount: (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: PayGate.PAYDOLLAR,//PayGate.PAYDOLLAR,
                                        currCode: currCode!,//CurrencyCode.MYR,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "PayMe",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "123",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really want to close?",
                                        extraData: extraData)
        
        paySDK.paymentDetails.callBackParam = CallBackParam(successUrl : "DemoApp://success",
                                                            cancelUrl : "DemoApp://cancel",
                                                            errorUrl: "DemoApp://error",
                                                            failUrl : "DemoApp://fail")
        
//        paysdk.paymentDetails.cardDetails = CardDetails(cardHolderName: "First Last",
//                                                        cardNo: "4444333322221111",
//                                                        expMonth: "12",
//                                                        expYear: "2022",
//                                                        securityCode: "124")
        
        paySDK.process()
    }
    func bocPay() {
        let extraData = ["deeplink":"3","deeplinkUrl":"ewabocpay://bocpay.app/openwith"]
        //"ewabocpay://bocpay.app/openwith"
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: .SANDBOX, //.SANDBOX,
                                        amount: (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: PayGate.PAYDOLLAR,//PayGate.PAYDOLLAR,
                                        currCode: currCode!,//CurrencyCode.MYR,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "BoCPayAPP",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "123",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really want to close?",
                                        extraData: extraData)
        
        paySDK.paymentDetails.callBackParam = CallBackParam(successUrl : "https://ewa.bochk.com/bocpay",
                                                            cancelUrl : "mcd://www.apin.com/cancel",
                                                            errorUrl: "mcd://www.apin.com/error",
                                                            failUrl : "mcd://www.apin.com/fail")
        
//        paysdk.paymentDetails.cardDetails = CardDetails(cardHolderName: "First Last",
//                                                        cardNo: "4444333322221111",
//                                                        expMonth: "12",
//                                                        expYear: "2022",
//                                                        securityCode: "124")
        
        paySDK.process()
    }
    
   func transQuery() {
        let extraData = getValues()

        paySDK.paymentDetails = PayData(channelType: PayChannel.NONE,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: "1693902263352",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: self.payref,
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really want to close?",
                                        extraData :  extraData)
    
        paySDK.query(action: Action.TX_QUERY.rawValue) //"TX_QUERY")
    }
    
    
    func  paymentOptions() {
        let extraData = getValues()
        paySDK.paymentDetails = PayData(channelType: PayChannel.EASYPAYMENTFORM,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData)
    paySDK.query(action: "PAYMENT_METHOD")
    }
    
    
    func threeDS() {
        let extraData = getValues()
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.SANDBOX,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: "THREEDS2",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData)
        if form1?.allSections[0][3].baseValue != nil {
            paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: (form1?.allSections[0][4].baseValue as? String) ?? "",
                                                            cardNo: (form1?.allSections[0][3].baseValue as? String) ?? "",
                                                            expMonth: (form1?.allSections[0][5].baseValue as? String) ?? "",
                                                            expYear: (form1?.allSections[0][6].baseValue as? String) ?? "",
                                                            securityCode: (form1?.allSections[0][8].baseValue as? String) ?? "")
        }

        paySDK.process()
    }
    
    func VASValue(extraData: [String : Any] ) {
        VASData = extraData
        print("*********",extraData)
    }
    
    func setPayRef(ref: String) {
        self.payref = ref
    }
    

    func getValues() -> [String: Any] {
        if isUIRamdom == true {
            let customization = UiCustomization()
            let family = UIFont.familyNames.randomElement()
            let fontName = UIFont.fontNames(forFamilyName: family!).randomElement()
            let colorArr = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
            let color1 = "#" + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()!
            let color2 = "#" + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()! + colorArr.randomElement()!
            let intNum1 = Int.random(in: 8 ..< 17)
            let intNum2 = Int.random(in: 3 ..< 8)
            let intNum3 = Int.random(in: 17 ..< 25)
            
            do {
                let submitButtonCustomization =     ButtonCustomization(fontName!, color1, intNum1, color2, intNum2)
                let resendButtonCustomization =     ButtonCustomization(fontName!, color1, intNum1, color2, intNum2)
                let cancelButtonCustomization =     ButtonCustomization(fontName!, color1, intNum1, color2, intNum2)
                let nextButtonCustomization =       ButtonCustomization(fontName!, color1, intNum1, color2, intNum2)
                let continueButtonCustomization =   ButtonCustomization(fontName!, color1, intNum1, color2, intNum2)
                let labelCustomization =            LabelCustomization.init(fontName!, color1, intNum1, color2, fontName!, intNum3)
                let textboxCustomization =          TextBoxCustomization(fontName!, color1, intNum1, intNum2, color2, intNum2)
                let toolBarCustomization =          ToolbarCustomization(fontName!, color1, intNum3, color2, "Secure Checkout", "")
                
                try customization.setButtonCustomization(submitButtonCustomization, .SUBMIT)
                try customization.setButtonCustomization(resendButtonCustomization, .RESEND)
                try customization.setButtonCustomization(cancelButtonCustomization, .CANCEL)
                try customization.setButtonCustomization(nextButtonCustomization, .NEXT)
                try customization.setButtonCustomization(continueButtonCustomization, .CONTINUE)
                try customization.setLabelCustomization(labelCustomization)
                try customization.setTextBoxCustomization(textboxCustomization)
                try customization.setToolbarCustomization(toolBarCustomization)
            } catch _ {
                
            }
            paySDK.uiCustomization = customization
        }
        
        let aa = form1?.allSections[0][11] as! TextAreaRow
        aa.value = ""
        aa.reload()
        let aa1 = form1?.allSections[0][2] as! TextRow
        aa1.value = String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000)
        aa1.reload()
        var extraData = [String: Any]()
        if self.VASService == "Installment Pay" || self.VASService == "Schedule Pay" || self.VASService == "Promo Pay" || self.VASService == "New Member Pay" || self.VASService == "Old Member Pay" {
            extraData = VASData!
        } else if self.VASService == "EVoucher" {
            extraData = VASData!
        }
        else if  self.VASService == "TRANS QUERY" {
            extraData = VASData!
        }
//            extraData["installment_service"] = "T"
//            extraData["installment_period"] = (form1?.allSections[0][1].baseValue as? String) ?? ""
//            extraData["installOnly"] = (form1?.allSections[0][2].baseValue as? String) ?? ""
        //}
//        if form1?.allSections[0][9].baseValue != nil {
//            extraData["installment_service"] = "T"
//            extraData["installment_period"] = (form1?.allSections[0][9].baseValue as? String) ?? ""
//            extraData["installOnly"] = "T"
//        }
//        if form1?.allSections[0][10].baseValue != nil {
//            extraData["memberPay_memberId"] = form1?.allSections[0][10].baseValue
//            extraData["memberPay_service"] = "T"
//            if form1?.allSections[0][14].baseValue != nil {
//                extraData["memberPay_token"] = form1?.allSections[0][14].baseValue
//                extraData["addNewMember"] = false
//            } else {
//                extraData["addNewMember"] = true
//            }
//        }
//        if form1?.allSections[0][11].baseValue != nil {
//            extraData["promotion"] = "T"
//            extraData["promotionCode"] = form1?.allSections[0][11].baseValue
//            extraData["promotionRuleCode"] = form1?.allSections[0][12].baseValue
//            extraData["promotionOriginalAmt"] = form1?.allSections[0][13].baseValue
//
//        }
        
        switch (form1?.allSections[0][0].baseValue as? String) ?? "" {
        case "PAYDOLLAR": payGateForPG = PayGate.PAYDOLLAR
            break
        case "PESOPAY": payGateForPG = PayGate.PESOPAY
            break
        case "SIAMPAY": payGateForPG = PayGate.SIAMPAY
            break
        default: payGateForPG = PayGate.PAYDOLLAR
            break
        }
        switch (form1?.allSections[0][10].baseValue as? String) ?? "" {
        //"BioMetric","Non-BioMetric"
        case "BioMetric": paySDK.isBioMetricRequired = true
        //bb = PayGate.PAYDOLLAR
            break
        case "Non-BioMetric": paySDK.isBioMetricRequired = false
        //bb = PayGate.PESOPAY
            break
        default: paySDK.isBioMetricRequired = false
        //bb = PayGate.PAYDOLLAR
            break
        }
        return extraData
    }
    
    @IBAction func merchantLoaderUsage(_ sender: UIBarButtonItem) {
        isLoaderRamdom = !isLoaderRamdom
        if isLoaderRamdom == false {
            sender.title = "Merchant Loader : OFF"
            paySDK.useSDKProgressScreen = true
        } else {
            sender.title = "Merchant Loader : ON"
            paySDK.useSDKProgressScreen = false
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
            controller.dismiss()
        }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
        
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void)
        {
    //        var dicStr = ""
    //        var parameterDict = [String: Any]()
            
            do {
                let paymentDataDic = try JSONSerialization.jsonObject(with: payment.token.paymentData, options:[]) as! [String : Any]
                let paymentDataJson = ["token": ["paymentData":paymentDataDic,
                                                 "transactionIdentifier":payment.token.transactionIdentifier,
                                                 "paymentMethod" : [
                                                    "displayName":payment.token.paymentMethod.displayName,
                                                    "network":payment.token.paymentMethod.network?.rawValue,
                                                    "type":"\(payment.token.paymentMethod.type.rawValue)"]]] as [String : Any]
                
                b64TokenStr = try! JSONSerialization.data(withJSONObject: paymentDataJson, options: []).base64URLEncodedString()
                
                print("Token \(String(describing: b64TokenStr))")
                
                paySDK.paymentDetails = PayData(channelType: .DIRECT,
                                                envType: .SANDBOX,
                                                amount: (form1?.allSections[0][7].baseValue as? String) ?? "",
                                                payGate: PayGate.PAYDOLLAR,
                                                currCode: CurrencyCode.HKD,
                                                payType: payType.NORMAL_PAYMENT,
                                                orderRef: String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000),
                                                payMethod: "",
                                                lang: Language.ENGLISH,
                                                merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                                remark: "123",
                                                payRef: "",
                                                resultpage: resultPage,
                                                showCloseButton: false,
                                                showToolbar: false,
                                                webViewClosePrompt: "Do you want to Close?",
                                                extraData: ["eWalletPaymentData" : b64TokenStr!,
                                                            "eWalletService": "T",
                                                            "eWalletBrand": "APPLEPAY"], merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
                paySDK.delegate = self
                paySDK.process()
               // completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            } catch let err {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(30)) {
                if self.status == "0" {
                    // Success Status
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                } else if self.status == "1" {
                    // Failure Status
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                } else if self.status == "2" {
                    // Pending Status, do nothing
                } else if self.status.isEmpty {
                    //Waiting for timeout
                } else{
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                }
            }
           // completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }
        
}


extension ViewController : PaySDKDelegate {
    func transQueryResults(result: TransQueryResults) {
        print("Query Result: ")
        print(self.toQueryJson(result: result))
        let aa = form1?.allSections[0][11] as! TextAreaRow
        aa.value = self.toQueryJson(result: result)
        aa.reload()
    }
    
    func payMethodOptions(method: PaymentOptionsDetail) {
        print(self.toPayMethodJson(result: method))
        let aa = form1?.allSections[0][11] as! TextAreaRow
        aa.value = self.toPayMethodJson(result: method)
        aa.reload()
    }
    
    
    func paymentResult(result: PayResult) {
        print(self.toJson(result: result))
        let aa = form1?.allSections[0][11] as! TextAreaRow
        aa.value = self.toJson(result: result)
        aa.reload()
        
        self.status = result.successCode
        
        self.payref = result.payRef ?? "289473573"
        print("Ref: \(String(describing: result.payRef))")
        //aa.header?.title =
        //aa.reload()
    }
    
    func showProgress() {
        loadview.startLoad()
    }
    
    
    func hideProgress() {
        loadview.stopLoad()
    }
    
    
    
    func setMerchantInfoImg() -> UIImage? {
        return #imageLiteral(resourceName: "img.png")
    }
    
    func setMerchantInfoScreen() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: classForCoder))
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        return viewController
    }
    
    func setMerchantInfo() -> String? {
        return "https://m.alibaba.com"
    }
}


class LoadingView: UIViewController ,NVActivityIndicatorViewable {
    
    func startLoad() {
        let size = CGSize(width: self.view.frame.width/5, height: self.view.frame.width/5)
        let arr = [NVActivityIndicatorType.ballPulse, NVActivityIndicatorType.ballGridPulse, NVActivityIndicatorType.ballClipRotate, NVActivityIndicatorType.squareSpin, NVActivityIndicatorType.ballClipRotatePulse, NVActivityIndicatorType.ballClipRotateMultiple, NVActivityIndicatorType.ballPulseRise, NVActivityIndicatorType.ballRotate, NVActivityIndicatorType.cubeTransition, NVActivityIndicatorType.ballZigZag, NVActivityIndicatorType.ballZigZagDeflect, NVActivityIndicatorType.ballTrianglePath, NVActivityIndicatorType.ballScale, NVActivityIndicatorType.lineScale, NVActivityIndicatorType.lineScaleParty, NVActivityIndicatorType.ballScaleMultiple, NVActivityIndicatorType.ballPulseSync, NVActivityIndicatorType.ballBeat, NVActivityIndicatorType.ballDoubleBounce, NVActivityIndicatorType.lineScalePulseOut, NVActivityIndicatorType.lineScalePulseOutRapid, NVActivityIndicatorType.ballScaleRipple, NVActivityIndicatorType.ballScaleRippleMultiple, NVActivityIndicatorType.ballSpinFadeLoader, NVActivityIndicatorType.lineSpinFadeLoader, NVActivityIndicatorType.triangleSkewSpin, NVActivityIndicatorType.pacman, NVActivityIndicatorType.semiCircleSpin, NVActivityIndicatorType.ballRotateChase, NVActivityIndicatorType.orbit, NVActivityIndicatorType.audioEqualizer, NVActivityIndicatorType.circleStrokeSpin]
        startAnimating(size, message: "",messageFont: nil,type: arr.randomElement())
    }
    
    
    func stopLoad() {
        stopAnimating()
    }
}


class ViewController2: UIViewController {
    override func viewDidLoad() {
        
    }
}



extension Data {
    func base64URLEncodedString() -> String {
        let s = self.base64EncodedString()
        return s
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            authorizationStatus = false
            print("not determined - hence ask for Permission")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            authorizationStatus = false
            print("permission denied")
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationStatus = true
            print("Apple delegate gives the call back here once user taps Allow option, Make sure delegate is set to self")
        }
    }
}
