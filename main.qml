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
    Button {
        id: button
        width: mainW.width/3
        height: mainW.height/6
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
                            console.log("Idx ",index," released. ", mainW.listRnd[index])
                            if(listRnd[index] === 0) {parent.color = tileColorEmpty}        // element color
                                                    else                                    // if the same item is dropped and released
                                                     {parent.color = tileColor}             // at the same coordinates

                            let doubledCoo = Js.searchDoubledCoordinates(index,elemRep)     // doubledCoo means index, when two elements exist ( (-1) = false)

                            let textDropped = elemRep.itemAt(index).itemValue

                            console.log("text dropped: ",textDropped)
                            console.log("Doubled coordinates at : ",doubledCoo)
                            console.log("index: ",index)

                                    ///////////////////////////////////////////////////////////////////////////////////////////////////////
                                    ////////////////////////////////////////// ELEMENTS SWAP //////////////////////////////////////////////
                                    ///////////////////////////////////////////////////////////////////////////////////////////////////////

                            if(doubledCoo >= 0) {
                                let temporary = listRnd[index]                              //swap listRnd elements
                                listRnd[index] = listRnd[doubledCoo]
                                listRnd[doubledCoo] = temporary

                                let textCompared = elemRep.itemAt(doubledCoo).itemValue
                                elemRep.itemAt(index).itemValue = textCompared              //swap text values (numbers)
                                elemRep.itemAt(doubledCoo).itemValue = textDropped

                                elemRep.itemAt(index).x = listCoX[index]                    //leave the same coordinates for each item, cause
                                elemRep.itemAt(index).y = listCoY[index]                    //swapping are: colors, text values, and listRnd array elements

                                elemRep.itemAt(doubledCoo).x = listCoX[doubledCoo]          //
                                elemRep.itemAt(doubledCoo).y = listCoY[doubledCoo]          //
                                Js.displayCoordinates (elemNo, elemRep)

                                elemRep.itemAt(index).color = tileColorEmpty
                                elemRep.itemAt(index).opacity = 0

                                elemRep.itemAt(doubledCoo).color = tileColor
                                elemRep.itemAt(doubledCoo).opacity = 1

                                Js.colorSet (elemRep, listRnd, elemNo)
                                Js.opacitySet (elemRep, listRnd, elemNo)
                                Js.itemValueSet (elemRep, listRnd, elemNo)
                            }
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



