module Example exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Main


suite : Test
suite =
    describe "matchPattern test"
        [ test "Match pattern in text"
            (\() ->
                Expect.true "Find pattern"
                    (Main.matchPattern "folks" "That is all, folks!")
            )
        ]
