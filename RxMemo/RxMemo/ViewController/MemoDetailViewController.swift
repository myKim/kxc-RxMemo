//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by 김명유 on 2022/02/17.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    
    
    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
