//
//  ViewController.swift
//  MyWeatherFinder
//
//  Created by Faisal Syed on 8/25/16.
//  Copyright © 2016 Faisal Syed. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var IBMapView: MKMapView!
    
    let OpenWeatherAPIKey = "dbcd27cf15e7a10315558c3ae018d7ef"
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        let touchPoint = gestureRecognizer.locationInView(IBMapView)
        let newCoordinates = IBMapView.convertPoint(touchPoint, toCoordinateFromView: IBMapView)
        
        addAnnotationOnLocation(newCoordinates)
    }
    
    func addAnnotationOnLocation(coordinates: CLLocationCoordinate2D)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Loading..."
        annotation.subtitle = "Loading..."
        IBMapView.addAnnotation(annotation)
        
        //Alamofire
        
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&APIKEY=\(OpenWeatherAPIKey)&units=metric"
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            
            switch response.result
            {
            case .Success(let data):
                dispatch_async(dispatch_get_main_queue())
                {
                    if let locationName:String = data["name"] as? String
                    {
                        annotation.title = locationName
                    }
                    
                    if let main:[NSObject:AnyObject] = data["main"] as? [NSObject:AnyObject]
                    {
                        if let temperature = main["temp"]
                        {
                            annotation.subtitle = "\(temperature)℃"
                            self.IBMapView.selectAnnotation(annotation, animated: true)
                        }
                    }
                }
                
            case .Failure(let error):
                print(error)
            }
        }
        

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func IBActionLongPress(sender: UILongPressGestureRecognizer)
    {
        handleLongPress(sender)
    }

}

