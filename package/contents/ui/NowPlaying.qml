import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import org.kde.plasma.private.mpris as Mpris

PC3.Control {
    id: root

    implicitHeight: Kirigami.Units.gridUnit * 5.25

    readonly property var player: mprisModel.currentPlayer
    readonly property bool hasPlayer: player !== null
    readonly property bool isPlaying: hasPlayer && player.playbackStatus === Mpris.PlaybackStatus.Playing

    padding: Kirigami.Units.largeSpacing

    background: Rectangle {
        radius: Kirigami.Units.cornerRadius
        color: Qt.rgba(1, 1, 1, 0.07)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.10)
    }

    contentItem: RowLayout {
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Icon {
            source: root.hasPlayer && root.player.artUrl ? root.player.artUrl : "media-playback-start"
            Layout.preferredWidth: Kirigami.Units.iconSizes.huge
            Layout.preferredHeight: Kirigami.Units.iconSizes.huge
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PC3.Label {
                text: root.hasPlayer
                    ? (root.player.track || root.player.identity || qsTr("Unknown media"))
                    : qsTr("Nothing playing")
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit * 1.05
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            PC3.Label {
                text: {
                    if (!root.hasPlayer) {
                        return qsTr("Start media in any MPRIS-capable application.")
                    }

                    const parts = []
                    if (root.player.artist) {
                        parts.push(root.player.artist)
                    }
                    if (root.player.identity) {
                        parts.push(root.player.identity)
                    }
                    return parts.join("  •  ")
                }
                opacity: 0.72
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        PC3.ToolButton {
            icon.name: "media-skip-backward"
            enabled: root.hasPlayer && root.player.canGoPrevious
            Accessible.name: qsTr("Previous")
            onClicked: root.player?.Previous()
        }

        PC3.ToolButton {
            icon.name: root.isPlaying ? "media-playback-pause" : "media-playback-start"
            enabled: root.hasPlayer && (root.player.canPlay || root.player.canPause)
            Accessible.name: root.isPlaying ? qsTr("Pause") : qsTr("Play")
            onClicked: {
                if (!root.hasPlayer) {
                    return
                }
                if (root.isPlaying) {
                    root.player.Pause()
                } else {
                    root.player.Play()
                }
            }
        }

        PC3.ToolButton {
            icon.name: "media-skip-forward"
            enabled: root.hasPlayer && root.player.canGoNext
            Accessible.name: qsTr("Next")
            onClicked: root.player?.Next()
        }

        PC3.ToolButton {
            icon.name: "go-up-symbolic"
            visible: root.hasPlayer && root.player.canRaise
            Accessible.name: qsTr("Open player")
            onClicked: root.player?.Raise()
        }
    }

    Mpris.Mpris2Model {
        id: mprisModel
    }
}
