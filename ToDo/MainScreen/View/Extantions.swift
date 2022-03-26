//
//  Extantions.swift
//  ToDo
//
//  Created by Антон on 27.03.2022.
//

import Foundation
import UIKit
extension MainView: UITableViewDelegate, UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return tasksModels.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
	return cell
}
}
