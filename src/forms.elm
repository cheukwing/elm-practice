module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Char exposing (isDigit, isLower, isUpper)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type Valid
    = Initial
    | Ok
    | Error String


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    , valid : Valid
    }


init : Model
init =
    Model "" "" "" "" Initial



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Submit


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

        Submit ->
            { model | valid = viewValidation model }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewInput "text" "Age" model.age Age
        , button [ onClick Submit ] [ text "Submit " ]
        , validationStatus model.valid
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


validationStatus : Valid -> Html msg
validationStatus valid =
    let
        ( color, txt ) =
            case valid of
                Initial ->
                    ( "black", "" )

                Ok ->
                    ( "green", "OK" )

                Error msg ->
                    ( "red", msg )
    in
    div [ style "color" color ] [ text txt ]


type alias Validation =
    { valid : Bool
    , errorMsg : String
    }


viewValidation : Model -> Valid
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
            Error errorMsg

        Nothing ->
            Ok
