import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

PlasmoidItem {
    id: root

    property string currentPage: "home"

    implicitWidth: Kirigami.Units.gridUnit * 72
    implicitHeight: Kirigami.Units.gridUnit * 42

    switchWidth: Kirigami.Units.gridUnit * 52
    switchHeight: Kirigami.Units.gridUnit * 30

    preferredRepresentation: fullRepresentation

    fullRepresentation: Item {
        id: shell

        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight
        focus: true
        clip: true

        Rectangle {
            anchors.fill: parent
            color: Kirigami.Theme.backgroundColor

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(0.055, 0.075, 0.12, 0.98)
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(0.012, 0.018, 0.03, 0.98)
                    }
                }
            }
        }

        Loader {
            anchors.fill: parent
            sourceComponent: root.currentPage === "videos" ? videosPage : homePage
        }

        Component {
            id: homePage

            FocusScope {
                id: home

                readonly property real horizontalMargin:
                    Math.max(Kirigami.Units.gridUnit * 2.5, width * 0.045)
                readonly property real verticalMargin:
                    Math.max(Kirigami.Units.gridUnit * 1.5, height * 0.035)

                Flickable {
                    id: homeFlickable

                    anchors.fill: parent
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    contentWidth: width
                    contentHeight: homeColumn.implicitHeight + (home.verticalMargin * 2)

                    ColumnLayout {
                        id: homeColumn

                        x: home.horizontalMargin
                        y: home.verticalMargin
                        width: Math.max(0, homeFlickable.width - (home.horizontalMargin * 2))
                        spacing: Kirigami.Units.largeSpacing * 1.5

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.minimumHeight: Kirigami.Units.gridUnit * 4.5

                            ColumnLayout {
                                spacing: 0

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
                            Layout.minimumHeight: Kirigami.Units.gridUnit * 3
                            baseUrl: Plasmoid.configuration.searxngBaseUrl
                        }

                        PC3.Label {
                            text: qsTr("Browse")
                            font.pixelSize: Kirigami.Units.gridUnit * 1.15
                            font.bold: true
                            Layout.topMargin: Kirigami.Units.smallSpacing
                        }

                        RowLayout {
                            id: browseRow
                            Layout.fillWidth: true
                            Layout.minimumHeight: Kirigami.Units.gridUnit * 8
                            spacing: Kirigami.Units.largeSpacing

                            MediaTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                title: qsTr("Videos")
                                subtitle: qsTr("Local video library")
                                iconName: "folder-videos"
                                fallbackGlyph: "▶"
                                onActivated: root.currentPage = "videos"
                            }

                            MediaTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                title: qsTr("Live TV")
                                subtitle: qsTr("Channels & guide")
                                iconName: "video-television"
                                fallbackGlyph: "▣"
                            }

                            MediaTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                title: qsTr("Movies")
                                subtitle: qsTr("Media provider")
                                iconName: "video-x-generic"
                                fallbackGlyph: "◆"
                            }

                            MediaTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                title: qsTr("Shows")
                                subtitle: qsTr("Media provider")
                                iconName: "folder-videos"
                                fallbackGlyph: "▤"
                            }

                            MediaTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                title: qsTr("Music")
                                subtitle: qsTr("Albums & playlists")
                                iconName: "audio-x-generic"
                                fallbackGlyph: "♫"
                            }
                        }

                        FavoritesRow {
                            id: favorites
                            Layout.fillWidth: true
                            Layout.minimumHeight: Kirigami.Units.gridUnit * 9.5
                            appletInterface: root
                        }

                        NowPlaying {
                            Layout.fillWidth: true
                            Layout.minimumHeight: Kirigami.Units.gridUnit * 5.25
                            Layout.topMargin: Kirigami.Units.smallSpacing
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.minimumHeight: Kirigami.Units.gridUnit
                        }
                    }

                    PC3.ScrollBar.vertical: PC3.ScrollBar {
                        policy: homeFlickable.contentHeight > homeFlickable.height
                            ? PC3.ScrollBar.AsNeeded
                            : PC3.ScrollBar.AlwaysOff
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
