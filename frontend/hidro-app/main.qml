import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.0


Window {
    visible: true
    title: qsTr("hidro")
    minimumWidth: 800
    minimumHeight: 480

    RowLayout {
        anchors.fill: parent
        //        spacing: 0

        ControlPanel { id: control_panel }
        LiveViewPanel { id: live_view_panel }


    }


}
