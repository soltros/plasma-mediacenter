import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3

FocusScope {
    id: root

    property string baseUrl: ""
    signal searchLaunched(string query)

    implicitHeight: searchField.implicitHeight

    function normalizedBaseUrl(): string {
        let url = root.baseUrl.trim()
        while (url.endsWith("/")) {
            url = url.slice(0, -1)
        }
        return url
    }

    function launchSearch(category = ""): void {
        const query = searchField.text.trim()
        const base = normalizedBaseUrl()
        if (!query || !base) {
            return
        }

        let url = base + "/search?q=" + encodeURIComponent(query)
        if (category.length > 0) {
            url += "&categories=" + encodeURIComponent(category)
        }

        Qt.openUrlExternally(url)
        root.searchLaunched(query)
    }

    RowLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        PC3.TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: root.baseUrl.trim().length > 0
                ? qsTr("Search the web…")
                : qsTr("Configure a SearXNG instance in widget settings")
            enabled: root.baseUrl.trim().length > 0
            font.pixelSize: Kirigami.Units.gridUnit * 1.1

            Keys.onReturnPressed: root.launchSearch()
            Keys.onEnterPressed: root.launchSearch()
        }

        PC3.Button {
            text: qsTr("Search")
            icon.name: "search"
            enabled: searchField.enabled && searchField.text.trim().length > 0
            onClicked: root.launchSearch()
        }

        PC3.ToolButton {
            icon.name: "folder-pictures"
            text: qsTr("Images")
            display: PC3.AbstractButton.TextBesideIcon
            enabled: searchField.enabled && searchField.text.trim().length > 0
            onClicked: root.launchSearch("images")
        }

        PC3.ToolButton {
            icon.name: "view-media-video"
            text: qsTr("Web Videos")
            display: PC3.AbstractButton.TextBesideIcon
            enabled: searchField.enabled && searchField.text.trim().length > 0
            onClicked: root.launchSearch("videos")
        }
    }
}
