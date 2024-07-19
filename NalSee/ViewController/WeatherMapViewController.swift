//
//  WeatherMapViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

final class WeatherMapViewController: BaseViewController {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let defaultLocation = CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463)
    var coordSender: ((Coord) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Map"
        navigationItem.largeTitleDisplayMode = .always
        
        mapView.delegate = self
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    override func configureHierarchy() {
        view.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        mapView.overrideUserInterfaceStyle = .dark
    }
    
    @objc func mapViewTapped(sender: UITapGestureRecognizer){
        let location: CGPoint = sender.location(in: self.mapView)
        let mapPoint: CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        configureAnnotation(mapPoint)
    }
}

extension WeatherMapViewController {
    private func checkDeviceLocationAuthorization(){
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkCurrentLocationAuthorization()
            }else{
                self.presentAlertForDeviceSetting()
            }
        }
    }
    
    private func presentAlertForDeviceSetting(){
        self.presentAlert("알림", "현재 위치를 조회하기 위해 기기의 위치서비스를 켜주세요", "확인"){ _ in
            if let setting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(setting)
            }
        }
    }
    
    private func checkCurrentLocationAuthorization(){
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *){
            status = locationManager.authorizationStatus
        }else{
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()      
        case .denied:
            configureLocation(center: defaultLocation)
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    private func configureLocation(center: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        configureAnnotation(center)
    }
    
    private func configureAnnotation(_ loc: CLLocationCoordinate2D){
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        mapView.addAnnotation(annotation)
    }
    
}

extension WeatherMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            configureLocation(center: coordinate)
        }
        
        manager.stopUpdatingLocation()
    }
}

extension WeatherMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        presentOptionAlert("알림", "선택한 위치로 날씨를 조회하시겠습니까?", "확인") { [weak self] _ in
            let center = mapView.region.center
            let coord = Coord(lat: center.latitude, lon: center.longitude)
            self?.coordSender?(coord)
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
