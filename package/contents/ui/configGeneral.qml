import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    property alias cfg_searxngBaseUrl: searxngField.text
    property alias cfg_videoFolder: videoFolderField.text

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        QQC2.TextField {
            id: searxngField
            Kirigami.FormData.label: qsTr("SearXNG URL:")
            placeholderText: "https://search.example.com"
            text: Plasmoid.configuration.searxngBaseUrl
        }

        RowLayout {
            Kirigami.FormData.label: qsTr("Videos folder:")
            Layout.fillWidth: true

            QQC2.TextField {
                id: videoFolderField
                Layout.fillWidth: true
                text: Plasmoid.configuration.videoFolder
                placeholderText: qsTr("/home/user/Videos")
            }

            QQC2.Button {
                text: qsTr("Choose…")
                icon.name: "document-open-folder"
                onClicked: folderDialog.open()
            }
        }

        QQC2.Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            opacity: 0.7
            text: qsTr("Searches and video files open with the system default URL/file handlers.")
        }
    }

    FolderDialog {
        id: folderDialog
        title: qsTr("Choose videos folder")
        onAccepted: {
            let value = selectedFolder.toString()
            if (value.startsWith("file://")) {
                value = decodeURIComponent(value.substring("file://".length))
            }
            videoFolderField.text = value
        }
    }
}
