//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listValFill(elemNo) {                                      // fill array by elements, range 0 - elemNo
        listVal = [];                                                   // reset
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array elements (values)
            listVal.push(i);
        }
        return listVal;
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listRndFill (listVal,elemNo) {                             // draw
        listRnd = [];                                                   // reset
        let listValDecrease = elemNo;
        for(let i = 0; i < elemNo; i++) {                               // here: int 'i' loop are array index
            let rnd = Math.floor(Math.random() * listValDecrease);
            listRnd[i] = listVal[rnd];                                  // 0 (zero) means empty element, which can be drop area for
            listVal.splice(rnd,1);                                      // neighbour element
            listValDecrease --;
            colorSet();
        }
        return listRnd;
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listCoXFill (elemNo, pDim, areaWidth) {
        listCoX = [];                                                   // reset
        for(let i = 0; i < elemNo; i++) {
            listCoX.push ( (i % pDim) * areaWidth/pDim );               // fill array by each element X coordinates
        }
        return listCoX;
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function listCoYFill(elemNo, pDim, areaHeight) {
        listCoY = [];                                                   // reset
        for(let i = 0; i < elemNo; i++) {
            listCoY.push (Math.floor(i / pDim) * areaHeight/pDim);      // fill array by each element Y coordinates
        }
        return listCoY;
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function controlLogic (elemRep, listRnd, index, drag, listCoX, listCoY, pDim) {
        let columnFirst = false;                                                                      // check clicked item position
        let columnLast = false;                                                                       // (reset variables each time)
        let rowFirst = false;
        let rowLast = false;
        let boardMiddle = false;

            if ( (index % pDim )    === 0 )     {                                                     // clicked item position
                columnFirst = true;                                                                   // checking
                console.log("column first");
            }
            if ( (index + 1) % pDim === 0 )     {
                columnLast = true;
                console.log("column last");
            }
            if ( index <= (pDim - 1) )          {
                rowFirst = true;
                console.log("row first");
            }
            if ( index > (elemNo - pDim - 1) )  {
                rowLast = true;
                console.log("row last");
            }
            if ( !columnFirst && !columnLast && !rowFirst && !rowLast) {
                boardMiddle = true;
                console.log("board middle");
            }

                //---------------------------------------------------------------------------------------------------------------
                //-------------------------------CHECKING IF CLICKED ITEM MOVE IS AVAILABLE--------------------------------------
                //---------------------------------------------------------------------------------------------------------------

        if ( ( columnFirst && rowFirst ) && (listRnd[index + 1] === 0 || listRnd[index + pDim] === 0 ) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( columnFirst && rowLast) && (listRnd[index + 1] === 0 || listRnd[index - pDim] === 0 ) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( columnLast && rowFirst) && (listRnd[index - 1] === 0 || listRnd[index + pDim] === 0 ) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( columnLast && rowLast) && (listRnd[index - 1] === 0 || listRnd[index - pDim] === 0 ) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( columnFirst && !rowFirst && !rowLast ) && ( listRnd[index + 1] === 0 || listRnd[index + pDim] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( columnLast && !rowFirst && !rowLast ) && ( listRnd[index - 1] === 0 || listRnd[index + pDim] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( rowFirst && !columnFirst && !columnLast) && ( listRnd[index - 1] === 0 || listRnd[index + 1] === 0  || listRnd[index + pDim] === 0) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim)
            }
        if ( ( rowLast && !columnFirst && !columnLast) && ( listRnd[index - 1] === 0 || listRnd[index + 1] === 0  || listRnd[index - pDim] === 0) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
        if ( ( boardMiddle) && ( listRnd [index - 1] === 0 || listRnd [index + 1] === 0
                                || listRnd [index + pDim] === 0 || listRnd [index - pDim] === 0) ) {
               specifyMoveRange(elemRep, listRnd, index, drag, listCoX, listCoY, pDim);
            }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function specifyMoveRange (elemRep, listRnd, index, drag, listCoX, listCoY, pDim) {
        let currentElement = elemRep.itemAt(index)              //  function to specify
                                                                //  the range of movement for individual elements of the board
        let itemOnRight = null;
        let itemOnLeft = null;
        let itemOnBottom = null;
        let itemOnTop = null;

        /*
        console.log("listCoX: ", listCoX);
        console.log("listCoY: ", listCoY);
        console.log("pDim;    ", pDim);
        console.log("index:   ", index);
        console.log("listRnd: ", listRnd);
        console.log("elemRep: ", elemRep);
        console.log("drag:    ", drag);
        */

        drag.target = currentElement

        if (listRnd [index + 1] === 0) {                        // if empty place on right side // "empty place" means item
            drag.axis = Drag.XAxis;                                                             // with text value "0".
            drag.maximumX = listCoX[ index + 1];                                                // color tileEmptyColor
            drag.minimumX = listCoX[ index + 1];                                                // listRnd = 0
        }
        if (listRnd [index - 1] === 0) {                        // if empty place on left side
            drag.axis = Drag.XAxis;
            drag.maximumX = listCoX[ index - 1];
            drag.minimumX = listCoX[ index - 1];
        }
        if (listRnd [index + pDim] === 0) {                     // if empty place on lower row
            drag.axis = Drag.YAxis;
            drag.maximumY = listCoY [index + pDim];
            drag.minimumY = listCoY [index + pDim];
        }
        if (listRnd [index - pDim] === 0) {                     // if empty place on upper row
            drag.axis = Drag.YAxis;
            drag.maximumY = listCoY [index - pDim];
            drag.minimumY = listCoY [index - pDim];
        }
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
   function searchDoubledCoordinates (index, elemRep) {
        let droppedElement = elemRep.itemAt(index);
        let comparedElement = undefined;
            //console.log("dropped element  x: ", droppedElement.x,"   y: ", droppedElement.y);

        for (let i = 0; i < elemNo; i ++ ) {
           comparedElement = elemRep.itemAt(i);
           //console.log("compared element x: ", comparedElement.x,"   y: ", comparedElement.y);

           if( (droppedElement.x === comparedElement.x) && (droppedElement.y === comparedElement.y) && ( i !== index) )
               return i;
        }
        return -1;
    }
//---------------------------------------------------------------------------------------------------------------------------------------------------
    function displayCoordinates (elemNo, elemRep) {
        for (let i = 0; i < elemNo; i++ ) {
            let currentItem = elemRep.itemAt(i)
            console.log("Element ",i," - x: ",currentItem.x,", y: ",currentItem.y)
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function colorSet (elemRep, listRnd, elemNo) {
        for (let i = 0; i < elemNo; i++) {                                          // function colorSet is required to refresh colors
            var rect = elemRep.itemAt(i)                                            // after listRnd and listVal drawing
            if(listRnd[i] === 0) {rect.color = tileColorEmpty;  }
                                else
                                 {rect.color = tileColor;  }
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function opacitySet (elemRep, listRnd, elemNo) {
        for (let i = 0; i < elemNo; i++) {                                          // function colorSet is required to refresh colors
            var rect = elemRep.itemAt(i)                                            // after listRnd and listVal drawing
            if(listRnd[i] === 0) {rect.opacity = 0; }
                                else
                                 {rect.opacity = 1; }
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
    function itemValueSet (elemRep, listRnd, elemNo) {
        for (let i = 0; i < elemNo; i++) {                                          // function colorSet is required to refresh colors
            var rect = elemRep.itemAt(i)                                            // after listRnd and listVal drawing
            if(listRnd[i] === 0) {rect.itemValue = "" + listRnd[i] }
                                else
                                 {rect.itemValue = "" + listRnd[i] }
        }
    }
//--------------------------------------------------------------------------------------------------------------------------------------------------
