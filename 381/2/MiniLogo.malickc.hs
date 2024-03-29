-- Cody Malick, ONID: malickc
-- Jacob Broderick: broderij

module MiniLogo where

import Prelude hiding(Num)
import Data.List

-- Data types: num var macro
type Num = Int
type Var = String
type Macro = String

-- prog ::= cmd;prog
type Prog = [Cmd]

data Mode = Up | Down
  deriving (Eq, Show)

-- expr :: = var | num | expr+expr
data Expr = Var Var
  | Num Num
  | Add Expr Expr
  deriving (Eq, Show)

-- cmd, any of the possible actions
data Cmd = Pen Mode
  | Move Expr Expr
  | Define Macro [Var] Prog
  | Call Macro [Expr]
  deriving (Eq, Show)


-- Draw a line segment from (x1, y1) (x2, y2)

line :: Cmd
line = Define "line"
  ["x1", "y1", "x2", "y2"]
  [Pen Up, Move (Var "x1") (Var "y1"), Pen Down, Move (Var "x2") (Var "y2")]
--
nix :: Cmd
nix = Define "nix" ["x1", "y1", "w", "h"]
  [Call "line" [Var "x1", Var "y1", (Add (Var "x1") (Var "w")), (Add (Var "y1") (Var "h"))]
  ,Call "line" [Var "x1", (Add (Var "y1")(Var "h")),(Add (Var "x1")(Var "w")),
  Var "y1"]]

steps :: Int -> Prog
steps 0 = []
steps count = stepHelper count ++ steps (count-1)

stepHelper :: Int -> Prog
stepHelper 0 = []
stepHelper numSteps = [Pen Up, Move (Num numSteps) (Num numSteps), Pen Down,
  Move (Num (numSteps + 1)) (Num numSteps), Move (Num (numSteps + 1)) (Num (numSteps + 1))]

-- http://learnyouahaskell.com/syntax-in-functions
macros :: Prog -> [Macro]
macros [] = []
macros (x:xs) = case x of
  (Define name _ _) -> [name]
  _ -> []
  ++ macros xs

modeHelper :: Mode -> String
modeHelper Up = "up"
modeHelper Down = "down"

exprHelper :: Expr -> String
exprHelper (Var v) = v
exprHelper (Num n) = show n
exprHelper (Add x y) = exprHelper x ++ "+" ++ exprHelper y

macroHelper :: Macro -> String
macroHelper v = v

paramHelper :: [Expr] -> String
paramHelper [] = ""
paramHelper (x:xs) = (exprHelper x) ++ "," ++ (paramHelper xs)

pretty :: Prog -> String
pretty [] = []
pretty (x:xs) = case x of
  (Pen mode) -> "\tpen " ++ (modeHelper mode) ++ ";\n"
  (Move x y) -> "\tmove (" ++ (exprHelper x) ++ "," ++ (exprHelper y) ++ ");\n"
  (Define name params program) -> "define " ++ (macroHelper name) ++ "(" ++
    (intercalate "," params) ++ ") {\n" ++ (pretty program) ++ "\n}\n"
  (Call name params) -> "\t " ++ (macroHelper name) ++ " " ++ (init (paramHelper params)) ++ ";\n"
  ++ pretty xs

optE :: Expr -> Expr
optE (Add (Num x) (Num y)) = Num ((x) + (y))
optE (Add (x) (y)) = Add (optE x) (optE y)
optE v = v

optP :: Prog -> Prog
optP [] = []
optP (x:xs) = case x of
  (Define name params program) -> [Define name params (optP program)]
  (Move x y) -> [Move (optE x) (optE y)]
  x -> [x]
  ++ optP xs
