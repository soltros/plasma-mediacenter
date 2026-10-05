import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import org.kde.plasma.plasmoid
import org.kde.taskmanager as TaskManager

FocusScope {
    id: root

    property var appletInterface
    property int maximumVisibleItems: 6

    implicitHeight: column.implicitHeight

    TaskManager.ActivityInfo {
        id: activityInfo
    }

    TaskManager.TasksModel {
        id: tasksModel

        activity: activityInfo.currentActivity
        groupMode: TaskManager.TasksModel.GroupDisabled
        sortMode: TaskManager.TasksModel.SortLastActivated

        filterByCurrentVirtualDesktop: false
        filterByScreen: false
        filterByActivity: true
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true

            PC3.Label {
                text: qsTr("Running")
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit * 1.15
            }

            Item { Layout.fillWidth: true }

            PC3.Label {
                visible: tasksModel.count === 0
                text: qsTr("No open windows")
                opacity: 0.62
            }
        }

        ListView {
            id: taskView

            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 4.75

            orientation: ListView.Horizontal
            spacing: Kirigami.Units.largeSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationWraps: false
            model: tasksModel

            delegate: MediaTile {
                required property int index
                required property var model

                width: Math.max(
                    Kirigami.Units.gridUnit * 8.5,
                    (taskView.width - taskView.spacing * (root.maximumVisibleItems - 1))
                        / root.maximumVisibleItems
                )
                height: taskView.height

                title: model.AppName || model.display || qsTr("Window")
                subtitle: model.display && model.display !== title
                    ? model.display
                    : qsTr("Open window")
                iconName: model.decoration || "preferences-system-windows"

                KeyNavigation.left: index > 0 ? taskView.itemAtIndex(index - 1) : null
                KeyNavigation.right: index < taskView.count - 1 ? taskView.itemAtIndex(index + 1) : null

                onActivated: {
                    tasksModel.requestActivate(tasksModel.makeModelIndex(index))
                }
            }
        }
    }
}
