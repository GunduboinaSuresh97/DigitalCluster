import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: root
    property string fuelValue: ""

    width: 300
    height: 150
    color: "red"
    radius: 15

    Text {
        anchors.centerIn: parent

        text: "⚠ LOW FUEL WARNING!\nFuel: " + root.fuelValue
        color: "white"
        font.pixelSize: 25
        font.bold: true
    }
}