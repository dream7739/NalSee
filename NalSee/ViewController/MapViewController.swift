//
//  MapViewController.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import UIKit
import CoreLocation //현 위치 가져오기 위함
import MapKit
import SnapKit


//진입시 권한 체크
//권한이 있으면 현재위치를 가져오고, 아니면 영등포캠퍼스로 보여줌
//특정 위치를 선택하면 어노테이션이 뜸
//어노테이션이 클릭되면 날씨정보를 가져올지 alert를 표시
//alert에서 확인을 누르면 메인화면에서 위경도 기반으로 날씨를 다시 조회(클로저로 값 전달)
final class MapViewController: BaseViewController {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let defaultLocation = CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "MAP"
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
        print(#function)
        
        //지도상의 위치로 변환
        let location: CGPoint = sender.location(in: self.mapView)
        
        //지도상의 위치로 위경도 값 변환
        let mapPoint: CLLocationCoordinate2D = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        //annotation 생성
        configureAnnotation(mapPoint)
    }
}

extension MapViewController {
    //기기의 위치권한 체크 => 가능할 경우에만 현위치 권한 체크
    //권한이 없다면 => 설정화면에서 위치서비스를 켜기 위해 이동
    private func checkDeviceLocationAuthorization(){
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkCurrentLocationAuthorization()
            }else{
                self.presentAlert("알림", "현재 위치를 조회하기 위해 기기의 위치서비스를 켜주세요", "확인"){ _ in
                    if let setting = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(setting)
                    }
                }
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
    
    //기본위치를 영등포 캠퍼스로 설정한 뒤
    //해당 위치에 annotation을 그려줌
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

extension MapViewController: CLLocationManagerDelegate {
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        print(#function)
    }
}
