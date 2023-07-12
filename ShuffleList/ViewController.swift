//
//  ViewController.swift
//  RectangleGradient
//
//  Created by Pavel Parshutkin on 02.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = configureTableView()
    
    private var numbers = (0...30).map { $0 }
    private var selected: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)

        self.title = "List"
        self.navigationItem.rightBarButtonItem = .init(title: "shuffle", style: .plain, target: self, action: #selector(shuffleRows))
        self.setupConstraints()
        
    }
    
    @objc func shuffleRows() {

        let oldNumbers = self.numbers
        self.numbers = numbers.shuffled()
        
        self.tableView.beginUpdates()
        
        for (key, number) in self.numbers.enumerated() {
            self.tableView.moveRow(at: IndexPath(item: oldNumbers.firstIndex(of: number)!, section: 0), to: IndexPath(item: key, section: 0))
        }

        self.tableView.endUpdates()
        
    }

    private func configureTableView() -> UITableView {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        
        view.register(UITableViewCell.self, forCellReuseIdentifier: "number.cell")
        view.dataSource = self
        view.delegate = self
        
        view.reloadData()
        return view
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numbers.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "number.cell", for: indexPath)
        
        cell.textLabel?.text = "\(numbers[indexPath.row])"
        cell.accessoryType = selected.first(where: { $0 == self.numbers[indexPath.row] }) == nil ? .none : .checkmark

        return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemToMove = numbers[indexPath.row]
        
        let selectedItem = selected.first(where: { $0 == itemToMove })
        
        if selectedItem == nil {
            
            numbers.remove(at: indexPath.row)
            numbers.insert(itemToMove, at: 0)
            
            selected.append(itemToMove)
            
            let destinationindexPath = IndexPath(row: 0, section: indexPath.section)
            
            
            tableView.moveRow(at: indexPath, to: destinationindexPath )
            tableView.deselectRow(at: destinationindexPath, animated: true)
            tableView.reconfigureRows(at: [destinationindexPath])

        }
        else {
            
            selected.removeAll {
                $0 == selectedItem
            }
            
            tableView.reconfigureRows(at: [indexPath])
            tableView.deselectRow(at: indexPath, animated: true)
        }
      
        //tableView.reloadRows(at: [destinationindexPath], with: .none)
    }
    
    

}


extension ViewController: UITableViewDelegate {
    

}
