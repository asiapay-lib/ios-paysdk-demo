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


class ViewController: FormViewController {
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
    var payref: String = ""
    var resultPage: String = "F"
    
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
        //self.paySDK.setPublicKey(str: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArvxLT052VCC+QgQzh3SHuwMtD6qW4FG0pC8BLumsqZPZ6vV3cRx3np44sSbA5lllXtbIzodvc9T2sYdLQDpFG3I7IdhxE4XG05xSOQCeht7uz+s8DMlYJJjzJV2hBNEdNtjFkA2JYoxoBzsjIBTj4kTwFSZBVZCfq6HvuOGpKjzqsHkQXlXya5xzIBLjYduc5RBnuyHIeeQiSsuI2leg+RmQsUt84ykmrpTEpoPID0/vBwtHIilpUCGz88vwgN5SHTRTqG5naGjLR59pebYauKPuKRx7GYqGMbaXi8JYN7UdsipW9qCXY1b27Lq9ESVpbIgp85nLY66ISsKcmpheIwIDAQAB")
        self.currCode = CurrencyCode.HKD
        form1 =  form +++ Section("payment details")
            <<< SegmentedRow<String>() { row in
                row.options = ["PAYDOLLAR","PESOPAY","SIAMPAY"]
                row.value = "PAYDOLLAR"
            }
            <<< TextRow() { row in
                row.title = "merchant id"
                row.placeholder = "Enter text here"
                row.value = "88154745"
                    //"88618350"
                    //"88146271"
//                row.value = "88627221"
//                row.value =  "88155597"
                
            }
            //<<< PickerInputRow<String>("Picker Input Row") {
            //$0.title = "merchant id"
            //$0.options = ["88146271","88144151", "88145735"]
            //$0.value = $0.options.first
            //}.onChange({ (str) in
            //var str1 = ""
            //if str.value == "88144151" {
            //self.currCode = CurrencyCode.RMB
            //str1 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgBdpFphOiNncDYVeUU53xWuNA7wEVhNgPWlNf/pkA+t/Cu+0YigLA4q2+V5wkpSAAXM5pWnwL5L65vD/g/DfhsPLo6u3n9yXwvKhwPxgxtMnuoI1qNtZnCpg67gGueoIqSiSart1Uyd/OsAtK6ZeDKNWH9XS+pORphgARDkfA64JrzVI6iPpjQuOLIXlUr66wMj6zgjQYoiG4/2BvwI6/xG+PRUygaDKDtyzYOmV0YxF25PgHmWd/06dSvFx86wcVMIePvgwrS5DnE6rm4gaXqcuocazeMrG+RN/kz2XoRiiIWiXkH9/UjjenzVS8wKCruTRzeEEO+iReOYjmMOYBwIDAQAB"
            //}
            //if str.value == "88145735" {
            //self.bb1 = CurrencyCode.HKD
            //str1 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhRAtroMRBj/m4HAWhMiEjme4ISzjtGDNYNKJZFeFgBOXxWWPtqvtJpLPMgBVfP0wCmh4a0KMf/nwyShLSu1x/JEAxU7PhxmZtyrGgsKS0xL/qtQJZXqkKSBRdPXlU/ItkoAm2QdcKwA+6YFBqUB4nqDAzErjMP2SOMXOO67sgT8u39mPRgaveYIB2DN1n9FdiPywiGm9UQj+vFLYfOFLZWbO8R0mCfK9LouVNdZXi11aBhWVpP6frDjQOAQ15lbKQO60MPs6F61LZqmLTZc2oyhWqsfIoYsqRnQXg+w+HHL9WjVF0X2FaEveA279+EE42TzWK1v9tgleiwND3dJ8pQIDAQAB"
            //}
            //if str.value == "88146271" {
            //self.bb1 = CurrencyCode.HKD
            //str1 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArvxLT052VCC+QgQzh3SHuwMtD6qW4FG0pC8BLumsqZPZ6vV3cRx3np44sSbA5lllXtbIzodvc9T2sYdLQDpFG3I7IdhxE4XG05xSOQCeht7uz+s8DMlYJJjzJV2hBNEdNtjFkA2JYoxoBzsjIBTj4kTwFSZBVZCfq6HvuOGpKjzqsHkQXlXya5xzIBLjYduc5RBnuyHIeeQiSsuI2leg+RmQsUt84ykmrpTEpoPID0/vBwtHIilpUCGz88vwgN5SHTRTqG5naGjLR59pebYauKPuKRx7GYqGMbaXi8JYN7UdsipW9qCXY1b27Lq9ESVpbIgp85nLY66ISsKcmpheIwIDAQAB"
            //}
            //self.paySDK.setPublicKey(str: str1)
            //})
            <<< TextRow() { row in
                row.title = "orderRef"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow() {
                $0.title = "card number"
                $0.placeholder = "And numbers here"
                $0.value = "4012000000020084"
                $0.value = "4012000000020086"
            }
            <<< TextRow() { row in
                row.title = "card holder"
                row.placeholder = "Enter text here"
                row.value = "first last"
            }
            <<< PhoneRow() {
                $0.title = "exp month"
                $0.placeholder = "And numbers here"
                $0.value = "07"
            }
            <<< PhoneRow() {
                $0.title = "exp year"
                $0.placeholder = "And numbers here"
                $0.value = "2030"
            }
            <<< PhoneRow() {
                $0.title = "amount"
                $0.placeholder = "And numbers here"
                $0.value = "0.1"
            }
            <<< PasswordRow() {
                $0.title = "security code"
                $0.placeholder = "And numbers here"
                $0.value = "123"
            }
//            <<< PhoneRow() {
//                $0.title = "installment_period"
//                $0.placeholder = "And numbers here"
//            }
//            <<< TextRow() { row in
//                row.title = "memberPay_memberId"
//                //row.value = "member03"
//                row.placeholder = "Enter text here"
//            }
//            <<< TextRow() { row in
//                row.title = "promotionCode"
//                row.placeholder = "Enter text here"
//            }
//            <<< TextRow() { row in
//                row.title = "promotionRuleCode"
//                row.placeholder = "Enter text here"
//            }
//            <<< PhoneRow() {
//                $0.title = "promotionOriginalAmt"
//                $0.placeholder = "And numbers here"
//            }
//            <<< TextRow() { row in
//                row.title = "memberPayToken"
//                row.placeholder = "Enter text here"
//            }
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
                row.title = "Direct"
            }.onCellSelection({ (str, row) in
                self.processDirect(nil)
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "Webview"
            }.onCellSelection({ (str, row) in
                self.processHosted(nil)
            })
            /*<<< ButtonRow() { (row: ButtonRow) in
                row.title = "Installment Pay"
            }.onCellSelection({ (str, row) in
                    self.VASService = row.title!
                    let addVC = VASController()
                    addVC.VAS = self.VASService
                    addVC.viewController1 = self
                    self.navigationController?.pushViewController(addVC, animated: true)
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "Promo Pay"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.processHosted(nil)
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "Schedule Pay"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.processDirect(nil)
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "New Member Pay"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "Old Member Pay"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.v"iewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.processHosted(nil)
            })*/
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "WECHATAPP"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "WECHATAPP")
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "APPLEPAY"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "APPLEPAY")
            })
           <<< ButtonRow() { (row: ButtonRow) in
                row.title = "THREEDS2"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
//                self.threeDS()
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "ALIPAYHKAPP"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "ALIPAYHKAPP")
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "ALIPAYCNAPP"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "ALIPAYHKAPP")
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "ALIPAYAPP"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "ALIPAYAPP")
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "OCTOPUS"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "OCTOPUS")
            })
            /*<<< ButtonRow() { (row: ButtonRow) in
                row.title = "FPS"
            }.onCellSelection({ (str, row) in
                self.processWechat(sender: "FPS")
            })*/
           <<< ButtonRow() { (row: ButtonRow) in
                row.title = "EASYPAYMENTFORM"
            }.onCellSelection({ (str, row) in
                self.eASYPAYMENTFORM()
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "PAYME"
            }.onCellSelection({ (str, row) in
                self.payMe()
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "TRANS QUERY"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.transQuery()
            })
            /*<<< ButtonRow() { (row: ButtonRow) in
                row.title = "PAYMENT OPTIONS"
            }.onCellSelection({ (str, row) in
                self.paymentOptions()
            })
            <<< ButtonRow() { (row: ButtonRow) in
                row.title = "EVoucher"
            }.onCellSelection({ (str, row) in
                self.VASService = row.title!
                let addVC = VASController()
                addVC.VAS = self.VASService
                addVC.viewController1 = self
                self.navigationController?.pushViewController(addVC, animated: true)
                //self.transQuery()
            })*/
        serialGroup.notify(queue: DispatchQueue.main) {

           print("All Groups request completed.....")

        }
//        print("1: ",form1?.allSections[0][1].title as? String)
//        print("2: ",form1?.allSections[0][2].title as? String)
//        print("3: ",form1?.allSections[0][3].title as? String)
//        print("4: ",form1?.allSections[0][4].title as? String)
//        print("5: ",form1?.allSections[0][5].title as? String)
//        print("6: ",form1?.allSections[0][6].title as? String)
//        print("7: ",form1?.allSections[0][7].title as? String)
//        print("8: ",form1?.allSections[0][8].title as? String)
//        print("9: ",form1?.allSections[0][9].title as? String)
//        print("10: ",form1?.allSections[0][10].title as? String)
//        print("11: ",form1?.allSections[0][11].title as? String)
//        print("12: ",form1?.allSections[0][12].title as? String)
//        print("13: ",form1?.allSections[0][13].title as? String)
//        print("14: ",form1?.allSections[0][14].title as? String)
//        print("15: ",form1?.allSections[0][15].title as? String)
//        print("16: ",form1?.allSections[0][16].title as? String)
//        print("17: ",form1?.allSections[0][17].title as? String)
//        print("18: ",form1?.allSections[0][18].title as? String)
//        print("19: ",form1?.allSections[0][19].title as? String)
//        print("20: ",form1?.allSections[0][20].title as? String)
//        print("21: ",form1?.allSections[0][21].title as? String)
//        print("22: ",form1?.allSections[0][22].title as? String)
//        print("23: ",form1?.allSections[0][23].title as? String)
//        print("24: ",form1?.allSections[0][24].title as? String)
//        print("25: ",form1?.allSections[0][25].title as? String)
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
        if result.detail != nil {
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
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
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
                                        orderRef: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: true,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
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
    
    
    @IBAction func  processWechat(sender: String) {
        var extraData = getValues()
        var supportedNetworksData :[PKPaymentNetwork]!
        var merchantCapabilitiesData : PKMerchantCapability!
        if sender == "APPLEPAY" {
            extraData = ["apple_countryCode" : "HK",
                         "apple_currencyCode" : "HKD",
                         "apple_billingContactEmail" : "abc@gmail.com",
                         "apple_billingContactPhone" : "1234567890",
                         "apple_billingContactGivenName" : "ABC",
                         "apple_billingContactFamilyName" : "XYZ",
                         "apple_requiredBillingAddressFields" : "",
                         "apple_merchant_name" : "Demo",
                         "apple_merchantId" : "com.merchant.asiapay.applepay.demo"]
            supportedNetworksData = [.visa, .masterCard, .discover, .amex, .JCB]
            merchantCapabilitiesData = [.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV]
        } else if sender == "WECHATAPP" {
            extraData = [
                "wechatUniversalLink": "https://paydollarmobileapp/"
            ]
            supportedNetworksData = []
            merchantCapabilitiesData = []
        } else if sender == "OCTOPUS" {
            extraData = ["eVoucher": "T",
                         "eVClassCode": "0001"]
            supportedNetworksData = []
            merchantCapabilitiesData = []
        } else if sender == "FPS" {
             extraData = ["fpsQueryUrl" : "https://fps.paydollar.com/api/fpsQrUrl?encrypted="]
            supportedNetworksData = []
            merchantCapabilitiesData = []
        }
        else {
            extraData = ["apple_countryCode" : "HK",
                         "apple_currencyCode" : "HKD",
                         "apple_billingContactEmail" : "abc@gmail.com",
                         "apple_billingContactPhone" : "1234567890",
                         "apple_billingContactGivenName" : "ABC",
                         "apple_billingContactFamilyName" : "XYZ",
                         "apple_requiredBillingAddressFields" : "",
                         "apple_merchant_name" : "Demo",
                         "apple_merchantId" : "com.merchant.asiapay.applepay.demo"]
        }
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: EnvType.PRODUCTION,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: (form1?.allSections[0][2].baseValue as? String) ?? "",
                                        payMethod: sender,
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: "",
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "",
                                        extraData :  extraData,
                                        merchantCapabilitiesData: merchantCapabilitiesData,
                                        supportedNetworksData: supportedNetworksData)
        paySDK.process()
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
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
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
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
        
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
    
    
   func transQuery() {
        let extraData = getValues()

        paySDK.paymentDetails = PayData(channelType: PayChannel.NONE,
                                        envType: EnvType.PRODUCTION,
                                        amount : (form1?.allSections[0][7].baseValue as? String) ?? "",
                                        payGate: payGateForPG!,
                                        currCode: currCode!,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: "4D6CA9E47E0C9B419322716E53195127",
                                        payMethod: "ALL",
                                        lang: Language.ENGLISH,
                                        merchantId: (form1?.allSections[0][1].baseValue as? String) ?? "",
                                        remark: "",
                                        payRef: self.payref,
                                        resultpage: resultPage,
                                        showCloseButton: false,
                                        showToolbar: true,
                                        webViewClosePrompt: "Do you really wnt to close?",
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
    
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
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
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
                                        extraData :  extraData,
                                        merchantCapabilitiesData: [],
                                        supportedNetworksData: [])
        if form1?.allSections[0][3].baseValue != nil {
            paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: (form1?.allSections[0][4].baseValue as? String) ?? "",
                                                            cardNo: (form1?.allSections[0][3].baseValue as? String) ?? "",
                                                            expMonth: (form1?.allSections[0][5].baseValue as? String) ?? "",
                                                            expYear: (form1?.allSections[0][6].baseValue as? String) ?? "",
                                                            securityCode: (form1?.allSections[0][8].baseValue as? String) ?? "")
        }
//        let threeDSParams = ThreeDSParams()
//        threeDSParams.threeDSCustomerEmail = "example@example.com"
//        threeDSParams.threeDSDeliveryEmail = "example@example.com"
//        threeDSParams.threeDSMobilePhoneCountryCode = "852"
//        threeDSParams.threeDSMobilePhoneNumber = "9000000000"
//        threeDSParams.threeDSHomePhoneCountryCode = "852"
//        threeDSParams.threeDSHomePhoneNumber = "8000000000"
//        threeDSParams.threeDSWorkPhoneCountryCode = "852"
//        threeDSParams.threeDSWorkPhoneNumber = "7000000000"
//        threeDSParams.threeDSBillingCountryCode = "344"
//        threeDSParams.threeDSBillingState = ""
//        threeDSParams.threeDSBillingCity = "Hong Kong"
//        threeDSParams.threeDSBillingLine1 = "threeDSBillingLine1"
//        threeDSParams.threeDSBillingLine2 = "threeDSBillingLine2"
//        threeDSParams.threeDSBillingLine3 = "threeDSBillingLine3"
//        threeDSParams.threeDSBillingPostalCode = "121245"
//        threeDSParams.threeDSShippingDetails = "01"
//        threeDSParams.threeDSShippingCountryCode = "344"
//        threeDSParams.threeDSShippingState = ""
//        threeDSParams.threeDSShippingCity = "Hong Kong"
//        threeDSParams.threeDSShippingLine1 = "threeDSShippingLine1"
//        threeDSParams.threeDSShippingLine2 = "threeDSShippingLine2"
//        threeDSParams.threeDSShippingLine3 = "threeDSShippingLine3"
//        threeDSParams.threeDSAcctCreateDate = "20190401"
//        threeDSParams.threeDSAcctAgeInd = "01"
//        threeDSParams.threeDSAcctLastChangeDate = "20190401"
//        threeDSParams.threeDSAcctLastChangeInd = "01"
//        threeDSParams.threeDSAcctPwChangeDate = "20190401"
//        threeDSParams.threeDSAcctPwChangeInd = "01"
//        threeDSParams.threeDSAcctPurchaseCount = "10"
//        threeDSParams.threeDSAcctCardProvisionAttempt = "0"
//        threeDSParams.threeDSAcctNumTransDay = "0"
//        threeDSParams.threeDSAcctNumTransYear = "1"
//        threeDSParams.threeDSAcctPaymentAcctDate = "20190401"
//        threeDSParams.threeDSAcctPaymentAcctInd = "01"
//        threeDSParams.threeDSAcctShippingAddrLastChangeDate = "20190401"
//        threeDSParams.threeDSAcctShippingAddrLastChangeInd = "01"
//        threeDSParams.threeDSAcctIsShippingAcctNameSame = "T"
//        threeDSParams.threeDSAcctIsSuspiciousAcct = "F"
//        threeDSParams.threeDSAcctAuthMethod = "01"
//        threeDSParams.threeDSAcctAuthTimestamp = "20190401"
//        threeDSParams.threeDSDeliveryTime = "04"
//        threeDSParams.threeDSPreOrderReason = "01"
//        threeDSParams.threeDSPreOrderReadyDate = "20190401"
//        threeDSParams.threeDSGiftCardAmount = "5"
//        threeDSParams.threeDSGiftCardCurr = "344"
//        threeDSParams.threeDSGiftCardCount = "1"
//        threeDSParams.threeDSSdkMaxTimeout = "05"
//        threeDSParams.threeDSSdkInterface = "03"
//        paySDK.paymentDetails.threeDSParams = threeDSParams
        paySDK.process()
    }
    
    func VASValue(extraData: [String : Any] ) {
        VASData = extraData
        print("*********",extraData)
    }
    
    func setPayRef(ref: String) {
        self.payref = ref
    }
    
//    func setThreeDSParams(params: ThreeDSParams?){
////        threeDSParams = ThreeDSParams()
//        threeDSParams = params
//        print("####", threeDSParams)
//    }
    
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
}


extension ViewController : PaySDKDelegate {
    func transQueryResults(result: TransQueryResults) {
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


