import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

FocusScope {
    id: root

    property string folderPath: ""
    signal backRequested()

    function folderUrl(): string {
        if (folderPath.startsWith("file://")) {
            return folderPath
        }
        return "file://" + folderPath
    }

    Keys.onEscapePressed: backRequested()
    Keys.onBackPressed: backRequested()

    FolderListModel {
        id: videos
        folder: root.folderUrl()
        showDirs: false
        showDotAndDotDot: false
        nameFilters: [
            "*.mp4", "*.mkv", "*.webm", "*.avi", "*.mov", "*.m4v",
            "*.mpeg", "*.mpg", "*.ts", "*.mts", "*.m2ts", "*.ogv"
        ]
        sortField: FolderListModel.Time
        sortReversed: true
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

        RowLayout {
            Layout.fillWidth: true

            PC3.Button {
                text: qsTr("Back")
                icon.name: "go-previous"
                onClicked: root.backRequested()
            }

            PC3.Label {
                text: qsTr("Videos")
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit * 1.7
            }

            Item { Layout.fillWidth: true }

            PC3.Label {
                text: root.folderPath
                opacity: 0.65
                elide: Text.ElideMiddle
                Layout.maximumWidth: Kirigami.Units.gridUnit * 28
            }
        }

        PC3.Label {
            visible: videos.count === 0
            text: qsTr("No supported video files found in this folder.")
            opacity: 0.72
        }

        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: videos
            cellWidth: Math.max(Kirigami.Units.gridUnit * 14, width / 4)
            cellHeight: Kirigami.Units.gridUnit * 8
            keyNavigationWraps: false

            delegate: MediaTile {
                required property string fileName
                required property url fileUrl
                width: grid.cellWidth - Kirigami.Units.largeSpacing
                height: grid.cellHeight - Kirigami.Units.largeSpacing
                title: fileName
                subtitle: qsTr("Open in default video player")
                iconName: "video-x-generic"

                onActivated: Qt.openUrlExternally(fileUrl)
            }
        }
    }
}
