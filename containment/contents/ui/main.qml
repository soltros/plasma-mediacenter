import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

ContainmentItem {
    id: root

    Layout.minimumWidth: Screen.width
    Layout.minimumHeight: Screen.height

    property Item wallpaper

    function pluginNameFor(appletItem) {
        return appletItem?.Plasmoid?.pluginName ?? ""
    }

    function placeApplet(applet) {
        const appletItem = root.itemFor(applet)
        if (!appletItem) {
            return
        }

        const pluginName = pluginNameFor(appletItem)

        if (pluginName === "info.soltros.plasma-mediacenter") {
            appletItem.parent = homeLayer
            appletItem.anchors.fill = homeLayer
            appletItem.visible = true
            appletItem.expanded = true
            return
        }

        if (pluginName === "org.kde.plasma.systemtray") {
            appletItem.parent = trayFrame
            appletItem.anchors.fill = trayFrame
            appletItem.visible = true
            appletItem.expanded = false
            return
        }

        const container = extraAppletContainer.createObject(extraControls, {
            "appletItem": appletItem
        })
        appletItem.parent = container
        appletItem.anchors.fill = container
        appletItem.visible = true
        appletItem.expanded = false
    }

    Containment.onAppletAdded: (applet, x, y) => {
        root.placeApplet(applet)
    }

    Component.onCompleted: {
        for (let i = 0; i < Plasmoid.applets.length; ++i) {
            root.placeApplet(Plasmoid.applets[i])
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.01, 0.015, 0.025, 0.38)
    }

    Item {
        id: homeLayer
        anchors.fill: parent
    }

    Rectangle {
        id: trayBackground

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Kirigami.Units.largeSpacing * 2
        anchors.rightMargin: Kirigami.Units.largeSpacing * 2

        width: Math.max(Kirigami.Units.gridUnit * 18, trayFrame.implicitWidth + Kirigami.Units.largeSpacing * 2)
        height: Kirigami.Units.gridUnit * 3.2
        radius: Kirigami.Units.cornerRadius
        color: Qt.rgba(0.08, 0.09, 0.13, 0.90)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.12)
        visible: trayFrame.children.length > 0

        Item {
            id: trayFrame
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
        }
    }

    RowLayout {
        id: extraControls

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: Kirigami.Units.largeSpacing * 2
        anchors.bottomMargin: Kirigami.Units.largeSpacing * 2

        spacing: Kirigami.Units.smallSpacing
    }

    Component {
        id: extraAppletContainer

        Item {
            required property Item appletItem

            Layout.preferredWidth: Kirigami.Units.gridUnit * 3.2
            Layout.preferredHeight: Kirigami.Units.gridUnit * 3.2
        }
    }
}
