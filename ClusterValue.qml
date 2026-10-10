import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

RowLayout {
    id: root

    property string imageSource: ""
    property string labelText: ""
    property string valueText: ""

    spacing: 15

    Image {
        source: root.imageSource

        Layout.preferredWidth: 80
        Layout.preferredHeight: 80
        Layout.minimumWidth: 50
        Layout.minimumHeight: 50
        Layout.maximumWidth: 120
        Layout.maximumHeight: 120

        fillMode: Image.PreserveAspectFit
    }

    Label {
        text: root.labelText + root.valueText

        font.pixelSize: 40
        Layout.fillWidth: true
    }
}