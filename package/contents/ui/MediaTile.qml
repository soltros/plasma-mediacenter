import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

FocusScope {
    id: root

    property string title: ""
    property string subtitle: ""
    property string iconName: ""
    property string fallbackGlyph: ""
    signal activated()

    implicitWidth: Kirigami.Units.gridUnit * 10
    implicitHeight: Kirigami.Units.gridUnit * 4.75

    PC3.Button {
        id: button
        anchors.fill: parent
        focus: true
        hoverEnabled: true

        onClicked: root.activated()
        onActiveFocusChanged: {
            if (activeFocus) {
                root.forceActiveFocus()
            }
        }

        contentItem: RowLayout {
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                visible: root.iconName.length > 0
                source: root.iconName
                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                Layout.preferredHeight: Kirigami.Units.iconSizes.large
            }

            PC3.Label {
                visible: root.iconName.length === 0 && root.fallbackGlyph.length > 0
                text: root.fallbackGlyph
                font.pixelSize: Kirigami.Units.gridUnit * 1.5
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                PC3.Label {
                    text: root.title
                    font.bold: true
                    font.pixelSize: Kirigami.Units.gridUnit * 0.95
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                PC3.Label {
                    visible: root.subtitle.length > 0
                    text: root.subtitle
                    opacity: 0.72
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        Keys.onReturnPressed: root.activated()
        Keys.onEnterPressed: root.activated()
        Keys.onSpacePressed: root.activated()
    }
}
