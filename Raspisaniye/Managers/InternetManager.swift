//
//  InternetManager.swift
//  Raspisaniye
//
//  Created by Ilya Mudriy on 09.02.16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InternetManager {
    
    // MARK: GET URL list
    fileprivate let serverURL = "http://appreu.styleru.net/api"
    
    fileprivate let getGroupList   = "/groups/"
    fileprivate let getLectorsList = "/lectors/"
    fileprivate let getLessonsList = "/lessons"

    // MARK: Singleton
    static let sharedInstance = InternetManager()

    // MARK: Get lists of groups and lectors
    func getGroupList(_ success:@escaping (JSON) -> (), failure:@escaping (Error)-> ()){

        DispatchQueue.global(qos: .background).async {

            DispatchQueue.main.async {
                SwiftSpinner.show("Получаем список групп")
            }
            let getRequest = self.serverURL + self.getGroupList
            Alamofire.request(getRequest, method: .get).validate(statusCode: 200..<300).responseJSON(completionHandler: {

                response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        success(json)
                    }

                    SwiftSpinner.hide()
                case .failure(let error):
                    failure(error)

                    SwiftSpinner.hide()

                }
            })

        }

    }

    func getLectorsList(_ success:@escaping (JSON) -> (), failure:@escaping (Error)-> ()){
        SwiftSpinner.show("Получаем список преподавателей")
        DispatchQueue.global(qos: .background).async {

            DispatchQueue.main.async {
                SwiftSpinner.show("Получаем список групп")
            }

        let getRequest = self.serverURL + self.getLectorsList
        Alamofire.request(getRequest, method: .get).validate(statusCode: 200..<300).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    success(json)
                }
                SwiftSpinner.hide()
            case .failure(let error):
                failure(error)
                SwiftSpinner.hide()
            }
        })
        }
    }
    
    func getLessonsList(_ params: Dictionary<String, AnyObject>, success:@escaping (JSON) -> (), failure:@escaping (Error) -> ()){
          SwiftSpinner.show("Загружаем расписание")
        let getRequest = serverURL + getLessonsList
        Alamofire.request(getRequest, method: .get,parameters: params).validate(statusCode: 200..<300).responseJSON(completionHandler: {
            response in
            print(response)
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    success(json)
                }
                 SwiftSpinner.hide()
            case .failure(let error):
                failure(error)
                 SwiftSpinner.hide()
            }
        })
    }
    
}






