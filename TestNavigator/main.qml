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
        if (mouseGeoPos == null)
        {
            textField.text = qsTr("");
        }
        else
        {
            textField.text = qsTr("%1 %2").arg(mouseGeoPos.latitude).arg(mouseGeoPos.longitude);
        }
    }

    function buildRoute()
    {
        routeQuery.clearWaypoints();

        if (map.startPoint == null || map.endPoint == null)
        {
            return;
        }

        // add the start and end coords as waypoints on the route
        routeQuery.addWaypoint(map.startPoint);
        routeQuery.addWaypoint(map.endPoint);
        routeQuery.travelModes = RouteQuery.CarTravel;
        routeQuery.routeOptimizations = RouteQuery.FastestRoute;

        for (var i=0; i<9; i++)
        {
            routeQuery.setFeatureWeight(i, 0);
        }

        routeModel.update();

        // center the map on the start coord
        map.center = map.startPoint;
    }

    function clearRoute()
    {
        routeQuery.clearWaypoints();
        routeModel.reset()
        routeModel.update();

        map.startPoint = null;
        map.endPoint = null;

        changeCoordinate(mainWindow.startPointTF, null);
        changeCoordinate(mainWindow.endPointTF, null);
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

        property alias routeQuery: routeQuery
        property alias routeModel: routeModel

        MouseArea 
        {
            id: mouseArea
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

        Component
        {
            id: routeDelegate

            MapRoute 
            {
                id: route
                route: routeData
                line.color: "#46a2da"
                line.width: 5
                smooth: true
                opacity: 0.8
            }
        }

        RouteModel 
        {
            id: routeModel
            plugin : map.plugin
            query:  RouteQuery
            {
                id: routeQuery
            }
        }

        MapItemView 
        {
            model: routeModel
            delegate: routeDelegate
            autoFitViewport: true
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
            readOnly: true
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

        Button 
        {
            id: buildRouteButton
            text: qsTr("Build route")
            onClicked: buildRoute()
        }

        Button 
        {
            id: clearRouteButton
            text: qsTr("Clear route")
            onClicked: clearRoute()
        }
    }
}