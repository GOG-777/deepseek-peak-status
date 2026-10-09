import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    property string statusText: "⚡ Peak"
    property color statusColor: "#ff4d4d"

    function updateStatus() {
        var now = new Date();
        var day = now.getUTCDay(); // 0 = Sun, 1 = Mon ... 5 = Fri, 6 = Sat
        var hours = now.getUTCHours();
        var minutes = now.getUTCMinutes();
        var totalMinutes = (hours * 60) + minutes;

        var isWeekday = (day >= 1 && day <= 5);
        // Window 1: 01:00 - 04:00 UTC (60 to 240 mins)
        // Window 2: 06:00 - 10:00 UTC (360 to 600 mins)
        var inPeak = isWeekday && ((totalMinutes >= 60 && totalMinutes < 240) || (totalMinutes >= 360 && totalMinutes < 600));

        if (inPeak) {
            root.statusText = "⚡ Peak";
            root.statusColor = "#ff4d4d";
        } else {
            root.statusText = "🟢 Off-Peak";
            root.statusColor = "#4cd964";
        }
    }

    Component.onCompleted: updateStatus()

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.updateStatus()
    }

    compactRepresentation: statusComponent
    fullRepresentation: statusComponent

    Component {
        id: statusComponent

        Item {
            implicitWidth: statusLabel.implicitWidth + 16
            implicitHeight: statusLabel.implicitHeight + 8
            Layout.minimumWidth: implicitWidth
            Layout.preferredWidth: implicitWidth
            Layout.fillHeight: true

            Text {
                id: statusLabel
                anchors.centerIn: parent
                text: root.statusText
                color: root.statusColor
                font.bold: true
                font.pixelSize: 13
            }
        }
    }
}
