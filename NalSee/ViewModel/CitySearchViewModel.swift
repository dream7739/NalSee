//
//  CitySearchViewModel.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import Foundation
import RxSwift

class CitySearchViewModel {
    var cityList: [City] = []

    init(){
        do {
            try configureBundleData()
        }catch let e as JsonParseError{
            print(e.localizedDescription)
        }catch {
            print("원인불명의 에러")
        }
    }
    
    func getCellData() -> Observable<[City]> {
        return Observable.of(cityList)
    }
}
extension CitySearchViewModel {
    func configureBundleData() throws {
        let fileName = "CityList"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            throw JsonParseError.failFileLocation
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            
            do {
                let list = try JSONDecoder().decode([City].self, from: data)
                cityList = list
            }catch{
                throw JsonParseError.failDataDecoding
            }
            
        }catch {
            throw JsonParseError.failDataParse
        }
    }
}
