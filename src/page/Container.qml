/*
 * SPDX-FileCopyrightText: 2020 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
 */

import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import org.kde.kirigami 2.12 as Kirigami

Item {
    id: root
    implicitWidth: control.implicitWidth
    implicitHeight: control.implicitHeight
    property bool raised: false
    property bool single: true
    property bool alwaysShowBackground: false

    property Item activeItem
    readonly property bool active: activeItem == control || activeItem == root

    property int index

    signal select(Item item)
    signal remove()
    signal move(int from, int to)

    property alias hovered: control.hovered
    property alias contentItem: control.contentItem
    property alias background: control.background
    property alias mainControl: control
    property alias leftPadding: control.leftPadding
    property alias rightPadding: control.rightPadding
    property alias topPadding: control.topPadding
    property alias bottomPadding: control.bottomPadding

    readonly property alias toolbar: toolbar
    z: raised ? 99 : 0

    Control {
        id: control

        hoverEnabled: true

        width: root.width
        height: root.height

        leftPadding: Kirigami.Units.largeSpacing
        Behavior on leftPadding { NumberAnimation { duration: Kirigami.Units.shortDuration } }
        rightPadding: Kirigami.Units.largeSpacing
        Behavior on rightPadding { NumberAnimation { duration: Kirigami.Units.shortDuration } }
        bottomPadding: Kirigami.Units.largeSpacing
        Behavior on bottomPadding { NumberAnimation { duration: Kirigami.Units.shortDuration } }
        topPadding: root.active ? toolbar.height + Kirigami.Units.smallSpacing * 2 : Kirigami.Units.largeSpacing * 2
        Behavior on topPadding { NumberAnimation { duration: Kirigami.Units.shortDuration } }

        background: Item {
            PlaceholderRectangle {
                id: backgroundRectangle
                anchors.fill: parent
                highlight: root.hovered
                opacity: root.alwaysShowBackground || root.hovered ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
                onClicked: root.select(control)

                shadow.size: root.raised ? Kirigami.Units.gridUnit : 0
            }

            EditorToolBar {
                id: toolbar

                z: 1

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: Kirigami.Units.smallSpacing
                    leftMargin: Kirigami.Units.largeSpacing
                    rightMargin: Kirigami.Units.largeSpacing
                }

                single: root.single
                moveTarget: root

                enabled: opacity >= 1
                opacity: root.active ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }

                onMoved: root.move(from, to)
                onRemoveClicked: root.remove()
            }
        }
    }
}
