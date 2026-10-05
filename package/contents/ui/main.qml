import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

PlasmoidItem {
    id: root

    property string currentPage: "home"

    fullRepresentation: Item {
        id: shell
        focus: true

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.05, 0.08, 0.14, 1.0) }
                GradientStop { position: 1.0; color: Qt.rgba(0.015, 0.02, 0.035, 1.0) }
            }
        }

        Loader {
            anchors.fill: parent
            sourceComponent: root.currentPage === "videos" ? videosPage : homePage
        }

        Component {
            id: homePage

            FocusScope {
                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
                    anchors.rightMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
                    anchors.topMargin: Math.max(Kirigami.Units.gridUnit * 2, height * 0.045)
                    anchors.bottomMargin: Math.max(Kirigami.Units.gridUnit * 1.75, height * 0.04)
                    spacing: Kirigami.Units.largeSpacing * 1.5

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

                    SearchBar {
                        id: searchBar
                        Layout.fillWidth: true
                        baseUrl: Plasmoid.configuration.searxngBaseUrl
                    }

                    PC3.Label {
                        text: qsTr("Browse")
                        font.pixelSize: Kirigami.Units.gridUnit * 1.15
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.largeSpacing

                        MediaTile {
                            Layout.fillWidth: true
                            title: qsTr("Videos")
                            subtitle: qsTr("Local video library")
                            iconName: "folder-videos"
                            fallbackGlyph: "▶"
                            onActivated: root.currentPage = "videos"
                        }

                        MediaTile {
                            Layout.fillWidth: true
                            title: qsTr("Live TV")
                            subtitle: qsTr("Channels & guide")
                            iconName: "video-television"
                            fallbackGlyph: "▣"
                        }

                        MediaTile {
                            Layout.fillWidth: true
                            title: qsTr("Movies")
                            subtitle: qsTr("Media provider")
                            iconName: "video-x-generic"
                            fallbackGlyph: "◆"
                        }

                        MediaTile {
                            Layout.fillWidth: true
                            title: qsTr("Shows")
                            subtitle: qsTr("Media provider")
                            iconName: "folder-videos"
                            fallbackGlyph: "▤"
                        }

                        MediaTile {
                            Layout.fillWidth: true
                            title: qsTr("Music")
                            subtitle: qsTr("Albums & playlists")
                            iconName: "audio-x-generic"
                            fallbackGlyph: "♫"
                        }
                    }

                    FavoritesRow {
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

        Component {
            id: videosPage

            VideoBrowser {
                anchors.fill: parent
                anchors.leftMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
                anchors.rightMargin: Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
                anchors.topMargin: Math.max(Kirigami.Units.gridUnit * 2, height * 0.045)
                anchors.bottomMargin: Math.max(Kirigami.Units.gridUnit * 1.75, height * 0.04)

                folderPath: Plasmoid.configuration.videoFolder
                onBackRequested: root.currentPage = "home"
            }
        }
    }
}
