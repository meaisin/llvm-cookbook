{-# LANGUAGE RecursiveDo #-}
{-#LANGUAGE OverloadedStrings #-}

module Main where

import Data.Text.Lazy.IO as T

import qualified LLVM.AST as AST hiding (function)
import LLVM.AST.Type as T
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.IntegerPredicate as P

import Data.ByteString.Char8 as BS

import LLVM.IRBuilder.Module
import LLVM.IRBuilder.Monad
import LLVM.IRBuilder.Instruction

import LLVM.Module
import LLVM.Context

ifBasicMod :: AST.Module
ifBasicMod = buildModule "ifBasicModule" $ mdo
    function "f" [(T.i32, "a")] T.i32 $ \[a] -> mdo
        _entry <- block `named` "entry_0"
        cond <- icmp P.SGT a (AST.ConstantOperand (C.Int 32 288))
        condBr cond ifThen ifElse
        ifThen <- block
        rVal1 <- add (AST.ConstantOperand (C.Int 32 0)) (AST.ConstantOperand (C.Int 32 0))
        br ifExit
        ifElse <- block `named` "if.else"
        rVal2 <- add a (AST.ConstantOperand (C.Int 32 0))
        br ifExit
        ifExit <- block `named` "if.exit"
        rVal <- phi [(rVal1, ifThen), (rVal2, ifElse)]
        ret $ rVal

toLLVM :: AST.Module -> IO ()
toLLVM mod = withContext $ \ctx -> do
    llvm <- withModuleFromAST ctx mod moduleLLVMAssembly
    BS.putStrLn llvm

main :: IO ()
main = toLLVM ifBasicMod
