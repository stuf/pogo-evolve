module Main exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (class, style, type', value, placeholder)
import String exposing (toInt)

-- MAIN

main : Program Never
main =
    App.program
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


-- MODEL

type alias Entry =
    { name : String
    , headCount : Int
    , candy : Int
    , evolveCost : Int
    }


type alias Model =
    { entries : List Entry
    , nameField : String
    , headCountField : Int
    , candyField : Int
    , costField : Int
    }


init : ( Model, Cmd a )
init =
    (
        { entries =
            [ Entry "Entry name" 10 102 12
            , Entry "Another entry name" 5 30 25
            ]
        , nameField = ""
        , headCountField = 0
        , candyField = 0
        , costField = 0
        }
    , Cmd.none
    )


-- UPDATE

type Msg
    = NoOp
    | CreateEntry Entry
    | UpdateFormState FormField String
    | CreateFromForm


type FormField
    = Name
    | HeadCount
    | Candy
    | Cost


update : Msg -> Model -> ( Model, Cmd a )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        
        CreateEntry entry ->
            ( { model
              | entries = entry :: model.entries
              }, Cmd.none )
        
        UpdateFormState field value ->
            let
                model' =
                    case field of
                        HeadCount ->
                            { model | entries = List.map (updateHeadCount "headCount" (getInt value)) model.entries }

                        Cost -> model
                        _ -> model 
            in
                ( model', Cmd.none )

        CreateFromForm ->
            let
                entry =
                    Entry
                        model.nameField
                        model.headCountField
                        model.candyField
                        model.costField
            in
                ( { model
                  | entries = entry :: model.entries
                  , nameField = ""
                  , headCountField = 0
                  , candyField = 0
                  }, Cmd.none )


getInt : String -> Int
getInt value =
    case toInt value of
        Ok value' -> value'
        Err _ -> 0


updateHeadCount : String -> Int -> Entry -> Entry
updateHeadCount name count entry =
    if entry.name == name then { entry | headCount = count } else entry


updateCandyCount : String -> Int -> Entry -> Entry
updateCandyCount name count entry =
    if entry.name == name then { entry | candy = count } else entry


updateCost : String -> Int -> Entry -> Entry
updateCost name cost entry =
    if entry.name == name then { entry | evolveCost = cost } else entry


-- VIEW

view : Model -> Html Msg
view model =
    div
        [ style [ ( "border", "solid 1px #f00" ) ] ]
        [ viewEntries model.entries
        , viewAddEntry model
        ]


viewEntries : List Entry -> Html a
viewEntries entries =
    div []
        [ h3 [] [ text "Entries" ]
        , viewEntryTable entries
        ]


viewEntryTable : List Entry -> Html a
viewEntryTable entries = 
    table
        []
        [ thead []
            [ th [] [ text "Name" ]
            , th [] [ text "Head count" ]
            , th [] [ text "Candy" ]
            , th [] [ text "Cost" ]
            , th [] [ text "Maximum e's" ]
            , th [] [ text "Possible e's" ]
            ]
        , tbody [] (List.map viewEntry entries)
        ]


viewEntry : Entry -> Html a
viewEntry entry =
    let
        maximumEvos : Int
        maximumEvos =
            entry.candy // entry.headCount
        
        possibleEvos : Int
        possibleEvos =
            0
    in
        tr 
            []
            [ td [] [ text entry.name ]
            , td [] [ text (toString entry.headCount) ]
            , td [] [ text (toString entry.candy) ]
            , td [] [ text (toString entry.evolveCost) ]
            , td [] [ text (toString maximumEvos) ]
            , td [] [ text (toString possibleEvos) ]
            ]


viewAddEntry : Model -> Html Msg
viewAddEntry model =
    div []
        [ h3 [] [ text "Create entry" ]
        , form []
            [ div []
                [ label [] [ text "Name" ]
                , input
                    [ type' "text"
                    , onInput (UpdateFormState Name)
                    , value model.nameField
                    , placeholder "Name"
                    ] []
                ]
            , div []
                [ label [] [ text "Head count" ]
                , input
                    [ type' "number"
                    , onInput (UpdateFormState HeadCount)
                    , value (toString model.headCountField)
                    ]
                    []
                ]
            , div []
                [ label [] [ text "Candy count" ]
                , input
                    [ type' "number"
                    , onInput (UpdateFormState Candy)
                    , value (toString model.candyField) 
                    ]
                    []
                ]
            , div []
                [ label [] [ text "Cost" ]
                , input
                    [ type' "number"
                    , onInput (UpdateFormState Cost)
                    , value (toString model.costField)
                    ]
                    []
                ]
            , div []
                [ button
                    [ type' "button"
                    , onClick CreateFromForm
                    ]
                    [ text "Create" ]
                ]
            ]
        ]
