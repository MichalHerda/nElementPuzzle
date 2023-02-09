import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5

ApplicationWindow {
    id: mainW
    width: 640
    height: 480
    visible: true
    title: qsTr("nElementPuzzle")
    color: "blue"
//-------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------GLOBAL VARIABLES AND FUNCTIONS--------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------
    property int pDim: 4                                                // puzzle dimension
    property int elemNo: pDim * pDim                                    // number of puzzle elements including 0 (empty element)

    property variant listVal: []                                        // array of elements:  before draw
    property variant listRnd: []                                        //                     after draw

    property bool empty
    property bool gameOver

    property color tileColor: "darkcyan"
    property color tileColorPressed: "darksalmon"
    property color tileColorEmpty: "black"

    function listValFill() {                                            // fill array by elements
        listVal = []
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array elements (values)
            listVal.push(i);
        }
    }
    function listRndFill() {                                            // draw
        listRnd = []
        let listValDecrease = elemNo
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array index
            let rnd = Math.floor(Math.random() * listValDecrease)
            //console.log("rnd:  ",rnd)
            listRnd[i] = listVal[rnd]                                   // 0 (zero) means empty element, which can be drop area for
            listVal.splice(rnd,1)                                       // neighbour element
            listValDecrease --
            colorSet()
            //console.log("arr1: ",listVal[0])
        }
    }
    function colorSet () {
        for (let i = 0; i < elemNo; i++) {                              // function colorSet is required to refresh colors
            var rect = elemRep.itemAt(i)                                // after listRnd and listVal drawing
            //console.log("item color is ", rect.color)

            if(listRnd[i] === 0) {rect.color = tileColorEmpty; rect.opacity = 0 }
                            else
                                 {rect.color = tileColor; rect.opacity = 1 }
        }
    }
//-------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------USER SETTINGS----------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------
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
            listValFill()
            listRndFill()
            listRndChanged()
            //console.log(mainW.listRnd)

        }
    }
//-------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------GAME AREA-------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------
        Rectangle {
            id: area
            width: mainW.width/1.5
            height: mainW.height
            anchors.left: parent.left
            color: tileColorEmpty
            clip: true

            Repeater {
                id: elemRep
                model: elemNo
                delegate: Rectangle {
                    id: element
                    x: (index % mainW.pDim) * area.width/pDim                   // important MATHEMATICAL FORMULA
                    y:  Math.floor(index / pDim) * area. height/pDim            // learn it and remember !!!!
                    width: area.width/pDim
                    height: area.height/pDim
                    border {color: tileColorEmpty; width: element.width/20}
                    clip: true

                    MouseArea {
                        anchors.fill: parent

                        onPressed: {                           
                            if(listRnd[index] === 0) parent.color = tileColorEmpty
                                else
                                  parent.color = tileColorPressed                           
                            if(listRnd[index] !== 0) {
                               if ( (index % pDim === 0) && (listRnd[index + 1] === 0) )
                                    drag.target = elemRep.itemAt(index)
                               if ( ( (index + 1) % pDim === 0 ) && (listRnd[index - 1] === 0 ) )
                                    drag.target = elemRep.itemAt(index)
                               if ( ( index <= (pDim - 1) ) && (listRnd[index + pDim] === 0 ) )
                                    drag.target = elemRep.itemAt(index)
                               if ( (index >= (elemNo - pDim - 1) ) && (listRnd[index - pDim] === 0))
                                    drag.target = elemRep.itemAt(index)
                               if ( (index % pDim !== 0) && ( (index + 1) % pDim !== 0 ) && ( index > (pDim - 1)) && (index < (elemNo - pDim - 1) )
                                     && ( (listRnd[index + 1] === 0) || (listRnd[index - 1] === 0 ) || (listRnd[index - pDim] === 0)
                                         || (listRnd[index - pDim] === 0) ) )
                                     drag.target = elemRep.itemAt(index)
                            }
                        }

                        onReleased: {
                            console.log("Idx ",index," released. ", mainW.listRnd[index])
                            if(listRnd[index] === 0) parent.color = tileColorEmpty
                                else
                                  parent.color = tileColor
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "" + mainW.listRnd[index]                         //listRnd[index]
                    }
                }
            }
        }
    Component.onCompleted: { listValFill(); listRndFill(); listRndChanged(); colorSet()}
}



