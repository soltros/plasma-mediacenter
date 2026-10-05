import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

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
            anchors.leftMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
            anchors.rightMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
            anchors.topMargin: Math.max(Kirigami.Units.gridUnit * 2, height * 0.045)
            anchors.bottomMargin: Math.max(Kirigami.Units.gridUnit * 1.75, height * 0.04)
            spacing: Kirigami.Units.largeSpacing * 2

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: Kirigami.Units.smallSpacing

                    PC3.Label {
                        text: qsTr("MEDIA CENTER")
                        font.pixelSize: Kirigami.Units.gridUnit * 0.9
                        font.letterSpacing: 3
                        font.bold: true
                        color: Kirigami.Theme.highlightColor
                    }

                    PC3.Label {
                        text: qsTr("Home")
                        font.pixelSize: Kirigami.Units.gridUnit * 2.25
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                PC3.Label {
                    id: clock
                    text: Qt.formatTime(new Date(), "h:mm AP")
                    font.pixelSize: Kirigami.Units.gridUnit * 1.45
                    font.bold: true

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: clock.text = Qt.formatTime(new Date(), "h:mm AP")
                    }
                }
            }

            PC3.Label {
                text: qsTr("Browse")
                font.pixelSize: Kirigami.Units.gridUnit * 1.15
                font.bold: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.largeSpacing

                Repeater {
                    id: primaryRepeater

                    model: [
                        { title: qsTr("Live TV"), subtitle: qsTr("Channels & guide"), iconName: "video-television", fallbackGlyph: "▣" },
                        { title: qsTr("Movies"), subtitle: qsTr("Your library"), iconName: "video-x-generic", fallbackGlyph: "▶" },
                        { title: qsTr("Shows"), subtitle: qsTr("Series & episodes"), iconName: "folder-videos", fallbackGlyph: "▤" },
                        { title: qsTr("Music"), subtitle: qsTr("Albums & playlists"), iconName: "audio-x-generic", fallbackGlyph: "♫" },
                        { title: qsTr("Games"), subtitle: qsTr("Launch & play"), iconName: "applications-games", fallbackGlyph: "◆" }
                    ]

                    delegate: MediaTile {
                        required property var modelData
                        required property int index

                        Layout.fillWidth: true
                        title: modelData.title
                        subtitle: modelData.subtitle
                        iconName: modelData.iconName
                        fallbackGlyph: modelData.fallbackGlyph

                        Component.onCompleted: {
                            if (index === 0) {
                                forceActiveFocus()
                            }
                        }

                        KeyNavigation.left: index > 0 ? primaryRepeater.itemAt(index - 1) : null
                        KeyNavigation.right: index < primaryRepeater.count - 1 ? primaryRepeater.itemAt(index + 1) : null

                        onActivated: {
                            // These are media-center destinations rather than
                            // replacements for Plasma infrastructure. Their
                            // concrete providers are wired in later phases.
                        }
                    }
                }
            }

            FrequentAppsRow {
                id: frequentApps
                Layout.fillWidth: true
                appletInterface: root
            }

            Item { Layout.fillHeight: true }

            NowPlaying {
                Layout.fillWidth: true
            }
        }
    }
}
