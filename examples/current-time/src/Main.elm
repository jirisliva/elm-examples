module Main exposing (main)

import Date exposing (Day(..))
import Html as H exposing (Html, text)
import Html.Attributes as A
import Html.Events as E
import Task
import Time exposing (Time)


main =
    H.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Record =
    { day : String
    , text : String
    }


type alias Model =
    { records : List Record
    , opened : Maybe Record
    , newRecord : Maybe Record
    }


type Msg
    = OpenRecord Record
    | OnTime Time
    | NewRecord
    | RecordUpdate String
    | SaveNewRecord Record
    | CancelNewRecord


init : ( Model, Cmd Msg )
init =
    let
        model =
            { records =
                [ Record "Nedele" "Dnes jsem byl delsi dobe"
                , Record "Pondeli" "Zitra pujdeme"
                ]
            , opened = Nothing
            , newRecord = Nothing
            }
    in
        ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenRecord record ->
            ( { model | opened = Just record }
            , Cmd.none
            )

        NewRecord ->
            ( model, getTime )

        OnTime time ->
            ( { model | newRecord = Just (Record (dayOfWeek time) "") }
            , Cmd.none
            )

        RecordUpdate text ->
            case model.newRecord of
                Just record ->
                    ( { model | newRecord = Just (Record record.day text) }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        CancelNewRecord ->
            ( { model | newRecord = Nothing }
            , Cmd.none
            )

        SaveNewRecord record ->
            ( { model
                | newRecord = Nothing
                , records = record :: model.records
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    H.div []
        [ viewButtons
        , viewOpenedRecord model.opened
        , viewNewRecord model.newRecord
        , viewNewRecordButtons model.newRecord
        , viewRecordList model.records
        ]


viewButtons : Html Msg
viewButtons =
    H.div []
        [ H.button [ E.onClick NewRecord ]
            [ H.text "Nový záznam" ]
        ]


viewRecordList : List Record -> Html Msg
viewRecordList records =
    H.div [ A.class "records" ]
        (records
            |> List.map
                (\record ->
                    H.p [] [ viewRecordLine record ]
                )
        )


viewOpenedRecord : Maybe Record -> Html Msg
viewOpenedRecord maybeRecord =
    H.div []
        [ case maybeRecord of
            Just r ->
                viewRecord r

            Nothing ->
                H.text ""
        ]


viewRecord : Record -> Html Msg
viewRecord record =
    H.div [ A.class "opened-record" ]
        [ H.p [] [ H.b [] [ H.text record.day ] ]
        , H.p [] [ H.text record.text ]
        ]


viewRecordLine : Record -> Html Msg
viewRecordLine record =
    H.div
        [ A.class "record-line"
        , E.onClick (OpenRecord record)
        ]
        [ H.span [] [ H.b [] [ text record.day ] ]
        , H.span [] [ text ": " ]
        , H.span [] [ text record.text ]
        ]


viewNewRecord : Maybe Record -> Html Msg
viewNewRecord maybeRecord =
    case maybeRecord of
        Just record ->
            H.div []
                [ H.p [] [ H.text record.day ]
                , H.textarea
                    [ A.value record.text
                    , E.onInput RecordUpdate
                    ]
                    []
                ]

        Nothing ->
            H.text ""


viewNewRecordButtons : Maybe Record -> Html Msg
viewNewRecordButtons maybeRecord =
    case maybeRecord of
        Just record ->
            H.div []
                [ H.button [ E.onClick CancelNewRecord ] [ H.text "Zrušit" ]
                , H.button [ E.onClick (SaveNewRecord record) ] [ H.text "Uložit" ]
                ]

        Nothing ->
            text ""


dayOfWeek : Time -> String
dayOfWeek time =
    let
        day =
            time
                |> Date.fromTime
                |> Date.dayOfWeek
    in
        case day of
            Mon ->
                "Pondeli"

            Tue ->
                "Utery"

            Wed ->
                "Streda"

            Thu ->
                "Ctvrtek"

            Fri ->
                "Patek"

            Sat ->
                "Sobota"

            Sun ->
                "Nedele"


getTime =
    Time.now
        |> Task.perform OnTime
