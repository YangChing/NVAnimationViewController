//
//  TestViewController.swift
//  AnimationScroller
//
//  Created by 馮仰靚 on 2018/1/19.
//  Copyright © 2018年 larvata.YC. All rights reserved.
//

import UIKit

class RestaurantInfoCell: UITableViewCell {
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
}

class TestViewController: NVAnimationViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return super.numberOfSections(in: tableView) + 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return super.tableView(tableView, numberOfRowsInSection: section)
    default:
      return 1
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
       return super.tableView(tableView, cellForRowAt: indexPath)
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoCell", for: indexPath)
      if let cell = cell as? RestaurantInfoCell {
        self.rightButton = cell.rightButton
        self.leftButton = cell.leftButton
        cell.leftButton.addTarget(self, action: #selector(self.isLikeButton), for: .touchDown)
      }
      return cell
    }
  }
  @objc func isLikeButton(){
    print("isLike")
  }
  override func back() {
    navigationController?.popViewController(animated: true)
  }

}
