import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import org.kde.kirigami 2.5 as Kirigami

import org.kde.ksgrd2 0.1 as KSysGuard
import org.kde.ksysguardqml 1.0 as KSysGuardQML

Dialog {
    id: columnDialog

    property alias model: columnView.model
    property alias sourceModel: sortModel.sourceModel
    property var visibleColumns: []
    property var sortedColumns: []
    property var columnDisplay: {"name": "text"}

    title: i18n("Configure Columns")

    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    leftPadding: Kirigami.Units.devicePixelRatio
    rightPadding: Kirigami.Units.devicePixelRatio
    bottomPadding: Kirigami.Units.smallSpacing
    topPadding: Kirigami.Units.smallSpacing
    bottomInset: -Kirigami.Units.smallSpacing
    topInset: Kirigami.Units.smallSpacing

    Kirigami.Theme.colorSet: Kirigami.Theme.View

    function setColumnDisplay(display) {
        sortModel.sortedColumns = sortedColumns
        columnDisplay = display
        displayModel.columnDisplay = display
        visibleColumns = displayModel.visibleColumnIds
    }

    onAccepted: {
        sortedColumns = sortModel.sortedColumns
        visibleColumns = displayModel.visibleColumnIds
        columnDisplay = displayModel.columnDisplay
    }

    onAboutToShow: {
        sortModel.sortedColumns = sortedColumns
        displayModel.columnDisplay = columnDisplay
    }

    Rectangle {
        anchors.fill: parent
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        color: Kirigami.Theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Kirigami.Separator { Layout.fillWidth: true }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: columnView


                model: KSysGuardQML.ColumnDisplayModel {
                    id: displayModel

                    sourceModel: KSysGuardQML.ColumnSortModel {
                        id: sortModel
                    }
                }

                delegate: Loader {
                    width: columnView.width
                    height: Kirigami.Units.gridUnit * 2
                    property var modelData: model
                    sourceComponent: delegateComponent
                }

                Component {
                    id: delegateComponent
                    Kirigami.AbstractListItem {
                        id: listItem
                        Kirigami.Theme.colorSet: Kirigami.Theme.View
                        width: columnView.width
                        height: Kirigami.Units.gridUnit * 2
                        rightPadding: Kirigami.Units.smallSpacing
                        property int index: modelData ? modelData.row : -1
                        contentItem: RowLayout {
                            Kirigami.ListItemDragHandle {
                                id: handle
                                Layout.fillHeight: true
                                listItem: listItem
                                listView: columnView
                                onMoveRequested: sortModel.move(oldIndex, newIndex)
                            }
                            Label {
                                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                                text: modelData ? modelData.name : ""

                            }
                            Label {
                                id: descriptionLabel
                                Layout.fillWidth: true
                                Layout.leftMargin: Kirigami.Units.largeSpacing
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                textFormat: Text.PlainText
                                text: modelData ? modelData.description.replace("<br>", " ") : ""
                                color: Kirigami.Theme.disabledTextColor
                            }

                            ComboBox {
                                id: showCombo
                                textRole: "text"
                                model: {
                                    var result = [
                                        {text: i18n("Hidden"), value: "hidden"},
                                        {text: i18n("Text Only"), value: "text"},
                                    ]

                                    if (modelData && modelData.unit
                                        && modelData.unit != KSysGuard.Units.UnitInvalid
                                        && modelData.unit != KSysGuard.Units.UnitNone) {
                                        result.push({text: i18n("Line Chart"), value: "line"})
                                    }

                                    return result
                                }

                                currentIndex: {
                                    if (!modelData) {
                                        return -1;
                                    }

                                    for (var i = 0; i < model.length; ++i) {
                                        if (model[i].value == modelData.displayStyle) {
                                            return i;
                                        }
                                    }
                                    return -1;
                                }

                                onActivated: {
                                    displayModel.setDisplay(listItem.index, model[index].value);
                                }
                            }
                        }

                        ToolTip.text: modelData ? modelData.description.replace("<br>", " ") : ""
                        ToolTip.visible: listItem.hovered && descriptionLabel.truncated
                        ToolTip.delay: Kirigami.Units.toolTipDelay
                    }
                }
            }
        }

        Kirigami.Separator { Layout.fillWidth: true; }
    }
}
