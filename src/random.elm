module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg as S exposing (circle, rect, svg)
import Svg.Attributes exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ diceView model.dieFace
        , button [ onClick Roll ] [ text "Roll" ]
        ]


diceView : Int -> Html Msg
diceView value =
    svg
        [ width "100"
        , height "100"
        , viewBox "0 0 100 100"
        ]
        [ rect
            [ x "0"
            , y "0"
            , width "100"
            , height "100"
            , rx "15"
            , ry "15"
            ]
            []
        , S.text_ [ fill "white", x "35", y "65", fontSize "50px" ]
            [ S.text (String.fromInt value) ]
        ]
