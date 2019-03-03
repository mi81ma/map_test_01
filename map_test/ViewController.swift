//
//  ViewController.swift
//  map_test
//
//  Created by masato on 3/3/2019.
//  Copyright © 2019 masato. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // mapViewを生成.
        let myMapView: MKMapView = MKMapView(frame: self.view.frame)

        // Delegateを設定.
        myMapView.delegate = self

        // 出発点の緯度、経度を設定.
        let myLatitude: CLLocationDegrees = 22.2769557
        let myLongitude: CLLocationDegrees = 114.1732044

        // 目的地の緯度、経度を設定.
        let requestLatitude: CLLocationDegrees = 22.2775939
        let requestLongitude: CLLocationDegrees = 114.1815274

        // 目的地の座標を指定.
        let requestCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(requestLatitude, requestLongitude)
        let fromCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)

        // 地図の中心を出発点と目的地の中間に設定する.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake((myLatitude + requestLatitude)/2, (myLongitude + requestLongitude)/2)

        // mapViewに中心をセットする.
        myMapView.setCenter(center, animated: true)

        // 縮尺を指定.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)

        // regionをmapViewにセット.
        myMapView.region = myRegion

        // viewにmapViewを追加.
        self.view.addSubview(myMapView)

        self.view.addSubview(loginButton)

        self.view.addSubview(oderNuberLabel)

        // PlaceMarkを生成して出発点、目的地の座標をセット.
        let fromPlace: MKPlacemark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let toPlace: MKPlacemark = MKPlacemark(coordinate: requestCoordinate, addressDictionary: nil)


        // Itemを生成してPlaceMarkをセット.
        let fromItem: MKMapItem = MKMapItem(placemark: fromPlace)
        let toItem: MKMapItem = MKMapItem(placemark: toPlace)

        // MKDirectionsRequestを生成.
        let myRequest: MKDirections.Request = MKDirections.Request()

        // 出発地のItemをセット.
        myRequest.source = fromItem

        // 目的地のItemをセット.
        myRequest.destination = toItem

        // 複数経路の検索を有効.
        myRequest.requestsAlternateRoutes = true

        // 移動手段を車に設定.
        myRequest.transportType = MKDirectionsTransportType.automobile

        // MKDirectionsを生成してRequestをセット.
        let myDirections: MKDirections = MKDirections(request: myRequest)

        // 経路探索.
        myDirections.calculate { (response, error) in

            // NSErrorを受け取ったか、ルートがない場合.
            if error != nil || response!.routes.isEmpty {
                return
            }

            let route: MKRoute = response!.routes[0] as MKRoute
            print("目的地まで \(route.distance)km")
            print("所要時間 \(Int(route.expectedTravelTime/60))分")

            // mapViewにルートを描画.
            myMapView.addOverlay(route.polyline)
        }

        // ピンを生成.
        let fromPin: MKPointAnnotation = MKPointAnnotation()
        let toPin: MKPointAnnotation = MKPointAnnotation()

        // 座標をセット.
        fromPin.coordinate = fromCoordinate
        toPin.coordinate = requestCoordinate

        // titleをセット.
        fromPin.title = "Transporter"
        toPin.title = "Customer"

        // mapViewに追加.
        myMapView.addAnnotation(fromPin)
        myMapView.addAnnotation(toPin)
    }

    // ルートの表示設定.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)

        // ルートの線の太さ.
        routeRenderer.lineWidth = 3.0

        // ルートの線の色.
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
    }


    // ******************************************************
    // View
    // ******************************************************


    lazy var oderNuberLabel: UILabel = {

        let welcomeTitleLabel = UILabel(frame: CGRect(x:view.frame.width / 2 - (350 / 2), y:self.view.frame.height / 10 * 1, width:350, height:30))

        welcomeTitleLabel.text = "Oder No.: 200123-123-12"
        welcomeTitleLabel.textAlignment = NSTextAlignment.center
        welcomeTitleLabel.font = UIFont(name: "Arial", size: 20.0)
        welcomeTitleLabel.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.heavy) // Font Weight
        welcomeTitleLabel.textColor = UIColor.black
        return welcomeTitleLabel

    }()


    // Login Button
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: CGRect(x:self.view.frame.width / 2 - (200 / 2),  y:self.view.frame.height / 10 * 8, width:200, height:50))
        view.tag = 1030

        loginButton.layer.cornerRadius = 5.0
        loginButton.backgroundColor =  #colorLiteral(red: 1, green: 0.4863265157, blue: 0, alpha: 1)
        loginButton.setTitle("DeliveredButton", for: .normal)
        loginButton.setBackgroundColor(color:  UIColor(red: 0, green: 0.4660990834, blue: 0.2602835298, alpha: 1), forState: .highlighted)

//        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchDown)

        loginButton.accessibilityIdentifier = "Delivered Customer"

        return loginButton
    }()


}


// Login Button Extension
extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

