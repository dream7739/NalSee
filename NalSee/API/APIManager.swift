//
//  APIManager.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    
    func callForecast(lat: Double, lon: Double){
        let url = APIURL.weather + "?lat=\(lat)&lon=\(lon)&appid=\(APIKey.id)"
        
        AF.request(url, method: .get).responseDecodable(of: WeatherResult.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
