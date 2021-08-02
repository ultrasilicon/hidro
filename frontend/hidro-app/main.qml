import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.0


Window {
    id: main_window
    visible: true
    title: qsTr("hidro")
    minimumWidth: 800
    minimumHeight: 480

    RowLayout {
        anchors.fill: parent
        //        spacing: 0

        ControlPanel { id: control_panel }
        ColumnLayout {
            LiveAxisMonitor { id: live_axis_monitor }
            LiveWorkView { id: live_view_panel }

        }



    }


}
