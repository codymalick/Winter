-- Cody Malick, ONID: malickc
-- Jacob Broderick: broderij

module MiniLogo where

import Prelude


-- Data types: num var macro

-- prog ::= cmd;prog
type Prog = [Cmd]

data Mode = Up | Down

data Up = True

data Down = False

-- expr :: = var | num | expr+expr
data Expr = Var
  | Int Int
  | TwoExpr two Expr Expr

two :: Expr -> Expr -> Expr
Two _ _= undefined

-- cmd, any of the possible actions
data Cmd = pen Mode
  | move Expr Expr
  | define Macro([Var]) [Expr]
  | call Macro([Var])
