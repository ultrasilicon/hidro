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
            Layout.fillHeight: true
            Layout.margins: 10

            width: 200
            color: "#ffffff"
            radius: 10
        }

        Plugin {
            id: mapPlugin
            name: "osm" // "mapboxgl", "esri", ...
            // specify plugin parameters if necessary
            // PluginParameter {
            //     name:
            //     value:
            // }
        }
        //        Map {

        //            Layout.fillHeight: true
        //            Layout.fillWidth: true
        //            Layout.margins: 10
        //            plugin: mapPlugin
        //            center: QtPositioning.coordinate(59.91, 10.75) // Oslo
        //            zoomLevel: 14

        //            id: canvas


        //            property bool rounded: true
        //            property bool adapt: true
        //            layer.enabled: rounded
        //            layer.effect: OpacityMask {
        //                    maskSource: Item {
        //                        width: canvas.width
        //                        height: canvas.height
        //                        Rectangle {
        //                            anchors.centerIn: parent
        //                            width: canvas.adapt ? canvas.width : Math.min(canvas.width, canvas.height)
        //                            height: canvas.adapt ? canvas.height : canvasr
        //                            radius: 10
        //                        }
        //                    }
        //                }

        //            MapCircle {
        //                id: butterfly
        //                    center {
        //                        latitude: 59.91
        //                        longitude: 10.75
        //                    }
        //                    radius: 5000.0
        //                    color: 'green'
        //                    border.width: 3
        //                }

        //            DropShadow {
        //                    anchors.fill: butterfly
        //                    horizontalOffset: 3
        //                    verticalOffset: 3
        //                    radius: 8.0
        //                    samples: 17
        //                    color: "#80000000"
        //                    source: butterfly
        //                }
        //        }



        Canvas {
            id: canvas

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 15

            property bool rounded: true
            property bool adapt: true
            layer.enabled: rounded
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: canvas.width
                    height: canvas.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: canvas.adapt ? canvas.width : Math.min(canvas.width, canvas.height)
                        height: canvas.adapt ? canvas.height : canvasr
                        radius: 14
                    }
                }
            }

            // pixel per millimeter
            property double ppm: 5.0
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
                property double factor : 1.5

                anchors.fill: canvas
                propagateComposedEvents: true

                onWheel: {
                    var delta = wheel.angleDelta.y;
                    if(delta > 0){
                        // zoom in
                        let newVal =  canvas.ppm + delta / (100-canvas.ppm)
                        if(newVal > 100)
                            return;
                        canvas.ppm = newVal;
                        canvas.requestPaint();
                    } else {
                        // zoom out
                        let newVal =  canvas.ppm + delta / (100-canvas.ppm);
                        if (newVal < 5)
                            canvas.ppm = 5;
                        else
                            canvas.ppm = newVal;
                        canvas.requestPaint();
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
