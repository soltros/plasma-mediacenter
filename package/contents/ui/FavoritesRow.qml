import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import org.kde.plasma.private.kicker as Kicker

FocusScope {
    id: root

    property var appletInterface
    property int maximumVisibleItems: 6
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
            (favoritesModel as Kicker.KAStatsFavoritesModel).initForClient("info.soltros.plasma-mediacenter.favorites")
        }
    }

    readonly property var favoritesModel: rootModel.favoritesModel

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true

            PC3.Label {
                text: qsTr("Favorites")
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit * 1.15
            }

            Item { Layout.fillWidth: true }

            PC3.Label {
                visible: root.favoritesModel.count === 0
                text: qsTr("Pin apps in Plasma and they will appear here")
                opacity: 0.62
            }
        }

        ListView {
            id: favoritesView
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 7.5
            orientation: ListView.Horizontal
            spacing: Kirigami.Units.largeSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationWraps: false
            model: root.favoritesModel

            delegate: MediaTile {
                required property int index
                required property var model

                width: Math.max(
                    Kirigami.Units.gridUnit * 11,
                    (favoritesView.width - favoritesView.spacing * (root.maximumVisibleItems - 1))
                        / root.maximumVisibleItems
                )
                height: favoritesView.height

                title: model.display ?? qsTr("Application")
                subtitle: model.description ?? ""
                iconName: model.decoration ?? "application-x-executable"

                KeyNavigation.left: index > 0 ? favoritesView.itemAtIndex(index - 1) : null
                KeyNavigation.right: index < favoritesView.count - 1 ? favoritesView.itemAtIndex(index + 1) : null

                onActivated: {
                    root.favoritesModel.trigger(index, "", null)
                    root.appLaunched()
                }
            }
        }
    }
}
