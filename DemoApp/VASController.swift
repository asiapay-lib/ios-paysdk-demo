//
//  VASController.swift
//  ProSwift
//
//  Created by Priyanka Gore on 22/04/20.
//  Copyright © 2020 Asiapay. All rights reserved.
//

import UIKit
import Eureka
import NVActivityIndicatorView
import AP_PaySDK

class VASController: FormViewController {
    //    var paySDK = PaySDK.shared
    var form1 : Form?
    var memberPayToken = ""
    // var payGateForPG : PayGate?
    var currCode : CurrencyCode?
    var schType : String?
    var schStatus : String?
    var isInstallOnly : String?
    var isUIRamdom : Bool = false
    var isLoaderRamdom : Bool = false
    let loadview = LoadingView()
    var VAS : String = ""
    var viewController1 : ViewController?
    var isAcNameSameAsShip: String?
    var isAccountSuspisious: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment Options"
        // self.navigationController?.navigationItem.titleLabel.text = "Payment options"
        if(VAS == "Installment Pay") {
            form1 =  form +++ Section("VAS details")
                <<< PhoneRow() {
                    $0.title = "installment_period"
                    $0.placeholder = "Any numbers here"
                    $0.add(rule: RuleRequired())
                    //                    $0.validationOptions = .validatesOnChangeAfterBlurred
                    $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                        //ValidationError(msg: "Field required!")
                    }
                }
                <<< PickerInputRow<String>("Picker Input Row1") {
                    $0.title = "Only_install"
                    $0.options = ["T","F"]
                    $0.value = $0.options.first
                }.onChange({ (str) in
                    switch str.value {
                    case "T" :   self.isInstallOnly = "T"
                    case "F" :   self.isInstallOnly = "F"
                    case .none: self.isInstallOnly = "T"
                    case .some(_): break
                    }
                })
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS//"Installment Pay"
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        var extraData = [String: Any]()
                        extraData["installment_service"] = "T"
                        extraData["installment_period"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        extraData["installOnly"] = (self.form1?.allSections[0][1].baseValue as? String) ?? ""
                        
                        //                    self.viewController1?.VASData = extraData
                        self.viewController1?.VASValue(extraData: extraData)
                        self.navigationController?.popViewController(animated: true)
                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
                            self.viewController1?.processDirect(nil)
                        } else {
                            self.viewController1?.processHosted(nil)
                        }
                    } else {
                        self.onValidate()
                    }
                })
            //self.processDirect(nil)
        } else if(VAS == "Promo Pay") {
            form1 =  form +++ Section("VAS details")
                <<< TextRow() { row in
                    row.title = "promotionCode"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< TextRow() { row in
                    row.title = "promotionRuleCode"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "promotionOriginalAmt"
                    $0.placeholder = "And numbers here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS //"Promo Pay"
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        var extraData = [String: Any]()
                        extraData["promotion"] = "T"
                        extraData["promotionCode"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        extraData["promotionRuleCode"] = (self.form1?.allSections[0][1].baseValue as? String) ?? ""
                        extraData["promotionOriginalAmt"] = (self.form1?.allSections[0][2].baseValue as? String) ?? ""
                        self.viewController1?.VASValue(extraData: extraData)
                        self.navigationController?.popViewController(animated: true)
                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
                            self.viewController1?.processDirect(nil)
                        } else {
                            self.viewController1?.processHosted(nil)
                        }
                    } else {
                        self.onValidate()
                    }
                })
        } else if(VAS == "Schedule Pay") {
            form1 =  form +++ Section("VAS details")
                <<< PickerInputRow<String>("Picker Input Row1") {
                    $0.title = "Schedule Type"
                    $0.options = ["Day","Month","Year"]
                    $0.value = $0.options.first
                    
                }.onChange({ (str) in
                    switch str.value {
                    case "Day" :   self.schType = "Day"
                    case "Month" :   self.schType = "Month"
                    case "Year" :   self.schType = "Year"
                    case .none: self.schType = "Day"
                    case .some(_): break
                    }
                })
                <<< PickerInputRow<String>("Picker Input Row2") {
                    $0.title = "Schedule Status"
                    $0.options = ["Active","Suspended"]
                    $0.value = $0.options.first
                    
                }.onChange({ (str) in
                    switch str.value {
                    case "Active" :   self.schStatus = "Active"
                    case "Suspended" :   self.schStatus = "Suspended"
                    case .none: self.schType = "Active"
                    case .some(_): break
                    }
                })
                <<< PhoneRow() {
                    $0.title = "No of Schedule"
                    $0.placeholder = "Add numbers here"
                    $0.value = "3"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "Start day"
                    $0.placeholder = "Add numbers here"
                    $0.value = "20"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "Start month"
                    $0.placeholder = "And numbers here"
                    $0.value = "07"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "Start year"
                    $0.placeholder = "And numbers here"
                    $0.value = "2021"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "End day"
                    $0.placeholder = "Add numbers here"
                    $0.value = "20"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "End month"
                    $0.placeholder = "And numbers here"
                    $0.value = "07"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "End year"
                    $0.placeholder = "And numbers here"
                    $0.value = "2030"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< TextRow() { row in
                    row.title = "Name"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< EmailRow() {row in
                    row.title = "Email Id"
                    row.placeholder = "Enter valid email id here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< TextRow() { row in
                    row.title = "Application Id"
                    row.placeholder = "Enter text here"
                    row.value = "SP"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                    }
                <<< PhoneRow() {
                    $0.title = "Merchant Reference"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS //"Schedule Pay"
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        var extraData = [String: Any]()
                        extraData["schType"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        extraData["schStatus"] = (self.form1?.allSections[0][1].baseValue as? String) ?? ""
                        extraData["nSch"] = (self.form1?.allSections[0][2].baseValue as? String) ?? ""
                        extraData["sMonth"] = (self.form1?.allSections[0][3].baseValue as? String) ?? ""
                        extraData["sDay"] = (self.form1?.allSections[0][4].baseValue as? String) ?? ""
                        extraData["sYear"] = (self.form1?.allSections[0][5].baseValue as? String) ?? ""
                        extraData["eMonth"] = (self.form1?.allSections[0][6].baseValue as? String) ?? ""
                        extraData["eDay"] = (self.form1?.allSections[0][7].baseValue as? String) ?? ""
                        extraData["eYear"] = (self.form1?.allSections[0][8].baseValue as? String) ?? ""
                        extraData["name"] = (self.form1?.allSections[0][9].baseValue as? String) ?? ""
                        extraData["email"] = (self.form1?.allSections[0][10].baseValue as? String) ?? ""
                        extraData["appId"] = "SP"
                        extraData["appRef"] = (self.form1?.allSections[0][11].baseValue as? String) ?? ""
                        self.viewController1?.VASValue(extraData: extraData)
                        self.navigationController?.popViewController(animated: true)
                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
                            self.viewController1?.processDirect(nil)
                        } else {
                            self.viewController1?.processHosted(nil)
                        }
                    } else {
                        self.onValidate()
                    }
                    //self.processDirect(nil)
                })
        } else if(VAS == "New Member Pay") {
            form1 =  form +++ Section("VAS details")
                <<< TextRow() { row in
                    row.title = "memberPay_memberId"
                    //row.value = "member03"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS//"New Member Pay"
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        var extraData = [String: Any]()
                        extraData["memberPay_memberId"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        extraData["memberPay_service"] = "T"
                        extraData["addNewMember"] = true
                        self.viewController1?.VASValue(extraData: extraData)
                        self.navigationController?.popViewController(animated: true)
                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
                            self.viewController1?.processDirect(nil)
                        } else {
                            self.viewController1?.processHosted(nil)
                        }
                    } else {
                        self.onValidate()
                    }
                    //self.processHosted(nil)
                })
            
        } else if(VAS == "Old Member Pay") {
            form1 =  form +++ Section("VAS details")
                <<< TextRow() { row in
                    row.title = "memberPay_memberId"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "memberPayToken"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS//"Old Member Pay"
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        var extraData = [String: Any]()
                        extraData["memberPay_memberId"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        extraData["memberPay_service"] = "T"
                        extraData["memberPay_token"] = self.form1?.allSections[0][1].baseValue
                        extraData["addNewMember"] = false
                        self.viewController1?.VASValue(extraData: extraData)
                        self.navigationController?.popViewController(animated: true)
                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
                            self.viewController1?.processDirect(nil)
                        } else {
                            self.viewController1?.processHosted(nil)
                        }
                    } else {
                        self.onValidate()
                    }
                    //self.processHosted(nil)
                })
        } else if(VAS == "TRANS QUERY") {
            form1 =  form +++ Section("VAS details")
                <<< TextRow() { row in
                    row.title = "payRef"
                    //row.value = "member03"
                    row.placeholder = "Enter text here"
                    row.value = ""
//                    row.add(rule: RuleRequired())
//                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
//                        AppDelegate().payref = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
//                        let
                        self.viewController1?.payref = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                        let extraData = [String: Any]()
                        self.viewController1?.VASValue(extraData: extraData)
//                        self.viewController1?.setPayRef(ref: payref)
                        self.navigationController?.popViewController(animated: true)
                        self.viewController1?.transQuery()
//                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
//                            self.viewController1?.processDirect(nil)
//                        } else {
//                            self.viewController1?.processHosted(nil)
//                        }
                    } else {
                        self.onValidate()
                    }
                    //self.processHosted(nil)
                })
            
        } else if(VAS == "THREEDS2") {
            form1 =  form +++ Section("VAS details")
                <<< TextRow() { row in
                    row.title = "Customer Email"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Mobile Phone Country Code"
                    $0.placeholder = "Add numbers here"
                    $0.value = " "
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Mobile Phone Number"
                    $0.placeholder = "Add numbers here"
                    $0.value = " "
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Home Phone Country Code"
                    $0.placeholder = "Add numbers here"
                    $0.value = " "
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Home Phone Number"
                    $0.placeholder = "Add numbers here"
                    $0.value = " "
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Work Phone Country Code"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Work Phone Number"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Delivery Email"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Billing Country Code"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Billing State"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Billing City"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Billing Line 1"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Billing Line 2"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Billing Line 3"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Billing Postal Code"
                    $0.placeholder = "Add numbers here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Shipping Details"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Shipping Country Code"
                    $0.placeholder = "Add numbers here"
                    $0.value = " "
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Shipping State"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Shipping City"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Shipping Line 1"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Shipping Line 2"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< TextRow() { row in
                    row.title = "Shipping Line 3"
                    row.placeholder = "Enter text here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Create Date"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Age"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Last Date Changed"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Last Change Indication"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Password Date Change"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Password Date Changed Ind"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Purchase Count"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Card Provision Attempt"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Transation Day"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Transaction Year"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Payment Acct Date"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Payment Acct Ind"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Shipping Addr change Date"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Shipping Addr change Ind"
                    $0.placeholder = "Enter text here"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PickerInputRow<String>("Picker Input Row1") {
                    $0.title = "Account name same as Shipping"
                    $0.options = ["T","F"]
                    $0.value = $0.options.first
                    
                }.onChange({ (str) in
                    switch str.value {
                    case "T" :   self.isAcNameSameAsShip = "T"
                    case "F" :   self.isAcNameSameAsShip = "F"
                    case .none: self.isAcNameSameAsShip = "T"
                    case .some(_): break
                    }
                })
                <<< PickerInputRow<String>("Picker Input Row2") {
                    $0.title = "is account suspicious one(T/F)"
                    $0.options = ["T","F"]
                    $0.value = $0.options.first
                    
                }.onChange({ (str) in
                    switch str.value {
                    case "T" :   self.isAccountSuspisious = "T"
                    case "F" :   self.isAccountSuspisious = "F"
                    case .none: self.isAccountSuspisious = "F"
                    case .some(_): break
                    }
                })
                <<< PhoneRow() {
                    $0.title = "Account Auth Method"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Account Auth TimeStamp"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Delivery Time"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "PreOrder Reason"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Auth Timestamp"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PhoneRow() {
                    $0.title = "Gift Card Amount"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.titleLabel?.textColor = .systemRed
                            //ValidationError(msg: "Field required!")
                        }
                }
                <<< PickerInputRow<String>("Picker Input Row3") {
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
                <<< PhoneRow() {
                    $0.title = "Gift Card Count"
                    $0.placeholder = "Add numbers here"
                    $0.value = ""
                }
                <<< ButtonRow() { (row: ButtonRow) in
                    row.title = VAS
                }.onCellSelection({ (str, row) in
                    if self.form1!.validate().isEmpty {
                        /*let threeDSParams = ThreeDSParams()
                                threeDSParams.threeDSCustomerEmail = "example@example.com"
                                threeDSParams.threeDSDeliveryEmail = "example@example.com"
                                threeDSParams.threeDSMobilePhoneCountryCode = "852"
                                threeDSParams.threeDSMobilePhoneNumber = "9000000000"
                                threeDSParams.threeDSHomePhoneCountryCode = "852"
                                threeDSParams.threeDSHomePhoneNumber = "8000000000"
                                threeDSParams.threeDSWorkPhoneCountryCode = "852"
                                threeDSParams.threeDSWorkPhoneNumber = "7000000000"
                                threeDSParams.threeDSBillingCountryCode = "344"
                                threeDSParams.threeDSBillingState = ""
                                threeDSParams.threeDSBillingCity = "Hong Kong"
                                threeDSParams.threeDSBillingLine1 = "threeDSBillingLine1"
                                threeDSParams.threeDSBillingLine2 = "threeDSBillingLine2"
                                threeDSParams.threeDSBillingLine3 = "threeDSBillingLine3"
                                threeDSParams.threeDSBillingPostalCode = "121245"
                                threeDSParams.threeDSShippingDetails = "01"
                                threeDSParams.threeDSShippingCountryCode = "344"
                                threeDSParams.threeDSShippingState = ""
                                threeDSParams.threeDSShippingCity = "Hong Kong"
                                threeDSParams.threeDSShippingLine1 = "threeDSShippingLine1"
                                threeDSParams.threeDSShippingLine2 = "threeDSShippingLine2"
                                threeDSParams.threeDSShippingLine3 = "threeDSShippingLine3"
                                threeDSParams.threeDSAcctCreateDate = "20190401"
                                threeDSParams.threeDSAcctAgeInd = "01"
                                threeDSParams.threeDSAcctLastChangeDate = "20190401"
                                threeDSParams.threeDSAcctLastChangeInd = "01"
                                threeDSParams.threeDSAcctPwChangeDate = "20190401"
                                threeDSParams.threeDSAcctPwChangeInd = "01"
                                threeDSParams.threeDSAcctPurchaseCount = "10"
                                threeDSParams.threeDSAcctCardProvisionAttempt = "0"
                                threeDSParams.threeDSAcctNumTransDay = "0"
                                threeDSParams.threeDSAcctNumTransYear = "1"
                                threeDSParams.threeDSAcctPaymentAcctDate = "20190401"
                                threeDSParams.threeDSAcctPaymentAcctInd = "01"
                                threeDSParams.threeDSAcctShippingAddrLastChangeDate = "20190401"
                                threeDSParams.threeDSAcctShippingAddrLastChangeInd = "01"
                                threeDSParams.threeDSAcctIsShippingAcctNameSame = "T"
                                threeDSParams.threeDSAcctIsSuspiciousAcct = "F"
                                threeDSParams.threeDSAcctAuthMethod = "01"
                                threeDSParams.threeDSAcctAuthTimestamp = "20190401"
                                threeDSParams.threeDSDeliveryTime = "04"
                                threeDSParams.threeDSPreOrderReason = "01"
                                threeDSParams.threeDSPreOrderReadyDate = "20190401"
                                threeDSParams.threeDSGiftCardAmount = "5"
                                threeDSParams.threeDSGiftCardCurr = "344"
                                threeDSParams.threeDSGiftCardCount = "1"
                                threeDSParams.threeDSSdkMaxTimeout = "05"
                                threeDSParams.threeDSSdkInterface = "03"*/
//                    {
//
//                        let threeDSParams = ThreeDSParams()
//                        threeDSParams.threeDSCustomerEmail = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
//                        threeDSParams.threeDSMobilePhoneCountryCode = (self.form1?.allSections[0][1].baseValue as? String) ?? ""
//                        threeDSParams.threeDSMobilePhoneNumber = (self.form1?.allSections[0][2].baseValue as? String) ?? ""
//                        threeDSParams.threeDSHomePhoneCountryCode = (self.form1?.allSections[0][3].baseValue as? String) ?? ""
//                        threeDSParams.threeDSHomePhoneNumber = (self.form1?.allSections[0][4].baseValue as? String) ?? ""
//                        threeDSParams.threeDSWorkPhoneCountryCode = (self.form1?.allSections[0][5].baseValue as? String) ?? ""
//                        threeDSParams.threeDSWorkPhoneNumber = (self.form1?.allSections[0][6].baseValue as? String) ?? ""
//                        threeDSParams.threeDSDeliveryEmail = (self.form1?.allSections[0][7].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingCountryCode = (self.form1?.allSections[0][8].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingState = (self.form1?.allSections[0][9].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingCity = (self.form1?.allSections[0][10].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingLine1 = (self.form1?.allSections[0][11].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingLine2 = (self.form1?.allSections[0][12].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingLine3 = (self.form1?.allSections[0][13].baseValue as? String) ?? ""
//                        threeDSParams.threeDSBillingPostalCode = (self.form1?.allSections[0][14].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingDetails = (self.form1?.allSections[0][15].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingCountryCode = (self.form1?.allSections[0][16].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingState = (self.form1?.allSections[0][17].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingCity = (self.form1?.allSections[0][18].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingLine1 = (self.form1?.allSections[0][19].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingLine2 = (self.form1?.allSections[0][20].baseValue as? String) ?? ""
//                        threeDSParams.threeDSShippingLine3 = (self.form1?.allSections[0][21].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctCreateDate = (self.form1?.allSections[0][22].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctAgeInd = (self.form1?.allSections[0][23].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctLastChangeDate = (self.form1?.allSections[0][24].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctLastChangeInd = (self.form1?.allSections[0][25].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctPwChangeDate = (self.form1?.allSections[0][26].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctPwChangeInd = (self.form1?.allSections[0][27].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctPurchaseCount = (self.form1?.allSections[0][28].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctCardProvisionAttempt = (self.form1?.allSections[0][29].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctNumTransDay = (self.form1?.allSections[0][30].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctNumTransYear = (self.form1?.allSections[0][31].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctPaymentAcctDate = (self.form1?.allSections[0][32].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctPaymentAcctInd = (self.form1?.allSections[0][33].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctShippingAddrLastChangeDate = (self.form1?.allSections[0][34].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctShippingAddrLastChangeInd = (self.form1?.allSections[0][35].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctIsShippingAcctNameSame = (self.form1?.allSections[0][36].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctIsSuspiciousAcct = (self.form1?.allSections[0][37].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctAuthMethod = (self.form1?.allSections[0][38].baseValue as? String) ?? ""
//                        threeDSParams.threeDSAcctAuthTimestamp = (self.form1?.allSections[0][39].baseValue as? String) ?? ""
//                        threeDSParams.threeDSDeliveryTime = (self.form1?.allSections[0][40].baseValue as? String) ?? ""
//                        threeDSParams.threeDSPreOrderReason = (self.form1?.allSections[0][41].baseValue as? String) ?? ""
//                        threeDSParams.threeDSPreOrderReadyDate = (self.form1?.allSections[0][42].baseValue as? String) ?? ""
//                        threeDSParams.threeDSGiftCardAmount = (self.form1?.allSections[0][43].baseValue as? String) ?? ""
//                        threeDSParams.threeDSGiftCardCurr = (self.form1?.allSections[0][44].baseValue as? String) ?? ""
//                        threeDSParams.threeDSGiftCardCount = (self.form1?.allSections[0][45].baseValue as? String) ?? ""
//                        threeDSParams.threeDSSdkMaxTimeout = "05"
//                        threeDSParams.threeDSSdkInterface =  "03"
//                        //self.viewController1?.setThreeDSParams(params: threeDSParams)
//                        self.viewController1?.setThreeDSParams(params: threeDSParams)
//                        self.navigationController?.popViewController(animated: true)
//                        if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
//                            self.viewController1?.processDirect(nil)
//                        } else {
//                            self.viewController1?.processHosted(nil)
//                        }
                    } else {
                        self.onValidate()
                    }
                })
        }  else if(VAS == "EVoucher") {
                    form1 =  form +++ Section("VAS details")
                        <<< TextRow() { row in
                            row.title = "EVoucher Class Code"
                            //row.value = "member03"
                            row.placeholder = "Enter text here"
                            row.add(rule: RuleRequired())
                            row.validationOptions = .validatesOnChange
                            }.cellUpdate { cell, row in
                                if !row.isValid {
                                    cell.titleLabel?.textColor = .systemRed
                                    //ValidationError(msg: "Field required!")
                                }
                        }
                        <<< ButtonRow() { (row: ButtonRow) in
                            row.title = VAS//"Installment Pay"
                        }.onCellSelection({ (str, row) in
                            if self.form1!.validate().isEmpty {
                                var extraData = [String: Any]()
                                extraData["eVoucher"] = "T"
                                extraData["eVClassCode"] = (self.form1?.allSections[0][0].baseValue as? String) ?? ""
                                
                                self.viewController1?.VASValue(extraData: extraData)
                                self.navigationController?.popViewController(animated: true)
//                                if self.viewController1?.form1?.allSections[0][3].baseValue != nil {
//                                    self.viewController1?.processDirect(nil)
//                                } else {
                                    self.viewController1?.processHosted(nil)
//                                }
                            } else {
                                self.onValidate()
                            }
                            //self.processHosted(nil)
                        })
                    
                }
    }
    
    
    func onValidate() {
        let alert = UIAlertController(title: nil, message: "Required valid input", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



