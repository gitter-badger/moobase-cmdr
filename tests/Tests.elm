module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

import Model exposing (..)
import Model.Tree exposing (..)

all : Test
all = describe "moobase commander"
    [ hubTests
    , exampleTests
    ]

initialHub = (newHubAt (0,0))
aHub = (newHubAt (100,100))

hubTests : Test
hubTests =
    describe "A hubtree"
        [ describe "when adding children"
             [ test "given an initial hubtree, returns a new hubtree with a child" <|
                 \() ->
                    let
                        hubWithChildren = appendChild initialHubTree aHub
                    in
                        hubWithChildren |> Expect.equal (TreeNode initialHub [TreeNode aHub []])
             ]
          , describe "when listing its direct children"
            [ test "given a hub without children, then no children are returned" <|
                \() ->
                    findAllImmediateChildren initialHubTree |> Expect.equal []
            , test "given a hub with children, then return the children" <|
                \() ->
                    let
                        hubWithChildren = appendChild initialHubTree aHub
                    in
                        findAllImmediateChildren hubWithChildren |> Expect.equal [aHub]
            , test "given a hub with grandchildren, then return only the immediate children" <|
                \() ->
                    let
                        hubWithChildren = appendChild initialHubTree aHub
                        hubWithGrandchildren = appendChild initialHubTree (extractElem hubWithChildren)
                    in
                        findAllImmediateChildren hubWithGrandchildren |> Expect.equal [extractElem hubWithChildren]
            ]
        , describe "when listing all elements recursively"
              [ test "given an initial hubtree, then no children are returned" <|
                  \() ->
                      findAllElemsRecursive initialHubTree |> Expect.equal [initialHub]
              , test "given a hub with children, then return the children" <|
                  \() ->
                      let
                          hubWithChildren = appendChild initialHubTree aHub
                      in
                          findAllElemsRecursive hubWithChildren |> Expect.equal [aHub, initialHub]
              ]
        ]


exampleTests : Test
exampleTests =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Addition" <|
                \() ->
                    Expect.equal (3 + 7) 10
            , test "String.left" <|
                \() ->
                    Expect.equal "a" (String.left 1 "abcdefg")
            ]
        , describe "Fuzz test examples, using randomly generated input"
            [ fuzz (list int) "Lists always have positive length" <|
                \aList ->
                    List.length aList |> Expect.atLeast 0
            , fuzz (list int) "Sorting a list does not change its length" <|
                \aList ->
                    List.sort aList |> List.length |> Expect.equal (List.length aList)
            , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
                \i ->
                    List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
            , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
                \s1 s2 ->
                    s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
            ]
        ]
