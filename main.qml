import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import "jsBackEnd.js" as Js
//--------------------------------------------------------------------------------------------------------------------------------------------------
ApplicationWindow {
    id: mainW
    width: 640
    height: 480
    visible: true
    title: qsTr("nElementPuzzle")
    color: "blue"
//--------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------GLOBAL VARIABLES------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------
    property int pDim: 4                                                // puzzle dimension
    property int elemNo: Math.pow (pDim,2)                              // number of puzzle elements including 0 (empty element)

    property double areaWidth: mainW.width/1.5                          // areaWidth/areaHeight variables exists to enable passing them
    property double areaHeight: mainW.height                            // to js.ListCoXFill/js.ListCoYFill functions

    property variant listVal: Js.listValFill (elemNo)                   // array of elements:  before draw
    property variant listRnd: Js.listRndFill (listVal, elemNo)          //                     after draw
    property variant listCoX: Js.listCoXFill (elemNo, pDim, areaWidth)  // array of static X coordinates for each array elements (front-end purposes)
    property variant listCoY: Js.listCoYFill (elemNo, pDim, areaHeight) // array of static Y coordinates for each array elements (front-end purposes)

    property color tileColor: "darkcyan"
    property color tileColorPressed: "darksalmon"
    property color tileColorEmpty: "black"
//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------USER INTERFACE------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
        Rectangle {
            id: userInterface
            width: mainW.width - area.width
            height: mainW.height
            anchors.right: parent.right
            color: "darkslategrey"

            Button {
                id: button
                width: userInterface.width
                height: userInterface.height/7
                anchors.right: parent.right

                background: Rectangle {
                       color: inputHandler.pressed ? "darkgoldenrod" : "midnightblue"
                       border {color: inputHandler.pressed ? "red" : "cadetblue"; width: button.width/40}

                       Text {
                             anchors.centerIn: parent
                             color: inputHandler.pressed ? "maroon" : "aqua"
                             text: "Generate"
                        }
                       TapHandler {
                              id: inputHandler
                        }
                    }
                onClicked: {
                    Js.listValFill (elemNo)
                    Js.listRndFill (listVal, elemNo)
                    Js.colorSet (elemRep, listRnd, elemNo)
                    Js.opacitySet (elemRep, listRnd, elemNo)
                    Js.itemValueSet (elemRep, listRnd, elemNo)
                    listRndChanged()
                }
            }
//--------------------------------------------------------------------------------------------------------------------------------------------------
            Label {
                id: label
                width: button.width/2
                height: button.height/2
                x: userInterface.width/3.5
                y: button.height * 1.75
                text: "Select Puzzle Size"
                font.pixelSize: 12
                font.italic: true
            }

//--------------------------------------------------------------------------------------------------------------------------------------------------
            ComboBox {
                id: combo
                width: button.width/2
                height: button.height/2
                x: userInterface.width/4
                y: button.height * 2
                model: ListModel {
                    id: comboModel
                }
                Component.onCompleted: {
                       for(var i=3; i<=10; i++) {
                           comboModel.append({text: i.toString()})
                       }
                }
                onCurrentIndexChanged: {
                            pDim = parseInt(combo.currentText)              // NOW IT PRODUCE SOME BUGS
                            elemNo = Math.pow (pDim,2)                      // IT DOES NOT WORK PROPERLY AT ALL
                            console.log("pDim after changing: ", pDim)      // IT REQUIRES REFACTORING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                            pDimChanged()

                            Js.listValFill (elemNo)
                            Js.listRndFill (listVal, elemNo)
                            Js.colorSet (elemRep, listRnd, elemNo)
                            Js.opacitySet (elemRep, listRnd, elemNo)
                            Js.itemValueSet (elemRep, listRnd, elemNo)
                            listRndChanged()
                }
            }
        }
//---------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------GAME AREA------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
        Rectangle {
            id: area
            width: areaWidth
            height: areaHeight
            anchors.left: parent.left
            color: tileColorEmpty
            clip: true

            Repeater {
                id: elemRep
                model: elemNo
                delegate: Rectangle {
                    id: element
                    x: (index % mainW.pDim) * area.width/pDim                                // important MATHEMATICAL FORMULA
                    y:  Math.floor (index / pDim) * area. height/pDim                        // learn it and remember !!!!
                    width: area.width/pDim
                    height: area.height/pDim
                    border {color: tileColorEmpty; width: element.width/20}
                    clip: true
                    property string itemValue: "" + mainW.listRnd[index]                     // enable reading repeater's children property

                    Text {
                        id: textElement
                        anchors.centerIn: parent
                        text: parent.itemValue
                        font.bold: true
                        font.pixelSize: area.width/15
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent

                        onPressed: {                           
                            if(listRnd[index] === 0) { parent.color = tileColorEmpty; console.log("pressed") }
                                                    else
                                                     { parent.color = tileColorPressed; console.log("pressed") }
                            Js.controlLogic (elemRep, listRnd, index, drag, listCoX, listCoY, pDim)
                            console.log(listRnd)
                            Js.displayCoordinates (elemNo, elemRep)
                        }

                        onReleased: {
                            Js.logicOnRelease (listRnd, index, tileColorEmpty, tileColor, elemRep, elemNo, listCoX, listCoY, parent)
                        }
                    }
                }
            }
        }
    Component.onCompleted: {
        Js.listValFill (elemNo);
        Js.listRndFill (listVal, elemNo);
        Js.listCoXFill (elemNo, pDim, areaWidth);
        Js.listCoYFill (elemNo, pDim, areaHeight);

        Js.colorSet (elemRep, listRnd, elemNo)
        Js.opacitySet (elemRep, listRnd, elemNo)
        Js.itemValueSet (elemRep, listRnd, elemNo)

        listRndChanged();
    }
}



