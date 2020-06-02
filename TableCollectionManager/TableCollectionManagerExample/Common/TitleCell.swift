//
//  TitleCell.swift
//  TableCollectionManagerExample
//
//  Created by Dima Mishchenko on 04.03.2020.
//  Copyright © 2020 Dmytro Mishchenko. All rights reserved.
//

import UIKit
import TableCollectionManager

class TitleCell: UITableViewCell, TableConfigurable {
  
  func update(with model: String) {
    textLabel?.text = model
  }
}
