module Main exposing (main, matchPattern)

import Html exposing (Html, div, input, ul, li, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    { pattern : String
    }


init : Model
init =
    { pattern = ""
    }


initList : List String
initList =
    [ "Alexandros"
    , "Antipatros"
    , "Lysimachos"
    , "Ptolemaios"
    , "Seleukos"
    ]


type Msg
    = InputPattern String


update : Msg -> Model -> Model
update msg model =
    case msg of
        InputPattern pattern ->
            { model | pattern = pattern }


view : Model -> Html Msg
view model =
    let
        filteredList =
            List.filter
                (matchPattern model.pattern)
                initList
    in
        div []
            [ input
                [ value model.pattern
                , onInput InputPattern
                ]
                []
            , ul []
                (List.map (\item -> li [] [ text item ]) filteredList)
            ]


matchPattern : String -> String -> Bool
matchPattern pattern text =
    String.contains pattern text
