import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.15


Canvas {
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
    property double ppm_min: 1.0
    property double grid_width: 1.0 * ppm
    property double grid_enabled: grid_width >= 6.0
    property bool smooth_render: true

    onPaint: {
        if(smooth_render) {
            antialiasing = true
            smooth = true
        } else {
            antialiasing = false
            smooth = false
        }

        var ctx = getContext("2d");
        var halfHeight = height * 0.5;
        var halfWidth = width * 0.5;




        // background
        ctx.fillStyle = "#F9EDF0";
        ctx.fillRect(0, 0, width, height);

        // grid
        if(smooth_render && grid_enabled) {
            ctx.save();
            ctx.translate(halfWidth, halfHeight);
            ctx.lineWidth = 1
            ctx.strokeStyle = "#FCF7F8"
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
        }



        // shape test
        ctx.save();
        ctx.translate(halfWidth, halfHeight);
        // Shadow
        ctx.shadowColor = '#C21550';
        ctx.shadowBlur = grid_enabled ? 0 : 10/ppm**0.5;
        ctx.shadowSpread = 50;
        // Rectangle
        ctx.fillStyle = '#C21550';
        ctx.fillRect(-5*ppm, -5*ppm, 170*ppm, 70*ppm);
        ctx.restore();



        // bit
        ctx.fillStyle = "#aaFF7EA4";
        ctx.beginPath();
        ctx.arc(halfWidth, halfHeight, 2*ppm, 0, 2 * Math.PI);
        ctx.fill();



        // crosshair
        ctx.beginPath();
        ctx.strokeStyle = "#FF7EA4";
        ctx.lineWidth = 1;
        ctx.moveTo(0, halfHeight);
        ctx.lineTo(width, halfHeight);
        ctx.moveTo(halfWidth, 0);
        ctx.lineTo(halfWidth, height);
        ctx.stroke();

        ctx.fillStyle = "#FF7EA4";
        ctx.font = "14px Arial";
        ctx.fillText("110.348", halfWidth + 8, height - 8);
        ctx.fillText("35.679", 8, halfHeight - 8);



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
                    live_view_panel.ppm = live_view_panel.ppm_max;
                else
                    live_view_panel.ppm = newVal;
                live_view_panel.requestPaint();
            } else {
                // zoom out
                let newVal =  live_view_panel.ppm + delta / (100-live_view_panel.ppm);
                if (newVal < live_view_panel.ppm_min)
                    live_view_panel.ppm = live_view_panel.ppm_min;
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

    function zoom() {

    }



}
