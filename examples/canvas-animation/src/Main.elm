module Main exposing (..)

import Keyboard exposing (KeyCode)
import Window exposing (Size)
import AnimationFrame
import Json.Encode exposing (Value)
import Task
import Time exposing (Time)
import Json.Encode as Encode
import Html exposing (div, Html, text, button)
import Collage
import Element
import Color exposing (Color)
import Html.Attributes exposing (style, id)
import Html.Events exposing (onClick, onMouseDown, onMouseUp, on)


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = \value -> ( init value, Task.perform Resize Window.size )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.state == Playing then
            AnimationFrame.diffs Tick
          else
            Sub.none

        -- , Keyboard.ups (key False model)
        -- , Keyboard.downs (key True model)
        , Window.resizes Resize
        ]


init : Encode.Value -> Model
init value =
    { state = Playing
    , size = Size 0 0
    , position = Position 0.0 0.0
    }


type alias Model =
    { state : State
    , size : Size
    , position : Position
    }


type alias Position =
    { x : Float
    , y : Float
    }


type State
    = Paused
    | Playing
    | Stopped


type Msg
    = Tick Time
    | Resize Size
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | size = size }, Cmd.none )

        Tick time ->
            let
                x =
                    model.position.x

                position =
                    model.position

                xx =
                    if x > pixelWidth / 2 then
                        negate x
                    else
                        x + 1
            in
                ( { model | position = { position | x = xx } }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        w =
            toFloat model.size.width

        h =
            toFloat model.size.height

        r =
            if w / h > pixelWidth / pixelHeight then
                min 1 (h / pixelHeight)
            else
                min 1 (w / pixelWidth)
    in
        div
            [ style
                [ ( "width", "100%" )
                , ( "height", "100%" )
                , ( "position", "relative" )
                ]
            , id "main"
            ]
            [ div
                [ style
                    [ ( "width", toString pixelWidth ++ "px" )
                    , ( "height", toString pixelHeight ++ "px" )
                    , ( "position", "absolute" )

                    -- , ( "left", toString ((w - pixelWidth * r) / 2) ++ "px" )
                    -- , ( "top", toString ((h - pixelHeight * r) / 2) ++ "px" )
                    , ( "transform-origin", "0 0" )

                    -- , ( "transform", "scale(" ++ toString r ++ ")" )
                    ]
                , id "canvas"
                ]
                [ renderBox model.position
                ]
            ]



-- renderCollage : Html Msg
-- renderCollage =
--     Collage.collage (pixelWidth)
--         (pixelHeight)
--         []


renderBox : Position -> Html Msg
renderBox position =
    let
        width =
            20

        height =
            10
    in
        Collage.collage
            (width * 30)
            (height * 30)
            [ Collage.rect 30 30
                |> Collage.filled Color.red
                |> Collage.move ( position.x, position.y )
            ]
            |> Element.toHtml



-- Collage.rect 30 30
--     |> Collage.filled (Color.rgb 236 240 241)
--     -- |> Collage.move ( (toFloat x + xOff) * 30, (toFloat y + yOff) * -30 )
--     |> Collage.collage (width * 30) (height * 30)
--     |> Element.toHtml


pixelWidth : Float
pixelWidth =
    480


pixelHeight : Float
pixelHeight =
    680
