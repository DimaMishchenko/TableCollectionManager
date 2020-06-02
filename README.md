# TableCollectionManager

`TableCollectionManager` is lightweight generic library that allows you to build table and collection views in a declarative type-safe style. 

- [x] Type-safe generic cells and models

- [x] Functional programming style
- [x] No need for delegates and data sources
- [x] Automatic update for View with Model 

## Table of content

- [Installation](#Installation)
- [Usage](#Usage)
  - [TableView](#TableView)
    - [Quick start](#Table-Quick-start)
    - [Cell](#TableCell)
    - [Row](#TableRow)
    - [Header/Footer](#TableHeaderFooter)
    - [Section](#TableSection)
    - [Storage](#TableStorage)
    - [Manager](#TableManager)
  - [CollectionView](#CollectionView)
    - [Quick start](#Collection-Quick-start)
    - [Cell](#CollectionCell)
    - [Row](#CollectionRow)
    - [Header/Footer](#CollectionHeaderFooter)
    - [Section](#CollectionSection)
    - [Storage](#CollectionStorage)
    - [Manager](#CollectionManager)
- [License](#License)

## Installation

- add following to `Podfile`
``` ruby
pod 'TableCollectionManager'
```
- Run `pod install`.
- Add to files:
``` swift
import TableCollectionManager
```

## Usage

The main idea is that you have manager to manage table/collection view. And the manager have storage that you can update with items. After that magic happens and view will updates and reloads automatically. Also you can easily handle actions in functional style.

### TableView

#### Table Quick start 

```swift
import TableCollectionManager

// create cell and implement TableConfigurable

class ExampleCell: UITableViewCell, TableConfigurable {
  
  func update(with model: String) {
    textLabel?.text = model
  }
}

class VC: UIViewController {
  
  // init manager
  let manager = TableManager()
  var tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set tableView to manager
    manager.tableView = tableView
    
    // create rows
    
    let firstRow = TableRow<ExampleCell>("First").didSelect { result in
      // result.model - cell model  
      // result.cell - cell 
			// result.indexPath - indexPath                       
      print("first")
    }
    
    let secondRow = TableRow<ExampleCell>("Second").didSelect { _ in                    
      print("second")
    }
    
    // add rows to storage
    manager.storage.append([firstRow, secondRow])
  }
}

```

#### TableCell

To use cells with TableManager you have to implement `TableConfigurable` protocol.

You have to implement  `update(with:)` func to provide model type. 

Imagine you have `Pet` object and you want to create cell to show data of this item. In this case cell will look like this.

```swift
struct Pet {
  
  let name: String
  let age: Int
}

class PetCell: UITableViewCell, TableConfigurable {
  
  func update(with model: Pet) {
    // fill cell with data 
    textLabel?.text = "\(model.name) is \(model.age) years old"
  }
}
```

You can also provide cell `height` and `estimatedHeight`. By default they equals `UITableView.automaticDimension`.

`````swift
class Cell: UITableViewCell, TableConfigurable {
  
  // custom height
  static var height: CGFloat { 
    44
  }
  
  // custom estimatedHeight
  static var estimatedHeight: CGFloat { 
    44
  }
  
  func update(with model: String) {
 
  }
}
`````

You also don't have to register cell. `TableManager` will do this for you.

#### TableRow

`TableRow` is a wrapper around cell. So you only work with rows and models (viewModel) for this row. 

To create `TableRow` provide cell type and model instance.

```swift
let pet = Pet(name: "Elon", age: 2)
let petRow = TableRow<PetCell>(pet)
```

You can also subscribe on some actions from `UITableViewDelegate/UITableViewDataSource`. For example you want `didSelect`  for this row. In this case just call `didSelect`.

```swift
petRow.didSelect { result in
  // do something
  // result.model - cell model  
  // result.cell - cell 	
  // result.indexPath - indexPath                       
}
```

`TableRow` supports this actions:

- `didSelect`

- `didDeselect`

- `willSelect`

- `willDeselect`

- `willDisplay`

- `didEndDisplaying`

- `moveTo`

- `shouldHighlight`

- `editingStyle`

- `leadingSwipeActions`

- `trailingSwipeActions`

- `canEdit`

- `canMove`
- ` commitStyle`
- ` move`

You can also chain actions.

```swift
let row = TableRow<Cell>(model).didSelect { _ in
  print("selected")
}.willDisplay { _ in
  print("willDisplay")
}.canEdit { _ in
  return true
}
```

#### TableHeaderFooter

Headers and footer works almost like cells. The only difference is that `estimatedHeight` not optional.

```swift
class HeaderFooter: UITableViewHeaderFooterView, TableConfigurable {
  
  // required
  static var estimatedHeight: CGFloat {
    44
  }
  
  // optional (UITableView.automaticDimension by default)
  static var height: CGFloat { 
    44
  }
  
  func update(with model: String) {
    textLabel?.text = model
  }
}
```

`TableHeaderFooter` is a wrapper for headers and footers. To add them to table view just do this.

```swift
let header = TableHeaderFooter<HeaderFooter>("Header")
// add header to section at index
manager.storage.setHeader(header, to: 0)

let footer = TableHeaderFooter<HeaderFooter>("Footer")
// add header to section at index
manager.storage.setFooter(footer, to: 1)
```

#### TableSection

`TableSection` is a wrapper around `UITableView` sections. If you have more then one section in you table view you should use `TableSection`. You can set rows, header and footer to each section.

```swift
let rows = (1...10).map { TableRow<Cell>("\($0)") }
let header = TableHeaderFooter<HeaderFooter>("Header")
let footer = TableHeaderFooter<HeaderFooter>("Footer")

let section = TableSection(
  rows: rows,
  header: header,
  footer: footer
)

manager.storage.append(section)
```

#### TableStorage

`TableStorage` is a place where all sections and rows store. Each `TableManager` has storage. And if pass data to this storage table view will updates automatically.

```swift
manager.storage.append(sections)
manager.storage.delete(row)
manager.storage.reload(rows)
// and ect.
```

You can also get index of section, indexPath of row, section at index or row at indexPath.

```swift
let sectionIndex = manager.storage.index(for: section)
let rowIndexPath = manager.storage.indexPath(for: row)

let section = manager.storage.section(at: index)
let row = manager.storage.row(at: indexPath)
```

Storage has `performWithoutAnimation` block. Every change you call inside this block will perform without animation.

```swift 
manager.storage.performWithoutAnimation {
  manager.storage.append(sections)
  manager.storage.reload(rows)
}
```

Storage has `performBatchUpdate` block. You can use this method in cases where you want to make multiple changes in one single animated operation.

```swift
manager.storage.performBatchUpdate({
  manager.storage.append(sections)
  manager.storage.delete(row)
}, completion: { isFinished in
  // completion
})
```

All storage functionality

- `isEmpty`

- `numberOfSections`

- `numberOfAllRows`

- `index(for section:)`

- `indexPath(for row:)`

- `section(at index:)`

- `row(at indexPath:)`

- `performWithoutAnimation(_ block:)`

- `performBatchUpdate(_ block:, completion:)`

- `reload()`

- `reload(_ row:)`

- `reload(_ rows:)`

- `reload(_ section:)`

- `reload(_ sections:)`

- `append(_ row:)`

- `append(_ rows:)`

- `append(_ row:, to sectionIndex:)`

- `append(_ rows:, to sectionIndex:)`

- `append(_ section:)`

- `append(_ sections:)`

- `insert(_ row:, at indexPath:)`

- `insert(_ section:, at index:)`

- `delete(_ row:)`

- `delete(_ rows:)`

- `delete(_ section:)`

- `delete(_ sections:)`

- `deleteAllItems()`

- `moveRowWithoutUpdate(from source:, to destination:)`

- `moveRow(from source:, to destination:)`

- `moveSection(from source:, to destination:)`

#### TableManager

`TableManager` is object that manage all the delegates and data sources. Manager holds `storage` and `tableView`. You can change both of them.

Manager also has `scrollHandler` which handles `UIScrollViewDelegate`.

```swift
manager.scrollHandler.didScroll {
  print("didScroll")
}.shouldScrollToTop {
  return true
}
```

### CollectionView

#### Collection Quick start 

```swift
import TableCollectionManager

// create cell and implement CollectionConfigurable

class ExampleCell: UICollectionViewCell, CollectionConfigurable {
  
  func update(with model: String) {
    textLabel?.text = model
  }
}

class VC: UIViewController {
  
  // init manager
  let manager = CollectionManager()
	var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set collectionView to manager
    manager.collectionView = collectionView
    
    // create rows
    
    let firstRow = CollectionRow<ExampleCell>("First").didSelect { result in
      // result.model - cell model  
      // result.cell - cell 
			// result.indexPath - indexPath                       
      print("first")
    }
    
    let secondRow = CollectionRow<ExampleCell>("Second").didSelect { _ in                    
      print("second")
    }
    
    // add rows to storage
    manager.storage.append([firstRow, secondRow])
  }
}

```

#### CollectionCell

To use cells with TableManager you have to implement `CollectionConfigurable` protocol.

You have to implement  `update(with:)` func to provide model type. 

Imagine you have `Pet` object and you want to create cell to show data of this item. In this case cell will look like this.

```swift
struct Pet {
  
  let name: String
  let age: Int
}

class PetCell: UICollectionViewCell, CollectionConfigurable {
  
  func update(with model: Pet) {
    // fill cell with data 
  }
}
```

You can also provide cell `size`. It's optional you can also provide height using `UICollectionViewLayout` or using `layoutHandler` of [ `CollectionManager`](#CollectionManager).

`````swift
class Cell: UICollectionViewCell, CollectionConfigurable {
  
  // custom size
  static var size: CGSize? {
    CGSize(width: 44, height: 44)
  }
  
  func update(with model: String) {
 
  }
}
`````

You also don't have to register cell. `CollectionManager` will do this for you.

#### CollectionRow

`CollectionRow` is a wrapper around cell. So you only work with rows and models (viewModel) for this row. 

To create `CollectionRow` provide cell type and model instance.

```swift
let pet = Pet(name: "Elon", age: 2)
let petRow = CollectionRow<PetCell>(pet)
```

You can also subscribe on some actions from `UICollectionViewDelegate/UICollectionViewDataSource`. For example you want `didSelect`  for this row. In this case just call `didSelect`.

```swift
petRow.didSelect { result in
  // do something
  // result.model - cell model  
  // result.cell - cell 	
  // result.indexPath - indexPath                       
}
```

`CollectionRow` supports this actions:

- `didSelect`

- `didDeselect`

- `willDisplay`

- `didEndDisplaying`

- `moveTo`

- `shouldHighlight`

- `canMove`

- `move`

You can also chain actions.

```swift
let row = CollectionRow<Cell>(model).didSelect { _ in
  print("selected")
}.willDisplay { _ in
  print("willDisplay")
}
```

#### CollectionHeaderFooter

Headers and footer works almost like cells. Size handles same way as `CollectionRow`.

```swift
class HeaderFooter: UICollectionReusableView, CollectionConfigurable {
  
  // custom size
  static var size: CGSize? {
    CGSize(width: 44, height: 44)
  }
  
  func update(with model: String) {

  }
}
```

`CollectionHeaderFooter` is a wrapper for headers and footers. You can add headers/footers using sections.

```swift
let header = CollectionHeaderFooter<HeaderFooter>("Header")
let footer = CollectionHeaderFooter<HeaderFooter>("Footer")
let section = CollectionSection(
  rows: [],
  header: header,
  footer: footer
)
```

#### CollectionSection

`CollectionSection` is a wrapper around `UICollectioView` sections. If you have more then one section in you table view you should use `CollectionSection`. You can set rows, header and footer to each section.

```swift
let rows = (1...10).map { CollectioRow<Cell>("\($0)") }
let header = CollectionHeaderFooter<HeaderFooter>("Header")
let footer = CollectionHeaderFooter<HeaderFooter>("Footer")

let section = CollectionSection(
  rows: rows,
  header: header,
  footer: footer
)

manager.storage.append(section)
```

#### CollectionStorage

`CollectionStorage` is a place where all sections and rows store. Each `CollectionManager` has storage. And if pass data to this storage collectio view will updates automatically.

```swift
manager.storage.append(sections)
manager.storage.delete(row)
manager.storage.reload(rows)
// and ect.
```

You can also get index of section, indexPath of row, section at index or row at indexPath.

```swift
let sectionIndex = manager.storage.index(for: section)
let rowIndexPath = manager.storage.indexPath(for: row)

let section = manager.storage.section(at: index)
let row = manager.storage.row(at: indexPath)
```

Storage has `performWithoutAnimation` block. Every change you call inside this block will perform without animation.

```swift 
manager.storage.performWithoutAnimation {
  manager.storage.append(sections)
  manager.storage.reload(rows)
}
```

Storage has `performBatchUpdate` block. You can use this method in cases where you want to make multiple changes in one single animated operation.

```swift
manager.storage.performBatchUpdate({
  manager.storage.append(sections)
  manager.storage.delete(row)
}, completion: { isFinished in
  // completion
})
```

All storage functionality - same as [`TableStorage`](#TableStorage).

#### CollectionManager

`CollectionManager` is object that manage all the delegates and data sources. Manager holds `storage` and `collectionView`. You can change both of them.

Manager also has `scrollHandler` which handles `UIScrollViewDelegate`.

```swift
manager.scrollHandler.didScroll {
  print("didScroll")
}.shouldScrollToTop {
  return true
}
```

Manager also has `layoutHandler` which handles `UICollectionViewDelegateFlowLayout` and `collectionView(_ :transitionLayoutForOldLayout:newLayout:)` delegate method.

You can for example provide sizes for items.

```swift
manager.layoutHandler.sizeForItem { indexPath in
  return CGSize(width: 44, height: 44)
}.sizeForHeader { sectionIndex in
  return CGSize(width: 44, height: 44)
}
```

## License

**TableCollectionManager** is under MIT license. See the `LICENSE` file for more info.
