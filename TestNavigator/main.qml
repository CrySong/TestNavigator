import QtQuick 2.9
import QtLocation 5.6
import QtPositioning 5.6
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

ApplicationWindow 
{
    id: mainWindow
    width: Qt.platform.os == "android" ? Screen.width : 1024
    height: Qt.platform.os == "android" ? Screen.height : 768
    visible: true

    property variant address
    property var startPointTF: dataColumn.startPointTF
    property var endPointTF: dataColumn.endPointTF

    function onbuttonClick(choosingStartPoint)
    {
        if (choosingStartPoint)
        {
            map.choosingStartPoint = true;
        }
        else
        {
            map.choosingEndPoint = true;
        }
    }

    function changeCoordinate(textField, mouseGeoPos) 
    {
        textField.text = qsTr("%1 %2").arg(mouseGeoPos.latitude).arg(mouseGeoPos.longitude);
    }

    Plugin 
    {
        id: mapPlugin
        name: "osm"
    }

    Map
    {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(56.4881, 84.9475)
        zoomLevel: 15

        property var startPoint
        property var endPoint

        property bool choosingStartPoint : false
        property bool choosingEndPoint : false

        MouseArea 
        {
            id: mouseArea
            property variant lastCoordinate
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed : 
            {
                var mouseGeoPos = map.toCoordinate(Qt.point(mouse.x, mouse.y));

                if (map.choosingStartPoint)
                {
                    map.startPoint = mouseGeoPos;
                    map.choosingStartPoint = false;
                    changeCoordinate(mainWindow.startPointTF, mouseGeoPos)

                }
                if (map.choosingEndPoint)
                {
                    map.endPoint = mouseGeoPos;
                    map.choosingEndPoint = false;
                    changeCoordinate(mainWindow.endPointTF, mouseGeoPos)
                }
            }
        }
    }

    Column 
    {
        id: dataColumn
        anchors.right: parent.right

        property var startPointTF: startPointTF
        property var endPointTF: endPointTF


        Button 
        {
            id: chooseStartPointButton
            text: qsTr("Choose start point")
            onClicked: onbuttonClick(true)
        }

        TextField 
        {
            id: startPointTF
            Layout.fillWidth: true
        }

        Button 
        {
            id: chooseEndPointButton
            text: qsTr("Choose end point")
            onClicked: onbuttonClick(false)
        }

        TextField 
        {
            id: endPointTF
            Layout.fillWidth: true
            readOnly: true
        }
    }
}