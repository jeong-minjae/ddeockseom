//
//  FacilityRecommendation.swift
//  hangangpark
//

import Foundation

struct FacilityRecommendation: Decodable, Identifiable, Equatable {
    let title: String
    let description: String
    let url: URL

    var id: String { url.absoluteString }
}
