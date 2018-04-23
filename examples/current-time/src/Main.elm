module Main exposing (main)

import Date exposing (Day(..))
import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E
import Task
import Time exposing (Time)


main : Program Never Model Msg
main =
    H.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { lastTime : Maybe Time
    }


type Msg
    = GetCurrentTime
    | OnTime Time


init : ( Model, Cmd Msg )
init =
    ( { lastTime = Nothing }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetCurrentTime ->
            ( model, getTime )

        OnTime time ->
            ( { model | lastTime = Just time }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    H.div [ A.style [ ( "padding", "20px" ) ] ]
        [ H.button [ E.onClick GetCurrentTime ] [ text "What time is it?" ]
        , case model.lastTime of
            Just time ->
                H.div []
                    [ H.p [] [ text ("Timestamp: " ++ (toString time)) ]
                    , H.p [] [ text ("Date: " ++ (toString (Date.fromTime time))) ]
                    , H.p [] [ text ("Day of Week: " ++ (dayOfWeek time)) ]
                    ]

            Nothing ->
                text ""
        ]


dayOfWeek : Time -> String
dayOfWeek time =
    time
        |> Date.fromTime
        |> Date.dayOfWeek
        |> toString


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform OnTime
