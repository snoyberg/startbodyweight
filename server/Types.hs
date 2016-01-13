module Types where

import ClassyPrelude
import Data.NonNull
import Data.Aeson
import Database.Persist.Sql

newtype ExerciseShort = ExerciseShort Text
    deriving (Show, Eq, Ord, ToJSON, FromJSON, PersistField, PersistFieldSql)
data Exercise = Exercise
    { exerciseDisplay :: !Text
    , exerciseShort :: !ExerciseShort
    }
    deriving Show
instance FromJSON Exercise where
    parseJSON = withObject "Exercise" $ \o -> Exercise
        <$> o .: "display"
        <*> o .: "short"

newtype ProgressionShort = ProgressionShort Text
    deriving (Show, Eq, Ord, ToJSON, FromJSON, PersistField, PersistFieldSql)
data Progression = Progression
    { progressionDisplay :: !Text
    , progressionShort :: !ProgressionShort
    , progressionExercises :: !(Vector Exercise)
    }
    deriving Show
instance FromJSON Progression where
    parseJSON = withObject "Progression" $ \o -> Progression
        <$> o .: "display"
        <*> o .: "short"
        <*> o .: "exercises"

data ProgressionChoice = PCAlways Progression
                       | PCRotate (NonNull (Vector Progression))
    deriving Show
instance FromJSON ProgressionChoice where
    parseJSON v@(Object _) = PCAlways <$> parseJSON v
    parseJSON (Array vs) = do
        ps <- mapM parseJSON vs
        case fromNullable ps of
            Nothing -> fail "ProgressionChoice with no choices"
            Just x -> return $ PCRotate x
    parseJSON _ = fail "ProgressionChoice"

type Progressions = Vector ProgressionChoice
