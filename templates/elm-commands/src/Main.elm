module Main exposing (main)

import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E


main : Program Never Model Msg
main =
    H.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { greetings : String
    }


initModel : Model
initModel =
    { greetings = "Hello"
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = GreetingInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GreetingInput newGreetings ->
            ( { model | greetings = newGreetings }, Cmd.none )


view : Model -> Html Msg
view model =
    H.div [ A.style [ ( "padding", "20px" ) ] ]
        [ H.input
            [ A.value model.greetings
            , E.onInput GreetingInput
            ]
            []
        , H.h2 [] [ H.text (model.greetings ++ " Mr. Watson!") ]
        ]
