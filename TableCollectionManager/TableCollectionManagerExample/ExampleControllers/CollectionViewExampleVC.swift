//
//  CollectionViewExampleVC.swift
//  TableCollectionManagerExample
//
//  Created by Dima Mishchenko on 28.02.2020.
//  Copyright © 2020 Dmytro Mishchenko. All rights reserved.
//

import UIKit
import TableCollectionManager

class CollectionViewExampleVC: UIViewController {
  
  let manager = CollectionManager()
  var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Actions
  
  @objc private func addSection() {
    addSectionAlert { [weak self] headerTitle, footerTitle, numberOfItems in
      
      guard numberOfItems > 0 else { return }
      
      let section = CollectionSection(rows: (1...numberOfItems).map {
        CollectionRow<Cell>("Row #\($0)")
      })
      
      if let title = headerTitle, !title.isEmpty {
        section.header = CollectionHeaderFooter<HeaderFooter>(title)
      }
      
      if let title = footerTitle, !title.isEmpty {
        section.footer = CollectionHeaderFooter<HeaderFooter>(title)
      }
      
      self?.manager.storage.append(section)
    }
  }
  
  @objc private func deleteSection() {
    indexAlert("Delete section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      self?.manager.storage.delete(section)
    }
  }
  
  @objc private func addRow() {
    indexAlert("Add row to section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      
      let row = CollectionRow<Cell>("Row #\(section.numberOfRows + 1)")
      self?.manager.storage.append(row, to: sectionIndex)
    }
  }
  
  @objc private func deleteRow() {
    indexAlert("Delete last row at section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      guard let row = section.rows.last else { return }
      self?.manager.storage.delete(row)
    }
  }
  
  // MARK: - Private
  
  private func setupUI() {
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(title: "➕Section", style: .plain, target: self, action: #selector(addSection)),
      UIBarButtonItem(title: "❌Section", style: .plain, target: self, action: #selector(deleteSection)),
      UIBarButtonItem(title: "➕Row", style: .plain, target: self, action: #selector(addRow)),
      UIBarButtonItem(title: "❌Row", style: .plain, target: self, action: #selector(deleteRow))
    ]
    
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    view.addSubview(collectionView)
    
    collectionView.backgroundColor = .white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = true
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    manager.collectionView = collectionView
  }
  
  private func addSectionAlert(_ completion: @escaping (String?, String?, Int) -> Void) {
    let alert = UIAlertController(title: "Add Section", message: "", preferredStyle: .alert)
    
    alert.addTextField { $0.placeholder = "Header text" }
    alert.addTextField { $0.placeholder = "Footer text" }
    alert.addTextField { $0.placeholder = "Number of rows" }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
      completion(
        alert?.textFields?[0].text,
        alert?.textFields?[1].text,
        Int(alert?.textFields?[2].text ?? "0") ?? 0
      )
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
  private func indexAlert(_ title: String, _ completion: @escaping (Int) -> Void) {
    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
    
    alert.addTextField { $0.placeholder = "At index" }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
      completion(Int(alert?.textFields?[0].text ?? "0") ?? 0)
    }))
    
    present(alert, animated: true, completion: nil)
  }
}

extension CollectionViewExampleVC {
  
  class Cell: UICollectionViewCell, CollectionConfigurable {
    
    static var size: CGSize? {
      CGSize(width: 100, height: 100)
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      contentView.backgroundColor = .lightGray
      
      contentView.addSubview(label)
      
      label.translatesAutoresizingMaskIntoConstraints = false
      
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: String) {
      label.text = model
    }
  }
  
  class HeaderFooter: UICollectionReusableView, CollectionConfigurable {
    
    static var size: CGSize? {
      CGSize(width: .zero, height: 44)
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(label)
      
      label.translatesAutoresizingMaskIntoConstraints = false
      
      label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: String) {
      label.text = model
    }
  }
}
