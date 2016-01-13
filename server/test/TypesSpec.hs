module TypesSpec where

import Test.Hspec
import Data.Yaml as Y
import TestImport
import Types

spec :: Spec
spec = do
    describe "progressions" $ do
        it "parses" $ do
            eres <- Y.decodeFileEither "config/progressions.yaml"
            case eres of
                Left e -> throwIO e
                Right (_ :: Progressions) -> return ()
