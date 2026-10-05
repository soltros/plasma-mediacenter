import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

QtObject {
    id: root

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
