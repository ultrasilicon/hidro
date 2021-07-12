import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.15
import QtLocation 5.6
import QtPositioning 5.6

Window {
    visible: true
    title: qsTr("hidro")
    minimumWidth: 800
    minimumHeight: 480
    //    width: 800
    //    height: 480

    RowLayout {
        anchors.fill: parent
        //        spacing: 0

        Rectangle {
            id: control_panel
            Layout.fillHeight: true
            Layout.margins: 10

            width: 200
            color: "#ffffff"
            radius: 10

            ColumnLayout{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Text {
                    id: x_axis_display
                    property double val: 0.000
                    text: "x       " + val.toLocaleString(Qt.locale(), 'f', 3)
                    color: "#cccccc"
                    font.pixelSize: 40
                    Layout.leftMargin: 10
                }
                Text {
                    id: y_axis_display
                    property double val: 0.000
                    text: "y       " + val.toLocaleString(Qt.locale(), 'f', 3)
                    color: "#cccccc"
                    font.pixelSize: 40
                    Layout.leftMargin: 10
                }
                Text {
                    id: z_axis_display
                    property double val: 0.000
                    text: "z       " + val.toLocaleString(Qt.locale(), 'f', 3)
                    color: "#cccccc"
                    font.pixelSize: 40
                    Layout.leftMargin: 10
                }

            }


        }



        Canvas {
            id: live_view_panel

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 15

            property bool rounded: true
            property bool adapt: true
            layer.enabled: rounded
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: live_view_panel.width
                    height: live_view_panel.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: live_view_panel.adapt ? live_view_panel.width : Math.min(live_view_panel.width, live_view_panel.height)
                        height: live_view_panel.adapt ? live_view_panel.height : canvasr
                        radius: 14
                    }
                }
            }

            // pixel per millimeter
            property double ppm: 5.0
            property double ppm_max: 70.0
            property double ppm_min: 3.0
            property double grid_width: 1.0 * ppm

            onPaint: {
                var ctx = getContext("2d");
                var halfHeight = height * 0.5;
                var halfWidth = width * 0.5;



                // background
                ctx.fillStyle = "#F9EDF0";
                ctx.fillRect(0, 0, width, height);



                // grid
                ctx.save();
                ctx.translate(halfWidth, halfHeight);
                ctx.lineWidth = 1
                ctx.strokeStyle = "#ccffffff"
                // ctx.beginPath();
                let halfRows = height / grid_width * 0.5 | 0;
                for(var i = -halfRows; i <= halfRows; ++ i) {
                    let yPos = grid_width * i;
                    ctx.moveTo(-halfWidth, yPos);
                    ctx.lineTo(width, yPos);
                }
                let halfCols = width / grid_width * 0.5 | 0;
                for(var j = -halfCols; j <= halfCols; ++ j) {
                    let xPos = grid_width * j;
                    ctx.moveTo(xPos, -halfHeight);
                    ctx.lineTo(xPos, height);
                }
                // commenting this line gives huge performance boost
                // ctx.closePath();
                ctx.stroke();
                ctx.restore();



                // shape test
                ctx.save();
                ctx.translate(halfWidth, halfHeight);
                // Shadow
                ctx.shadowColor = '#C21550';
//                ctx.shadowBlur = 10;
                ctx.shadowSpread = 110;
                // Rectangle
                ctx.fillStyle = '#C21550';
                ctx.fillRect(6*ppm, 6*ppm, 15*ppm, 10*ppm);
                ctx.restore();



                // bit
                ctx.fillStyle = "#aa353535";
                ctx.beginPath();
                ctx.arc(halfWidth, halfHeight, 2*ppm, 0, 2 * Math.PI);
                ctx.fill();



                // crosshair
                ctx.beginPath();
                ctx.strokeStyle = "#FF7EA4"
                ctx.moveTo(0, halfHeight);
                ctx.lineTo(width, halfHeight);
                ctx.moveTo(halfWidth, 0);
                ctx.lineTo(halfWidth, height);
                ctx.stroke();



            }


            MouseArea {
                anchors.fill: live_view_panel
                propagateComposedEvents: true

                onWheel: {
                    var delta = wheel.angleDelta.y;
                    if(delta > 0){
                        // zoom in
                        let newVal =  live_view_panel.ppm + delta / (100-live_view_panel.ppm)
                        if(newVal > live_view_panel.ppm_max)
                            return;
                        live_view_panel.ppm = newVal;
                        live_view_panel.requestPaint();
                    } else {
                        // zoom out
                        let newVal =  live_view_panel.ppm + delta / (100-live_view_panel.ppm);
                        if (newVal < live_view_panel.ppm_min)
                            live_view_panel.ppm = ppm_min;
                        else
                            live_view_panel.ppm = newVal;
                        live_view_panel.requestPaint();
                    }
                }
                onPressed:{
                    mouse.accepted = false
                }
                onPositionChanged:{mouse.accepted = false}
                onReleased:{mouse.accepted = false}

            }



        }


    }


}
