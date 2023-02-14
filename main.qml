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
    property int pDim: 4                                                // puzzle dimension
    property int elemNo: Math.pow (pDim,2)                              // number of puzzle elements including 0 (empty element)

    property variant listVal: []                                        // array of elements:  before draw
    property variant listRnd: []                                        //                     after draw
    property variant listCoX: []                                        // array of static X coordinates for each array elements (front-end purposes)
    property variant listCoY: []                                        // array of static Y coordinates for each array elements (front-end purposes)

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
            if(listRnd[i] === 0) {rect.color = tileColorEmpty; rect.opacity = 0; rect.itemValue = "" + listRnd[i] }
                                else
                                 {rect.color = tileColor; rect.opacity = 1; rect.itemValue = "" + listRnd[i] }
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function controlLogic (index, drag) {
        let columnFirst = false                                                                       // check clicked item position
        let columnLast = false                                                                        // (reset variables each time)
        let rowFirst = false
        let rowLast = false
        let boardMiddle = false

            if ( (index % pDim )    === 0 )     {                                                     // clicked item position
                columnFirst = true;                                                                   // checking
                console.log("column first")
            }
            if ( (index + 1) % pDim === 0 )     {
                columnLast = true;
                console.log("column last")
            }
            if ( index <= (pDim - 1) )          {
                rowFirst = true;
                console.log("row first")
            }
            if ( index > (elemNo - pDim - 1) )  {
                rowLast = true;
                console.log("row last")
            }
            if ( !columnFirst && !columnLast && !rowFirst && !rowLast) {
                boardMiddle = true;
                console.log("board middle")
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

        if (listRnd [index + 1] === 0) {                        // if empty place on right side // "empty place" means item
            drag.axis = Drag.XAxis                                                              // with text value "0".
            drag.maximumX = listCoX[ index + 1]                                                 // color tileEmptyColor
            drag.minimumX = listCoX[ index + 1]                                                    // listRnd = 0
        }
        if (listRnd [index - 1] === 0) {                        // if empty place on left side
            drag.axis = Drag.XAxis
            drag.maximumX = listCoX[ index - 1]
            drag.minimumX = listCoX[ index - 1]
        }
        if (listRnd [index + pDim] === 0) {                     // if empty place on lower row
            drag.axis = Drag.YAxis            
            drag.maximumY = listCoY [index + pDim]
            drag.minimumY = listCoY [index + pDim]
        }
        if (listRnd [index - pDim] === 0) {                     // if empty place on upper row
            drag.axis = Drag.YAxis
            drag.maximumY = listCoY [index - pDim]
            drag.minimumY = listCoY [index - pDim]
        }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
   function searchDoubledCoordinates(index,elemRep) {
        let droppedElement = elemRep.itemAt(index)
        let comparedElement = undefined
            //console.log("dropped element  x: ", droppedElement.x,"   y: ", droppedElement.y)

        for (let i = 0; i < elemNo; i ++ ) {
           comparedElement = elemRep.itemAt(i)
           //console.log("compared element x: ", comparedElement.x,"   y: ", comparedElement.y)

           if( (droppedElement.x === comparedElement.x) && (droppedElement.y === comparedElement.y) && ( i !== index) )
               return i          
        }
        return -1
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
            colorSet()
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
                            controlLogic(index,drag)                           
                            console.log(listRnd)
                            displayCoordinates()
                        }

                        onReleased: {
                            console.log("Idx ",index," released. ", mainW.listRnd[index])
                            if(listRnd[index] === 0) {parent.color = tileColorEmpty}        // element color
                                                    else                                    // if the same item is dropped and released
                                                     {parent.color = tileColor}             // at the same coordinates

                            let doubledCoo = searchDoubledCoordinates(index,elemRep)        // doubledCoo means index, when two elements exist ( (-1) = false)

                            let textDropped = elemRep.itemAt(index).itemValue
                            console.log("text dropped: ",textDropped)
                            console.log("Doubled coordinates at : ",doubledCoo)
                            console.log("index: ",index)

                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            /////////////////////////////////////////////////////// ELEMENTS SWAP /////////////////////////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
                                displayCoordinates()

                                elemRep.itemAt(index).color = tileColorEmpty
                                elemRep.itemAt(index).opacity = 0

                                elemRep.itemAt(doubledCoo).color = tileColor
                                elemRep.itemAt(doubledCoo).opacity = 1

                                colorSet()
                            }
                        }
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
        displaySomethingFunny()
    }
}



