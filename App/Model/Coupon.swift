//
//  Coupon.swift
//  App
//
//  Created by inchan on 2022/12/01.
//  Copyright © 2022 Enliple. All rights reserved.
//

import Foundation

struct Coupon: Codable {
    
    var couponId: String?
    var storeName: String?
    var productName: String?
    var priceInfo: PriceInfo?
    
    var number: String?

    var status: String?
    var expireDate: String?
    var canRefundDate: String?
    var canCancelPaymentDate: String?
    var issuedDate: String?
    var usedAt: String?
    var canCancelUseDate: String?
    var used: Bool?
    
    var representImageUrl: String?
    var redirectUrl: String?

    struct PriceInfo: Codable {
        var price: Int?
        var storeSalesPrice: Int?
        var storeSettlePrice: Int?
        var fee: Int?
        var feeRate: Int?
    }
    
}
