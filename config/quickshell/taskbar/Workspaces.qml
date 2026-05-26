import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    id: workspaces
    spacing: 3
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    // Data source replaced with a file-poll; structure remains identical
    property var currentWorkspaces: []
    property string niriPath: "/etc/profiles/per-user/peebs/bin/niri"

    Timer {
        interval: 300
        running: true
        repeat: true
        onTriggered: {
            let p = Quickshell.execDetached(niriPath + " msg -j workspaces");
            // NOTE: Since your binary only has execDetached, we use a 
            // shell redirection in your config.kdl: 
            // "niri msg -j workspaces > /tmp/niri.json"
            // Then read it here:
            let file = new File("/tmp/niri.json");
            let data = JSON.parse(file.read());
            currentWorkspaces = data.filter(w => w.output === taskbar.screen.name);
        }
    }

    Repeater { 
        model: currentWorkspaces
        Button {
            id: control
            anchors.centerIn: parent.centerIn
            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: modelData.idx
                font.family: fontMonaco.name
                width: 10
                height: 10
                font.pixelSize: Config.settings.bar.fontSize
                color: Config.colors.text
            }
            onPressed: {
                Quickshell.execDetached(niriPath + " msg action focus-workspace " + modelData.idx);
            }
            NewBorder {
                commonBorderWidth: 2
                commonBorder: false
                lBorderwidth: -2
                rBorderwidth: 0
                tBorderwidth: -4
                bBorderwidth: -1
                borderColor: Config.colors.outline
                zValue: -1
            }

            // Kept your original color logic
            background: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                border.width: 1
                border.color: Config.colors.outline
                width: 22
                height: 22
                color: modelData.is_focused ? Config.colors.shadow : Config.colors.base
            }
        }
    }
}
