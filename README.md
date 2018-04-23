# elm-examples
- Templates - Simple applications which can be usefull as starting point of new application.
- Examples - Demo applications to show solutios for often topics.

## How to run examples

Just go to example sub-directory and run:
```
elm-reator
```


## Templates

- **elm-basic** - _Hello World_, Nothing more.
```
main : Html msg
main =
    text "Hello, World!"
```

- **elm-updates** - Application using update function.
```
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
```

- **elm-commands** - Application using Commands.
```
main : Program Never Model Msg
main =
    H.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
```