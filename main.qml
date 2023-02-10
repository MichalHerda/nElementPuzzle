import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
//--------------------------------------------------------------------------------------------------------------------------------------------------
ApplicationWindow {
    id: mainW
    width: 640
    height: 480
    visible: true
    title: qsTr("nElementPuzzle")
    color: "blue"
//--------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------GLOBAL VARIABLES AND FUNCTIONS-------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------
    property int pDim: 3                                                // puzzle dimension
    property int elemNo: Math.pow (pDim,2)                              // number of puzzle elements including 0 (empty element)

    property variant listVal: []                                        // array of elements:  before draw
    property variant listRnd: []                                        //                     after draw

    property bool empty
    property bool gameOver

    property color tileColor: "darkcyan"
    property color tileColorPressed: "darksalmon"
    property color tileColorEmpty: "black"
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listValFill() {                                            // fill array by elements, range 0 - elemNo
        listVal = []
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array elements (values)
            listVal.push(i);
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listRndFill() {                                            // draw
        listRnd = []
        let listValDecrease = elemNo
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array index
            let rnd = Math.floor(Math.random() * listValDecrease)
            listRnd[i] = listVal[rnd]                                   // 0 (zero) means empty element, which can be drop area for
            listVal.splice(rnd,1)                                       // neighbour element
            listValDecrease --
            colorSet()
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function colorSet () {
        for (let i = 0; i < elemNo; i++) {                                          // function colorSet is required to refresh colors
            var rect = elemRep.itemAt(i)                                            // after listRnd and listVal drawing            
            if(listRnd[i] === 0) {rect.color = tileColorEmpty; rect.opacity = 0 }
                                else
                                 {rect.color = tileColor; rect.opacity = 1 }
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function controlLogic (index, drag) {

        let allowedTarget = null

        let columnFirst = false                                                                       // clicked item position
        let columnLast = false                                                                        // definition
        let rowFirst = false
        let rowLast = false
        let boardMiddle = false

            if ( (index % pDim )    === 0 )     { columnFirst = true; console.log("column first") }   // clicked item position
            if ( (index + 1) % pDim === 0 )     { columnLast = true; console.log("column last") }     // checking
            if ( index <= (pDim - 1) )          { rowFirst = true; console.log("row first") }
            if ( index > (elemNo - pDim - 1) )  { rowLast = true; console.log("row last") }
            if ( !columnFirst && !columnLast && !rowFirst && !rowLast)
                                                { boardMiddle = true; console.log("board middle") }
//---------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------CHECKING IF CLICKED ITEM MOVE IS AVAILABLE------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
        if ( ( columnFirst && rowFirst ) && (listRnd[index + 1] === 0 || listRnd[index + pDim] === 0 ) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( columnFirst && rowLast) && (listRnd[index + 1] === 0 || listRnd[index - pDim] === 0 ) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( columnLast && rowFirst) && (listRnd[index - 1] === 0 || listRnd[index + pDim] === 0 ) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( columnLast && rowLast) && (listRnd[index - 1] === 0 || listRnd[index - pDim] === 0 ) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( columnFirst && !rowFirst && !rowLast ) && ( listRnd[index + 1] === 0 || listRnd[index + pDim] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( columnLast && !rowFirst && !rowLast ) && ( listRnd[index - 1] === 0 || listRnd[index + pDim] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( rowFirst && !columnFirst && !columnLast) && ( listRnd[index - 1] === 0 || listRnd[index + 1] === 0  || listRnd[index + pDim] === 0) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( rowLast && !columnFirst && !columnLast) && ( listRnd[index - 1] === 0 || listRnd[index + 1] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(index, drag)
            }
        if ( ( boardMiddle) && ( listRnd [index - 1] === 0 || listRnd [index + 1] === 0
                                || listRnd [index + pDim] === 0 || listRnd [index - pDim] === 0) ) {
               specifyMoveRange(index, drag)
            }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function specifyMoveRange(index, drag) {

        let currentElement = elemRep.itemAt(index)              // the purpose of this function is to specify
                                                                //  the range of movement for individual elements of the board
        let itemOnRight = null
        let itemOnLeft = null
        let itemOnBottom = null
        let itemOnTop = null

        drag.target = currentElement

        if (listRnd [index + 1] === 0) {
            drag.axis = Drag.XAxis
            itemOnRight = elemRep.itemAt(index + 1)
            drag.maximumX = itemOnRight.x
            drag.minimumX = currentElement.x
        }
        if (listRnd [index - 1] === 0) {
            drag.axis = Drag.XAxis
            itemOnLeft = elemRep.itemAt(index - 1)
            drag.maximumX = currentElement.x
            drag.minimumX = itemOnLeft.x
        }
        if (listRnd [index + pDim] === 0) {
            drag.axis = Drag.YAxis
            itemOnBottom = elemRep.itemAt(index + pDim)
            drag.maximumY = itemOnBottom.y
            drag.minimumY = currentElement.y
        }
        if (listRnd [index - pDim] === 0) {
            drag.axis = Drag.YAxis
            itemOnTop = elemRep.itemAt(index - pDim)
            drag.maximumY = currentElement.y
            drag.minimumY = itemOnTop.y
        }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function elementsExchange(index) {

        console.log("iteration elements, searching for exchange")
        let droppedElement = elemRep.itemAt(index)
        let bufor = null
        let comparedElement = null

            for (let i = 0; i < elemNo; i++) {
                if ( i !== index) {
                    console.log("iteration works")
                    comparedElement = elemRep.itemAt(i)

                        if( (droppedElement.x === comparedElement.x) && (droppedElement.y === comparedElement.y) ) {
                            console.log("the same coordinates of two elements")
                            bufor = droppedElement
                            droppedElement = comparedElement
                            comparedElement = bufor
                            bufor = 0

                                bufor = listRnd [index]
                                listRnd[index] = listRnd[i]
                                listRnd[i] = bufor
                                break
                        }
                }
            }



    }

//---------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------USER INTERFACE SETTINGS---------------------------------------------------------------------
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
            listValFill()
            listRndFill()
            listRndChanged()
            //console.log(mainW.listRnd)

        }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------GAME AREA------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------
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
                        id: mouseArea
                        anchors.fill: parent

                        onPressed: {                           
                            if(listRnd[index] === 0) parent.color = tileColorEmpty
                                else
                                  parent.color = tileColorPressed
                            controlLogic(index,drag)
                            let checkCoord = elemRep.itemAt(index)
                            console.log("coordinates: ", checkCoord.x," ",checkCoord.y)
                        }

                        onReleased: {
                            console.log("Idx ",index," released. ", mainW.listRnd[index])
                            if(listRnd[index] === 0) {parent.color = tileColorEmpty}
                                                    else
                                                     {parent.color = tileColor}
                            let checkCoord = elemRep.itemAt(index)
                            console.log("coordinates: ", checkCoord.x," ",checkCoord.y)
                            elementsExchange(index)
                        }
                    }
/*
                    DropArea {
                        id: dropArea
                        anchors.fill: parent
                        enabled: listRnd [index] === 0 ? true : false

                        onDropped: {
                            console.log("Dropped")
                        }

                    }
*/
                    Text {
                        anchors.centerIn: parent
                        text: "" + mainW.listRnd[index]                         //listRnd[index]
                    }
                }
            }
        }
    Component.onCompleted: { listValFill(); listRndFill(); listRndChanged(); colorSet()}
}



