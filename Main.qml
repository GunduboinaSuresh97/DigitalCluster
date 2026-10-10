import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window

    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true

    title: qsTr("DigitalCluster")

    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"


    // =========================================================
    // Popup
    // =========================================================

    Popup {
        id: fuelPopup

        width: 350
        height: 200

        anchors.centerIn: parent

        background: Rectangle {
            color: "red"
            radius: 20
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "⚠ LOW FUEL WARNING!"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }

            Text {
                text: "Fuel: " + vehicleData.fuel + "%"
                color: "white"
                font.pixelSize: 20
            }

            Button {
                text: "OK"

                onClicked: {
                    fuelPopup.close()
                }
            }
        }
    }

    Timer {
        id: myTimer

        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            console.log("Timer triggered")
        }
    }


    // =========================================================
    // 1. TEST RECTANGLE
    // =========================================================

    Rectangle {
        id: testRectangle

        width: 200
        height: 100

        color: "green"

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 50
        anchors.rightMargin: 50

        z: 10

        Text {
            anchors.centerIn: parent

            text: testRectangle.state === "WARNING"
                  ? "WARNING"
                  : "NORMAL"

            font.pixelSize: 25
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                testRectangle.state = "WARNING"
            }
        }

        states: [
            State {
                name: "WARNING"

                PropertyChanges {
                    target: testRectangle

                    color: "red"
                    width: 400
                    height: 200
                }
            }
        ]

        transitions: [
            Transition {

                NumberAnimation {
                    properties: "width,height"
                    duration: 1000
                }

                ColorAnimation {
                    duration: 1000
                }
            }
        ]
    }


    // =========================================================
    // 2. CONNECTIONS - C++ SIGNAL TO QML
    // =========================================================

    Connections {
        target: vehicleData

        function onFuelLow() {
            console.log("QML: LOW FUEL WARNING!")
            console.log("Current fuel:", vehicleData.fuel)

            fuelPopup.open()
        }
    }

    Connections {
        target: vehicleData

        function onSpeedChangedMessage() {
            console.log("QML: Speed changed!")
            console.log("Current speed:", vehicleData.speed)
        }
    }


    // =========================================================
    // 3. MAIN GRID
    // =========================================================

    GridLayout {
        id: grid

        columns: width < 400 ? 1 : 2

        rowSpacing: 0
        columnSpacing: 0

        anchors.fill: parent


        // =====================================================
        // LEFT SIDE
        // =====================================================

        Rectangle {
            id: rectangle1

            color: window.lightMode
                   ? window.reallyLight
                   : window.reallyDark

            Layout.fillHeight: true
            Layout.fillWidth: true


            ColumnLayout {
                anchors.fill: parent

                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop


                ColumnLayout {
                    anchors.fill: parent

                    spacing: 10


                    // SPEED
                    ClusterValue {
                        imageSource:
                            "qrc:/qt/qml/DigitalCluster/images/speed.png"

                        labelText: "Speed : "

                        valueText: vehicleData.speed
                    }


                    // RPM
                    ClusterValue {
                        imageSource:
                            "qrc:/qt/qml/DigitalCluster/images/rpm.png"

                        labelText: "RPM : "

                        valueText: vehicleData.rpm
                    }


                    // FUEL
                    ClusterValue {
                        imageSource:
                            "qrc:/qt/qml/DigitalCluster/images/fuel.png"

                        labelText: "Fuel : "

                        valueText: vehicleData.fuel + "%"
                    }
                }
            }
        }


        // =====================================================
        // RIGHT SIDE
        // =====================================================

        Rectangle {
            id: rectangle2

            color: window.lightMode
                   ? window.light
                   : window.dark

            Layout.fillHeight: true
            Layout.fillWidth: true


            ColumnLayout {
                anchors.fill: parent

                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop


                // =================================================
                // GET SPEED %
                // =================================================

                Button {
                    text: "Get Speed %"

                    onClicked: {

                        var Percentage =
                                vehicleData.getSpeedPercentage()

                        console.log(
                            "Speed Percentage: ",
                            Percentage
                        )
                    }
                }


                // =================================================
                // SET SPEED TO 100
                // =================================================

                Button {
                    text: "Set Speed to 100"

                    onClicked: {

                        vehicleData.changeSpeed(100)

                        console.log(
                            "Set Speed to 100"
                        )
                    }
                }


                // =================================================
                // INCREASE SPEED
                // =================================================

                Button {
                    text: "IncreaseSpeed"

                    onClicked: {

                        vehicleData.increaseSpeed()

                        console.log(
                            "IncreaseSpeed Button Clicked"
                        )
                    }
                }


                // =================================================
                // DARK / LIGHT MODE
                // =================================================

                Button {
                    id: button1

                    text: window.lightMode
                          ? qsTr("\u263D  Dark mode")
                          : qsTr("\u263C  Light mode")

                    Layout.bottomMargin: 16

                    Layout.alignment:
                        Qt.AlignHCenter | Qt.AlignBottom


                    contentItem: Text {

                        text: button1.text

                        color: window.lightMode
                               ? window.light
                               : window.dark

                        font: button1.font

                        horizontalAlignment:
                            Text.AlignHCenter

                        verticalAlignment:
                            Text.AlignVCenter
                    }


                    background: Rectangle {

                        implicitWidth: 120
                        implicitHeight: 36

                        radius: 8

                        color: window.lightMode
                               ? window.dark
                               : window.light
                    }


                    onClicked: {

                        window.lightMode =
                                !window.lightMode

                        console.log(
                            "Button Clicked"
                        )
                    }
                }
            }
        }
    }


    // =========================================================
    // 4. WARNING SCREEN LOADER
    // =========================================================

    Loader {
        id: warningLoader

        anchors.centerIn: parent

        active: false

        source: "WarningScreen.qml"
        onLoaded: {
            item.fuelValue = vehicleData.fuel
        }
    }

    property var vehicleItems: [
        {
            name: "Speed",
            value: vehicleData.speed
        },
        {
            name: "RPM",
            value: vehicleData.rpm
        },
        {
            name: "Fuel",
            value: vehicleData.fuel
        }
    ]

    ListView {
        width: 300
        height: 200

        anchors.centerIn: parent

        model: vehicleItems

        delegate: Text {
            text: modelData.name + " : " + modelData.value
            font.pixelSize: 30
        }
    }

}