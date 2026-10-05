import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import org.kde.plasma.private.kicker as Kicker

FocusScope {
    id: root

    property var appletInterface
    property int maximumVisibleItems: 5
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
        ordering: Kicker.RecentUsageModel.Popular
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
                text: qsTr("Frequently used Plasma apps will appear here")
                opacity: 0.62
            }
        }

        ListView {
            id: appView

            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 7.5

            orientation: ListView.Horizontal
            spacing: Kirigami.Units.largeSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationWraps: false
            model: frequentModel

            delegate: MediaTile {
                required property int index
                required property var model

                width: Math.max(
                    Kirigami.Units.gridUnit * 12,
                    (appView.width - (appView.spacing * (root.maximumVisibleItems - 1)))
                        / root.maximumVisibleItems
                )
                height: appView.height

                title: model.display ?? qsTr("Application")
                subtitle: model.description ?? qsTr("Plasma application")
                iconName: model.decoration ?? "application-x-executable"

                KeyNavigation.left: index > 0 ? appView.itemAtIndex(index - 1) : null
                KeyNavigation.right: index < appView.count - 1 ? appView.itemAtIndex(index + 1) : null

                onActivated: {
                    if (frequentModel.trigger(index, "", null)) {
                        root.appLaunched()
                    }
                }
            }
        }
    }
}
