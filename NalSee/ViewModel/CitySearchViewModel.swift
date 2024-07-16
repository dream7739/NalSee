//
//  CitySearchViewModel.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import Foundation

final class CitySearchViewModel {
    var outputCityResult: CObservable<[City]> = CObservable([])
    var coordSender: ((Coord) -> Void)?

    init(){
        do {
            try configureBundleData()
        }catch let e as JsonParseError{
            print(e.localizedDescription)
        }catch {
            print("원인불명의 에러")
        }
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
                outputCityResult.value = list
            }catch{
                throw JsonParseError.failDataDecoding
            }
            
        }catch {
            throw JsonParseError.failDataParse
        }
    }
}
