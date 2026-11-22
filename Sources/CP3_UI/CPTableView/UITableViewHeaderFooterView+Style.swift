//
//  UITableViewHeaderFooterView+Style.swift
//  CP3_UI
//

#if canImport(UIKit)
import UIKit

extension UITableViewHeaderFooterView {

    /// Styles a section header: bold, uppercase and colored.
    ///
    /// Call from `tableView(_:willDisplayHeaderView:forSection:)`. This uses a content
    /// configuration because styling `textLabel` there isn't reliable anymore: the header's
    /// default configuration can override it, which left headers black or grey on macOS
    /// and in lowercase on recent iOS versions.
    public func applyCPHeaderStyle(
        in tableView: UITableView,
        section: Int,
        color: UIColor = ColorTheme.red.uiColor) {

        let title = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)

        var content = UIListContentConfiguration.groupedHeader()
        content.text = title?.uppercased()
        content.textProperties.font = Font.fontBold(ofSize: 14)
        content.textProperties.color = color
        contentConfiguration = content
    }
}
#endif
