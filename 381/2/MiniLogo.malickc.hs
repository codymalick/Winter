-- Cody Malick, ONID: malickc
-- Jacob Broderick: broderij

module MiniLogo where

import Prelude hiding(Num)

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
