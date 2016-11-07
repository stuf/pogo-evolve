module Main exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class, style, type')

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
    }


init : ( Model, Cmd a )
init =
    ( { entries = [ Entry "Entry name" 10 102 12
                  , Entry "Another entry name" 5 30 25
                  ] }, Cmd.none )


-- UPDATE

type Msg
    = NoOp
    | CreateEntry Entry
    | UpdateHeadCount String Int
    | UpdateCandyCount String Int


update : Msg -> Model -> ( Model, Cmd a )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        
        CreateEntry entry ->
            ( { model
              | entries = entry :: model.entries
              }, Cmd.none )
        
        UpdateHeadCount name count ->
            ( { model
              | entries = List.map (updateHeadCount name count) model.entries
              }, Cmd.none )
        
        UpdateCandyCount name count ->
            ( model, Cmd.none )


updateHeadCount : String -> Int -> Entry -> Entry
updateHeadCount name count entry =
    if entry.name == name then { entry | headCount = count } else entry


updateCandyCount : String -> Int -> Entry -> Entry
updateCandyCount name count entry =
    if entry.name == name then { entry | candy = count } else entry


-- VIEW

view : Model -> Html a
view model =
    div
        [ style [ ( "border", "solid 1px #f00" ) ] ]
        [ viewEntries model.entries
        , viewAddEntry
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
            ]
        , tbody [] (List.map viewEntry entries)
        ]


viewEntry : Entry -> Html a
viewEntry entry =
    tr 
        []
        [ td [] [ text entry.name ]
        , td [] [ text (toString entry.headCount) ]
        , td [] [ text (toString entry.candy) ]
        , td [] [ text (toString entry.evolveCost) ]
        ]


-- TODO How to construct a record from multiple form fields
viewAddEntry : Html a
viewAddEntry =
    div []
        [ h3 [] [ text "Create entry" ]
        , form []
            [ div []
                [ label [] [ text "Name" ]
                , input [ type' "text" ] []
                ]
            , div []
                [ label [] [ text "Head count" ]
                , input [ type' "number" ] []
                ]
            , div []
                [ label [] [ text "Candy count" ]
                , input [ type' "number" ] []
                ]
            , div []
                [ button [] [ text "Create" ]
                ]
            ]
        ]
