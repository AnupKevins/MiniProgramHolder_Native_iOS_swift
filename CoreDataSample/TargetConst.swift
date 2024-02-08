//
//  TargetConst.swift
//  CoreDataSample
//
//  Created by Anup.Sahu on 30/12/20.
//  Copyright © 2020 Anup.Sahu. All rights reserved.
//

import Foundation

//use the flag we defined in custom swift flags under Build settings
       #if PRO
           var disableSpecialFeature = true
       #else
           var disableSpecialFeature = false
       #endif
