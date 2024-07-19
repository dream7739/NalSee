//
//  CitySearchViewModel.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import Foundation

final class WeatherCityViewModel {
    var inputViewDidLoadTrigger: CObservable<Void?> = CObservable(nil)
    var inputSearchText: CObservable<String> = CObservable("")
    
    var outputFilterCityResult: CObservable<[City]> = CObservable([])
    
    private var cityResult: [City] = []
    var coordSender: ((Coord) -> Void)?

    init(){
       transform()
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { [weak self] _ in
            do {
                try self?.configureBundleData()
            }catch let e as JsonParseError{
                print(e.localizedDescription)
            }catch {
                print("원인불명의 에러")
            }
        }
        
        inputSearchText.bind { [weak self] value in
            let trimText = value.trimmingCharacters(in: .whitespaces)
            
            if !trimText.isEmpty {
                self?.outputFilterCityResult.value = self?.cityResult.filter{
                    $0.name.localizedCaseInsensitiveContains(trimText)
                } ?? []
            }else{
                self?.outputFilterCityResult.value = self?.cityResult ?? []
            }
        }
    }
    
}

extension WeatherCityViewModel {
    private func configureBundleData() throws {
        let fileName = "CityList"
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            throw JsonParseError.failFileLocation
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            
            do {
                let list = try JSONDecoder().decode([City].self, from: data)
                cityResult = list
                outputFilterCityResult.value = list
            }catch{
                throw JsonParseError.failDataDecoding
            }
            
        }catch {
            throw JsonParseError.failDataParse
        }
    }
}
