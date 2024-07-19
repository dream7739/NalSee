//
//  LocationCollectionViewCell.swift
//  NalSee
//
//  Created by 홍정민 on 7/14/24.
//

import UIKit
import MapKit
import SnapKit

final class LocationCollectionViewCell: BaseCollectionViewCell {
    private let mapView = MKMapView()
    
    override func configureHierarchy() {
        contentView.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    override func configureUI() {
        mapView.overrideUserInterfaceStyle = .dark
        mapView.isScrollEnabled = false
    }
    
    func setLocation(_ lat: Double, _ lon: Double){
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        configureAnnotation(center)
    }
    
    private func configureAnnotation(_ center: CLLocationCoordinate2D){
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
}
