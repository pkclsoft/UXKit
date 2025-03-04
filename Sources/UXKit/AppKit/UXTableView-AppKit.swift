//
//  UXKit
//
//  Copyright © 2016-2021 ZeeZide GmbH. All rights reserved.
//
#if os(macOS)
  import Cocoa
      
  public typealias UXTableView          = NSTableView
  
  /**
   * This is the type of the view a tableview datasource is expected to return
   * (when creating a view for a row).
   *
   * On AppKit, this can be any view, but on UIKit, it *must* be a
   * UITableViewCell.
   *
   * Also note that on AppKit there is a `NSTableCellView`. This is *not* the
   * same like the `UITableViewCell`! The `NSTableCellView` doesn't create its
   * contents, but purely serves as an outlet holder for IB.
   *
   * To workaround that, we provide an own `NSTableViewCell` which tries to
   * mirror what `UITableViewCell` does.
   */
  public typealias UXTableViewCellType  = NSTableCellView // Yes!
  
  /**
   * A concrete view which you can use in a view datasource. It provides an
   * image, label, detail-label, and a set of different styles.
   *
   * On iOS, this is builtin via `UITableViewCell`, and on macOS we provide
   * an own class for that (`NSTableViewCell`).
   */
  public typealias UXTableViewCell      = NSTableViewCell // Yes! (own)

  public typealias UXTableViewDelegate = NSTableViewDelegate
  public typealias UXTableViewDataSource = NSTableViewDataSource

  public enum      UXTableViewCellStyle {
    // Hm. Not really used for now.
    case `default`
    case value1
    case value2
    case subtitle
  }

// Not used for now.
public enum UXTableViewStyle {
    /// A plain table view.
    case plain
    /// A table view where sections have distinct groups of rows.
    case grouped
    /// A table view where the grouped sections are inset with rounded corners.
    case insetGrouped
}

  public protocol UXTableViewCellInit : AnyObject {
    init(style: UXTableViewCellStyle, reuseIdentifier: String?)
    func prepareForReuse()
  }

  /// Map UIKit options to AppKit options
  public extension NSTableView.AnimationOptions {
    static var fade   = effectFade
    static var right  = slideRight
    static var left   = slideLeft
    static var top    = slideUp
    static var bottom = slideDown
    static var none   : NSTableView.AnimationOptions = []
    static var middle = effectGap // TBD: is this the same?
    
    // TODO: automatic (make it depend on the modification operation)
    //       the 10.13 flags go till 0x40, so we could use a special raw
    static var automatic = slideDown
  }

public extension UXTableView  {
    
    convenience init(frame frameRect: UXRect, style: UXTableViewStyle, withSingleColumn: Bool = true) {
        
        self.init(frame: frameRect)
        
        self.allowsColumnResizing = false
        self.allowsColumnReordering = false
        self.allowsEmptySelection = false
        self.headerView = nil
        self.usesAlternatingRowBackgroundColors = false
        self.intercellSpacing = .zero
        
        if withSingleColumn {
            let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("tableColumn1"))
            col.width = frameRect.width
            col.isEditable = false
            self.addTableColumn(col)
        }
    }
        
    func insertRows(at indexes : [ IndexPath ],
                    with ao    : NSTableView.AnimationOptions? = nil)
    {
      insertRows(at: IndexSet.setForRowsInPathes(indexes),
                 withAnimation: ao ?? []) // FIXME: rather .slideUp?
    }
    
    func deleteRows(at indexes : [ IndexPath ],
                    with ao    : NSTableView.AnimationOptions? = nil)
    {
      removeRows(at: IndexSet.setForRowsInPathes(indexes),
                 withAnimation: ao ?? []) // FIXME: rather .slideDown?
    }
    
    func reloadRows(at indexes : [ IndexPath ],
                    with ao    : NSTableView.AnimationOptions? = nil)
    {
      // Note: no animation support
      reloadData(forRowIndexes: IndexSet.setForRowsInPathes(indexes),
                 columnIndexes: IndexSet(integer: 0))
    }
    
    func numberOfRows(inSection: Int) -> Int {
        return self.numberOfRows
    }
  }


 extension UXTableView {
    open override func edit(withFrame rect: NSRect, editor textObj: NSText, delegate: Any?, event: NSEvent) {
        textObj.becomeFirstResponder()
    }
}
  public extension UXTableView {
    
    /// UIKit compat method for `makeView(withIdentifier:owner:)`. This one
    /// passes `nil` as the owner.
    func dequeueReusableCell(withIdentifier identifier: String)
         -> UXTableViewCell?
    {
      return makeView(withIdentifier: UXUserInterfaceItemIdentifier(identifier),
                      owner: nil) as? UXTableViewCell
    }

    /// UIKit compat method for `makeView(withIdentifier:owner:)`. This one
    /// passes `nil` as the owner. The indexPath is ignored and has no effect
    /// on AppKit.
    /// Note: Raises a fatalError if the cell could not be constructed!
    func dequeueReusableCell(withIdentifier identifier: String,
                             for indexPath: IndexPath) -> UXTableViewCell
    {
      guard let v = dequeueReusableCell(withIdentifier: identifier) else {
        fatalError("could not construct cell for \(identifier)")
      }
      return v
    }

  }

public class UXCustomRowView: NSTableRowView {

    public override func drawSelection(in dirtyRect: NSRect) {
        
        if self.isSelected {
            if #available(macOS 10.14, *) {
                NSColor.selectedContentBackgroundColor.set()
            } else {
                // Fallback on earlier versions
                NSColor.selectedMenuItemColor.set()
            }
        } else {
            NSColor.clear.set()
        }
        
        dirtyRect.fill()
    }
}

#endif // os(macOS)
