import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    fullRepresentation: Item {
        id: home
        focus: true

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.05, 0.08, 0.14, 1.0) }
                GradientStop { position: 1.0; color: Qt.rgba(0.015, 0.02, 0.035, 1.0) }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: Math.max(48, width * 0.045)
            anchors.rightMargin: Math.max(48, width * 0.045)
            anchors.topMargin: Math.max(36, height * 0.045)
            anchors.bottomMargin: Math.max(32, height * 0.04)
            spacing: 28

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "MEDIA CENTER"
                        font.pixelSize: 16
                        font.letterSpacing: 3
                        font.bold: true
                        color: Kirigami.Theme.highlightColor
                    }

                    Text {
                        text: "Home"
                        font.pixelSize: 44
                        font.bold: true
                        color: "white"
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    id: clock
                    text: Qt.formatTime(new Date(), "h:mm AP")
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: clock.text = Qt.formatTime(new Date(), "h:mm AP")
                    }
                }
            }

            Text {
                text: "Browse"
                font.pixelSize: 22
                font.bold: true
                color: "white"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 18

                Repeater {
                    id: primaryRepeater
                    model: [
                        { title: "Live TV", subtitle: "Channels & guide", iconName: "video-television", fallbackGlyph: "▣" },
                        { title: "Movies", subtitle: "Your library", iconName: "video-x-generic", fallbackGlyph: "▶" },
                        { title: "Shows", subtitle: "Series & episodes", iconName: "folder-videos", fallbackGlyph: "▤" },
                        { title: "Music", subtitle: "Albums & playlists", iconName: "audio-x-generic", fallbackGlyph: "♫" },
                        { title: "Games", subtitle: "Launch & play", iconName: "applications-games", fallbackGlyph: "◆" }
                    ]

                    delegate: MediaTile {
                        required property var modelData
                        required property int index

                        Layout.fillWidth: true
                        title: modelData.title
                        subtitle: modelData.subtitle
                        iconName: modelData.iconName\n                        fallbackGlyph: modelData.fallbackGlyph

                        Component.onCompleted: {
                            if (index === 0) {
                                forceActiveFocus()
                            }
                        }

                        KeyNavigation.left: index > 0 ? primaryRepeater.itemAt(index - 1) : null
                        KeyNavigation.right: index < primaryRepeater.count - 1 ? primaryRepeater.itemAt(index + 1) : null
                        KeyNavigation.down: quickRepeater.count > 0 ? quickRepeater.itemAt(Math.min(index, quickRepeater.count - 1)) : null

                        onActivated: statusText.text = title + " provider wiring comes next."
                    }
                }
            }

            Text {
                text: "Quick launch"
                font.pixelSize: 22
                font.bold: true
                color: "white"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 18

                Repeater {
                    id: quickRepeater
                    model: [
                        { title: "Jellyfin", subtitle: "Media server", iconName: "", fallbackGlyph: "J" },
                        { title: "Supraviolet", subtitle: "IPTV", iconName: "", fallbackGlyph: "S" },
                        { title: "Steam", subtitle: "Big Picture", iconName: "steam", fallbackGlyph: "◉" },
                        { title: "Desktop", subtitle: "Return to Plasma", iconName: "user-desktop", fallbackGlyph: "⌂" }
                    ]

                    delegate: MediaTile {
                        required property var modelData
                        required property int index

                        Layout.fillWidth: true
                        implicitHeight: 128
                        title: modelData.title
                        subtitle: modelData.subtitle
                        iconText: modelData.icon

                        KeyNavigation.left: index > 0 ? quickRepeater.itemAt(index - 1) : null
                        KeyNavigation.right: index < quickRepeater.count - 1 ? quickRepeater.itemAt(index + 1) : null
                        KeyNavigation.up: primaryRepeater.count > 0 ? primaryRepeater.itemAt(Math.min(index, primaryRepeater.count - 1)) : null

                        onActivated: statusText.text = title + " launcher wiring comes next."
                    }
                }
            }

            Item { Layout.fillHeight: true }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 86
                radius: 20
                color: Qt.rgba(1, 1, 1, 0.07)

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 16

                    Rectangle {
                        Layout.preferredWidth: 52
                        Layout.preferredHeight: 52
                        radius: 12
                        color: Qt.rgba(1, 1, 1, 0.12)

                        Text {
                            anchors.centerIn: parent
                            text: "♪"
                            font.pixelSize: 26
                            color: "white"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: "Nothing playing"
                            font.pixelSize: 19
                            font.bold: true
                            color: "white"
                        }

                        Text {
                            id: statusText
                            text: "MPRIS integration is planned for the next prototype pass."
                            font.pixelSize: 14
                            color: Kirigami.Theme.disabledTextColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    Text {
                        text: "◀   ▶   ▶▶"
                        font.pixelSize: 22
                        color: Kirigami.Theme.disabledTextColor
                    }
                }
            }
        }
    }
}
