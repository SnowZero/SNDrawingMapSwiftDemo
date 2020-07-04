// ---------------------------------------------------------------------------
// Copyright (c) 2017 Snow
// Mobile App Development Team
// Created by: LIU,JNU-WEI
// Created Date: 2017/01/09
// Purpose:ViewController
// ---------------------------------------------------------------------------

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController ,MKMapViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var drawPolygonButton: UIButton!
    var coordinates = [CLLocationCoordinate2D]()
    var isDrawingPolygon :Bool = false
    let canvasView = CanvasView()

    enum ViewControllerError: Error {
        case AlertShowError
        case InsufficientFunds(coinsNeeded: Int)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        canvasView.frame = mapView.frame
        canvasView.delegate = self
        canvasView.isUserInteractionEnabled = true
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(25.0335, 121.5651)
        annotation.title = "101"
        annotation.subtitle = "真好吃"
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //處理畫線 Button開關，送出 Overlay 路徑
    @IBAction func didTouchUpInsideDrawButton(_ sender: Any) {
        if self.isDrawingPolygon == false {
            self.isDrawingPolygon = true
            self.drawPolygonButton.setTitle("done", for: .normal)
            self.coordinates.removeAll()
            self.view.addSubview(self.canvasView)
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        else {
            let numberOfPoints = self.coordinates.count
            if numberOfPoints > 2 {
                var points = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: numberOfPoints)
                for i in 0..<numberOfPoints {
                    points[i] = self.coordinates[i]
                }
                self.mapView.add(MKPolygon(coordinates: points, count: numberOfPoints))
            }
            self.isDrawingPolygon = false
            self.drawPolygonButton.setTitle("draw", for: .normal)
            self.canvasView.image = nil
            self.canvasView.removeFromSuperview()
        }
        print(coordinates);
    }
    
    func touchesBegan(_ touch: UITouch) {
        let location = touch.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: mapView)
        self.coordinates.append(NSValue.init(mkCoordinate: coordinate) as CLLocationCoordinate2D)

    }
    
    func touchesMoved(_ touch: UITouch) {
        let location = touch.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: mapView)
        self.coordinates.append(NSValue.init(mkCoordinate: coordinate) as CLLocationCoordinate2D)

    }
    
    func touchesEnded(_ touch: UITouch) {
        let location = touch.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: mapView)
        self.coordinates.append(NSValue.init(mkCoordinate: coordinate) as CLLocationCoordinate2D)
        
        didTouchUpInsideDrawButton(Any.self);
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayPolygon : MKPolygonRenderer
        overlayPolygon = MKPolygonRenderer(polygon: overlay as! MKPolygon)

        if (overlay is MKPolygon) {
            
            let mapPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(25.0335, 121.5651))
            let polygonViewPoint:CGPoint = overlayPolygon.point(for: mapPoint)
            
            let alertMessger:String
            
            if overlayPolygon.path.contains(polygonViewPoint) {
                alertMessger = "在範圍內"
            } else {
                alertMessger = "在範圍外"
            }
            showAlertMessger(messger: alertMessger, titleString: "圈內檢測結果")
            
            overlayPolygon.fillColor = UIColor.cyan.withAlphaComponent(0.2)
            overlayPolygon.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            overlayPolygon.lineWidth = 3
            return overlayPolygon
        }else if (overlay is MKPolyline) {
            overlayPolygon.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            overlayPolygon.lineWidth = 3
            return overlayPolygon
        }
        return overlayPolygon
        
    }
    
    // show alert 訊息 messger:傳入文字訊息 titleString：傳標題 return: true成功 false失敗
    func showAlertMessger(messger:String , titleString:String)  {
        
        let alert = UIAlertController(title: titleString, message: messger, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
}

