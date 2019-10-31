//
//  DailyData+CoreDataProperties.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/21.
//  Copyright © 2019 Peking University. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyData> {
        return NSFetchRequest<DailyData>(entityName: "DailyData")
    }

    @NSManaged public var info: String?
    @NSManaged public var date: Date?
    @NSManaged public var minTemp: Int32
    @NSManaged public var maxTemp: Int32

}
