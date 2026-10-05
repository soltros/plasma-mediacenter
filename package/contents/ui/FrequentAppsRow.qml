import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import org.kde.plasma.private.kicker as Kicker

FocusScope {
    id: root

    property var appletInterface
    property int maximumItems: 5
    signal appLaunched()

    implicitHeight: column.implicitHeight

    Kicker.RootModel {
        id: rootModel
        autoPopulate: false
        appletInterface: root.appletInterface
        flat: true
        showAllApps: true
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: false

        Component.onCompleted: {
            favoritesModel.initForClient("info.soltros.plasma-mediacenter.favorites")
        }
    }

    Kicker.RecentUsageModel {
        id: frequentModel
        favoritesModel: rootModel.favoritesModel
        ordering: 1
        shownItems: Kicker.RecentUsageModel.OnlyApps
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true

            PC3.Label {
                text: qsTr("Frequent apps")
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit * 1.15
            }

            Item { Layout.fillWidth: true }

            PC3.Label {
                visible: frequentModel.count === 0
                text: qsTr("Your frequently used Plasma apps will appear here")
                opacity: 0.62
            }
        }

        RowLayout {
            id: appRow
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing

            Repeater {
                id: appsRepeater
                model: Math.min(frequentModel.count, root.maximumItems)

                delegate: MediaTile {
                    required property int index

                    Layout.fillWidth: true
                    title: frequentModel.data(frequentModel.index(index, 0), Qt.DisplayRole) ?? qsTr("Application")
                    iconName: {
                        const item = frequentModel.get ? frequentModel.get(index) : null
                        return item?.decoration ?? "application-x-executable"
                    }
                    subtitle: qsTr("Plasma application")

                    KeyNavigation.left: index > 0 ? appsRepeater.itemAt(index - 1) : null
                    KeyNavigation.right: index < appsRepeater.count - 1 ? appsRepeater.itemAt(index + 1) : null

                    onActivated: {
                        frequentModel.trigger(index, "", null)
                        root.appLaunched()
                    }
                }
            }
        }
    }
}
