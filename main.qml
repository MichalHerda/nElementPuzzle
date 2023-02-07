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

    property int pDim: 4                                                // puzzle dimension
    //property int yDim: 7
    property int elemNo: pDim * pDim                                    // number of puzzle elements including 0 (empty element)

    property variant listVal: []                                        // array of elements:  before draw
    property variant listRnd: []                                        //                     after draw

    property bool empty
    property bool gameOver

    function listValFill() {                                            // fill array by elements
        listVal = []
        for(let i = 0; i <= elemNo; i++) {                              // here: int 'i' loop are array elements (values)
            listVal.push(i);
        }
    }

    function listRndFill() {                                            // draw
        listRnd = []
        let listValDecrease = elemNo
        for(let i = 0; i <= elemNo; i++) {                              // here: int 'i' loop are array index
            let rnd = Math.floor(Math.random() * listValDecrease )
            //console.log("rnd:  ",rnd)
            listRnd[i] = listVal[rnd]                                   // 0 (zero) means empty element, which can be drop area for
            listVal.splice(rnd,1)                                       // neighbour element
            listValDecrease --
            //console.log("arr1: ",listVal[0])
        }    
    }

    Component.onCompleted: { listValFill(); listRndFill(); listRndChanged() }

    Button {
        id: button
        width: mainW.width/3
        height: mainW.height/6
        anchors.right: parent.right

        background: Rectangle {
               color: inputHandler.pressed ? "darkgoldenrod" : "royalblue"
               border {color: inputHandler.pressed ? "red" : "cadetblue"; width: button.width/40}

               Text {
                     anchors.centerIn: parent
                     color: inputHandler.pressed ? "maroon" : "darkblue"
                     text: "Generate"
                }

               TapHandler {
                      id: inputHandler
                }
            }


        onClicked: {
            listValFill()
            console.log("listVal: ",listVal)
            listRndFill()
            console.log("listRnd: ",listRnd)
            elemRep.checkZero
            listRndChanged()
        }
    }
        Rectangle {
            id: area
            width: mainW.width/1.5
            height: mainW.height
            anchors.left: parent.left
            color: "darkblue"

/*
            function arrDisplay() {
                for(let i = 0; i < elemNo; i++) {
                    console.log("no ",i,"= ",listRnd[i])
                }
            }
*/
            Repeater {
                id: elemRep
                model: elemNo
                delegate: Rectangle {
                    id: element
                    x: (index % mainW.pDim) * area.width/pDim                   // important MATHEMATICAL FORMULA
                    y:  Math.floor(index / pDim) * area. height/pDim            // learn it and remember !!!!
                    width: area.width/pDim
                    height: area.height/pDim
                    color: "darkcyan"
                    border {color: "black"; width: element.width/20}
                    clip: true

                    property int elemVal:  mainW.listRnd[index]
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
                    function checkZero() {
                        for(let i = 0; i < mainW.elemNo; i++) {                        // needs to work
                            if(mainW.listRnd[i] === 0)
                                elemRep.removeItem(i)
                        }
                    }
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
                    Text {
                        anchors.centerIn: parent
                        text: "" + elemVal
                    }
                }
            }
        }
/*
        Timer {
            interval: 1
            repeat: false
            running: true
            onTriggered: {
                area.arrDisplay()
            }
        }
*/
}



