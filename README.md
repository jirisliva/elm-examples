# elm-examples
- Examples - Demo applications to show solutios for often topics.
- Templates - Simple applications which can be usefull as starting point of new application.

## How to run examples

Go to example subdirectory and compile Elm source code into HTML/JS (index.html):
```
elm-make
```
Or just run 
```
elm-reactor
```


## Templates
Demo applications to show solutios for often topics. 
Main differences are in main function.

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
