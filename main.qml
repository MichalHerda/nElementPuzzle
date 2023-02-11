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
    property variant listCoX: []                                        // array of static X coordinates for each array elements (front-end purposes)
    property variant listCoY: []                                        // array of static Y coordinates for each array elements (front-end purposes)

    property bool empty
    property bool gameOver

    property color tileColor: "darkcyan"
    property color tileColorPressed: "darksalmon"
    property color tileColorEmpty: "black"
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listValFill() {                                            // fill array by elements, range 0 - elemNo
        listVal = []                                                    // reset
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array elements (values)
            listVal.push(i);
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listRndFill() {                                            // draw
        listRnd = []                                                    // reset
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
    function listCoXFill() {
        listCoX = []                                                    // reset
        for(let i = 0; i < elemNo; i++) {
            listCoX.push ( (i % mainW.pDim) * area.width/pDim )         // fill array by each element X coordinates
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listCoYFill() {
        listCoY = []                                                    // reset
        for(let i = 0; i < elemNo; i++) {
            listCoY.push (Math.floor(i / pDim) * area. height/pDim)     // fill array by each element Y coordinates
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

        let columnFirst = false                                                                       // check clicked item position
        let columnLast = false                                                                        // (reset variables each time)
        let rowFirst = false
        let rowLast = false
        let boardMiddle = false

            if ( (index % pDim )    === 0 )     {                                                     // clicked item position
                columnFirst = true;                                                                   // checking
                //console.log("column first")
            }
            if ( (index + 1) % pDim === 0 )     {
                columnLast = true;
                //console.log("column last")
            }
            if ( index <= (pDim - 1) )          {
                rowFirst = true;
                //console.log("row first")
            }
            if ( index > (elemNo - pDim - 1) )  {
                rowLast = true;
                //console.log("row last")
            }
            if ( !columnFirst && !columnLast && !rowFirst && !rowLast) {
                boardMiddle = true;
                //console.log("board middle")
            }
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

        let currentElement = elemRep.itemAt(index)              //  function to specify
                                                                //  the range of movement for individual elements of the board
        let itemOnRight = null
        let itemOnLeft = null
        let itemOnBottom = null
        let itemOnTop = null

        drag.target = currentElement

        if (listRnd [index + 1] === 0) {                        // when empty place on right side
            drag.axis = Drag.XAxis
            //itemOnRight = elemRep.itemAt(index + 1)
            drag.maximumX = listCoX[ index + 1]                                                      //itemOnRight.x
            drag.minimumX = listCoX[ index]                                                        //currentElement.x
        }
        if (listRnd [index - 1] === 0) {                        // when empty place on left side
            drag.axis = Drag.XAxis
            //itemOnLeft = elemRep.itemAt(index - 1)
            drag.maximumX = listCoX[ index]                                                          //currentElement.x
            drag.minimumX = listCoX[ index - 1]                                                     //itemOnLeft.x
        }
        if (listRnd [index + pDim] === 0) {                     // when empty place on lower row
            drag.axis = Drag.YAxis
            //itemOnBottom = elemRep.itemAt(index + pDim)
            drag.maximumY = listCoY [index + pDim]                                                  //itemOnBottom.y
            drag.minimumY = listCoY [index]                                                         //currentElement.y
        }
        if (listRnd [index - pDim] === 0) {                     // when empty place on upper row
            drag.axis = Drag.YAxis
            //itemOnTop = elemRep.itemAt(index - pDim)
            drag.maximumY = listCoY [index]                                                        //currentElement.y
            drag.minimumY = listCoY [index - pDim]                                                  //itemOnTop.y
        }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function elementsExchange(index,listRnd,listCoX,listCoY) {

        let droppedElement  = elemRep.itemAt(index)
        let droppedElementX = listCoX[index]
        let droppedElementY = listCoY[index]

        console.log("dropX: ",droppedElementX)
        console.log("dropY: ",droppedElementY)

        let comparedElement  = null
        let comparedElementX = null
        let comparedElementY = null

        let bufor = null

        //console.log("index :                ", index)
        //console.log("dropped element :      ", droppedElement)
        //console.log("dropped element ... x: ", droppedElement.x," y: ",droppedElement.y)
        //console.log("bufor :                ", bufor)
        //console.log("compared element :     ", comparedElement)
        //here is okay

        displayCoordinates()

            for (let i = 0; i < elemNo; i++) {
                console.log("index : ", index)
                console.log("iter  : ", i )

                    //console.log("i !== index")
                    //console.log("iteration elements, searching for exchange")
                    //console.log("iteration works: ", elemRep.itemAt(i))

                    comparedElement  = elemRep.itemAt(i)
                    comparedElementX = listCoX[i]
                    comparedElementY = listCoY[i]

                    console.log("compX: ",comparedElementX)
                    console.log("compY: ",comparedElementY)

                    //console.log("dropped  element x: ", droppedElement.x," y: ",droppedElement.y)
                    //console.log("compared element x: ", comparedElement.x," y: ",comparedElement.y)

                        if( (droppedElement.x === comparedElement.x) && (droppedElement.y === comparedElement.y) ) {

                            console.log("the same coordinates of two elements")

                            //bufor = comparedElementX
                            droppedElement.x = comparedElementX
                            comparedElement.x = droppedElementX

                            //bufor = 0

                            //bufor = comparedElementY
                            droppedElement.y = comparedElementY
                            comparedElement.y = droppedElementY

                            //comparedElement.opacity = 0
                            //droppedElement.opacity = 1

                            //bufor = 0
                                console.log("listRnd index before re-writting: ", listRnd [i])
                                console.log("listRnd iterr before re-writting: ", listRnd [index])
                            //
                                bufor = listRnd [index]
                                listRnd[index] = listRnd[i]
                                listRnd[i] = bufor
                            //
                                console.log("listRnd index after re-writting: ", listRnd [i])
                                console.log("listRnd iterr after re-writting: ", listRnd [index])

                                console.log(listRnd)
                                //break

                                //listCoXFill()
                                //listCoYFill()
                        }                

            }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function displayCoordinates() {
        for (let i = 0; i < elemNo; i++ ) {
            let currentItem = elemRep.itemAt(i)
            console.log("Element ",i," - x: ",currentItem.x,", y: ",currentItem.y)
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
                    x: (index % mainW.pDim) * area.width/pDim                                // important MATHEMATICAL FORMULA
                    y:  Math.floor (index / pDim) * area. height/pDim                        // learn it and remember !!!!
                    //z: listRnd[index] === 0 ? -1 : 0
                    width: area.width/pDim
                    height: area.height/pDim
                    border {color: tileColorEmpty; width: element.width/20}
                    clip: true

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent

                        onPressed: {                           
                            if(listRnd[index] === 0) {parent.color = tileColorEmpty; console.log("pressed")}
                                else
                                  { parent.color = tileColorPressed; console.log("pressed"); }
                            controlLogic(index,drag)
                            //let checkCoord = elemRep.itemAt(index)
                            //console.log("coordinates: ", checkCoord.x," ",checkCoord.y)
                            //displayCoordinates()
                            console.log(listCoX)
                            console.log(listCoY)
                        }

                        onReleased: {
                            console.log("Idx ",index," released. ", mainW.listRnd[index])
                            if(listRnd[index] === 0) {parent.color = tileColorEmpty}
                                                    else
                                                     {parent.color = tileColor}

                            //displayCoordinates()
                            elementsExchange(index,listRnd,listCoX,listCoY)
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
                        font.bold: true
                        font.pixelSize: area.width/15
                    }
                }
            }
        }
    Component.onCompleted: {
        listValFill();
        listRndFill();
        listRndChanged();
        colorSet();
        listCoXFill();
        listCoYFill();
        //elementsExchange()
    }
}



