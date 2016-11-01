module Main exposing (main)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


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

type alias Pokemon =
    { name : String
    , headCount : Int
    , candy : Int
    , evolveCost : Int
    }


type alias Model =
    { pokemon : List Pokemon
    }


init : ( Model, Cmd a )
init =
    ( { pokemon = [ Pokemon "Test" 12 120 50 ]
      }, Cmd.none )


-- UPDATE

type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd a )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


-- VIEW

view : Model -> Html a
view model =
    div
        [ style [ ( "border", "solid 1px #f00" ) ] ]
        [ div [] (List.map viewPokemon model.pokemon)
        ]


viewPokemon : Pokemon -> Html a
viewPokemon p =
    div []
        [ h2 [] [ text ("Pokemon: " ++ p.name) ]
        , ul []
            [ li [] [ text p.name ]
            , li [] [ headCountInput p ]
            , li [] [ text ("Cost: " ++ toString p.evolveCost) ]
            ]
        ]


headCountInput : Pokemon -> Html a
headCountInput p =
    input
        [ type' "number"
        , value <| toString p.headCount
        ]
        []
