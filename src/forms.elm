module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Char exposing (isDigit, isLower, isUpper)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    }


init : Model
init =
    Model "" "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            { model | age = age }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewInput "text" "Age" model.age Age
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


type alias Validation =
    { valid : Bool
    , errorMsg : String
    }


viewValidation : Model -> Html msg
viewValidation { password, passwordAgain, age } =
    let
        validations =
            [ Validation (String.length password > 8) "Password must be longer than 8 characters!"
            , Validation (String.any isUpper password) "Password must contain upper case character!"
            , Validation (String.any isLower password) "Password must contain lower case character!"
            , Validation (String.any isDigit password) "Password must contain numeric character!"
            , Validation (password == passwordAgain) "Passwords do not match!"
            , Validation (String.all isDigit age) "Age is not a number!"
            ]

        invalid =
            validations |> List.filter (.valid >> not) |> List.map .errorMsg |> List.head
    in
    case invalid of
        Just errorMsg ->
            div [ style "color" "red" ] [ text errorMsg ]

        Nothing ->
            div [ style "color" "green" ] [ text "OK" ]
