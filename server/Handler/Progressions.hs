module Handler.Progressions where

import Import
import Data.NonNull

getProgressionsR :: Handler Html
getProgressionsR = do
    progressions <- appProgressions <$> getYesod
    defaultLayout $ do
        setTitle "Start Bodyweight Progressions"
        $(widgetFile "progressions")
