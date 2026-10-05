import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

FocusScope {
    id: root

    property string title: ""
    property string subtitle: ""
    property string iconText: ""
    property bool selected: activeFocus
    signal activated()

    implicitWidth: 250
    implicitHeight: 150

    Rectangle {
        anchors.fill: parent
        radius: 22
        color: root.selected ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(1, 1, 1, 0.08)
        border.width: root.selected ? 3 : 1
        border.color: root.selected ? Kirigami.Theme.highlightColor : Qt.rgba(1, 1, 1, 0.12)
        scale: root.selected ? 1.045 : 1.0

        Behavior on scale {
            NumberAnimation { duration: 120 }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 8

            Text {
                text: root.iconText
                font.pixelSize: 42
                color: Kirigami.Theme.textColor
            }

            Item { Layout.fillHeight: true }

            Text {
                text: root.title
                font.pixelSize: 24
                font.bold: true
                color: Kirigami.Theme.textColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                visible: root.subtitle.length > 0
                text: root.subtitle
                font.pixelSize: 15
                color: Kirigami.Theme.disabledTextColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.forceActiveFocus()
            onClicked: root.activated()
        }
    }

    Keys.onReturnPressed: activated()
    Keys.onEnterPressed: activated()
    Keys.onSpacePressed: activated()
}
