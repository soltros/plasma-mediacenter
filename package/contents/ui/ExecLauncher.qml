import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: root

    visible: false
    width: 0
    height: 0

    function launch(command) {
        if (!command || command.length === 0) {
            return
        }
        executable.connectSource(command)
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"

        onNewData: (sourceName, data) => {
            disconnectSource(sourceName)
        }
    }
}
