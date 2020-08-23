# Scrolly

Is a small program with the sole purpose to change the scroll wheel lines for 
non continues scrolling devices ( a classical mouse) from `1 .. n lines` 
(depending on how furious you scroll) to constant `3 lines` in Mac OSX.

## Compile

```
xcodebuild -target Scrolly -configuration Release
```
## How to use

To be able to use `Scrolly` you need to go to 

`Preferences -> Security & Privacy -> Accessibility` 

and then add `Scrolly`. This allows `Scrolly` to listen to change events.

After that you can start `Scrolly`, there will be no message or visual feedback.

To start `Scrolly` at login you need to go to `Preferences -> Users & Groups -> Login Items`.
