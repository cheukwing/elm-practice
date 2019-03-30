module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { reverseContent : String
    , upperContent : String
    }


init : Model
init =
    { reverseContent = ""
    , upperContent = ""
    }



-- UPDATE


type Msg
    = Reverse String
    | Upper String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reverse newContent ->
            { model | reverseContent = newContent }

        Upper newContent ->
            { model | upperContent = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.reverseContent, onInput Reverse ] []
        , div [] [ text (String.reverse model.reverseContent) ]
        , input [ placeholder "Text to upper", value model.upperContent, onInput Upper ] []
        , div [] [ text (String.toUpper model.upperContent) ]
        ]
