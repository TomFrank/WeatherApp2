//
//  AirData+CoreDataProperties.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/21.
//  Copyright © 2019 Peking University. All rights reserved.
//
//

import Foundation
import CoreData


extension AirData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirData> {
        return NSFetchRequest<AirData>(entityName: "AirData")
    }

    @NSManaged public var aqi: Int32

}
