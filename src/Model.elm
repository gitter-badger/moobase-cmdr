module Model exposing(..)

import Color exposing (Color)

type alias Angle = Float
type alias Force = Float

type alias Model =
    { hubs: List Hub
    , direction: Angle
    , force: Force
    }

type alias Hub = 
    { color : Color 
    , pos : (Int, Int)
    , size : Float
    }

initialHub: Hub
initialHub =
    { color = Color.blue
    , pos = (0,0)
    , size = 25
    }

newHubAt: (Int, Int) -> Hub
newHubAt pos =
    { color = Color.red
    , pos = pos
    , size = 25
    }

launch: Hub -> Angle -> Force -> (Int, Int)
launch hub direction force =
    case (direction, hub.pos) of
        (0  , (x,y)) -> (x, y + round force)
        (180, (x,y)) -> (x, y - round force)
        (90 , (x,y)) -> (x + round force, y)
        (270, (x,y)) -> (x - round force, y)
        (_  , (_,_)) -> (100,100)