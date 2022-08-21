//
//  PageData.swift
//  pinch
//
//  Created by Muhsin Munashif on 21/08/2022.
//

import Foundation

let pagesData: [Page] = [
    Page(id: 1, imagename: "magazine-front-cover"),
    Page(id: 2, imagename: "magazine-back-cover"),
]

extension Page {
    var thumbnailName: String {
        return "thumb-\(imagename)"
    }
}
