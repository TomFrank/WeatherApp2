//
//  HourlyData+CoreDataProperties.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/21.
//  Copyright © 2019 Peking University. All rights reserved.
//
//

import Foundation
import CoreData


extension HourlyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourlyData> {
        return NSFetchRequest<HourlyData>(entityName: "HourlyData")
    }

    @NSManaged public var temp: Int32
    @NSManaged public var info: String?
    @NSManaged public var time: Date?

}
