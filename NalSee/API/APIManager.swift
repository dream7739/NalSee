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
    
    func callForecast(_ coord: Coord, completion: @escaping (Result<WeatherResult, AFError>) -> Void){
        let url = APIURL.weather + "?lat=\(coord.lat)&lon=\(coord.lat)&appid=\(APIKey.id)"
        
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
    
    func callCurrentForecast(_ coord: Coord, completion: @escaping (Result<CurrentWeatherResult, AFError>) -> Void){
        let url = APIURL.currentWeather + "?lat=\(coord.lat)&lon=\(coord.lon)&appid=\(APIKey.id)"
        
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
