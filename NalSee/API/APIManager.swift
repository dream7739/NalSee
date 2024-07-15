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
    
    func callForecast(lat: Double, lon: Double, completion: @escaping (Result<WeatherResult, AFError>) -> Void){
        let url = APIURL.weather + "?lat=\(lat)&lon=\(lon)&appid=\(APIKey.id)"
        
        AF.request(url, method: .get).responseDecodable(of: WeatherResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func callCurrentForecast(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherResult, AFError>) -> Void){
        let url = APIURL.currentWeather + "?lat=\(lat)&lon=\(lon)&appid=\(APIKey.id)"
        
        AF.request(url, method: .get).responseDecodable(of: CurrentWeatherResult.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
