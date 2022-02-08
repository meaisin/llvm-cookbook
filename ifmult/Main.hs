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

ifMultMod :: AST.Module
ifMultMod = buildModule "ifMultModule" $ mdo
    function "f" [(T.i32, "a")] T.i32 $ \[a] -> mdo
        _entry <- block `named` "entry_0"
        cond288 <- icmp P.SGT a (AST.ConstantOperand (C.Int 32 288))
        condBr cond288 if288Then if288Else
        if288Then <- block
        rVal1 <- add (AST.ConstantOperand (C.Int 32 0)) (AST.ConstantOperand (C.Int 32 0))
        br ifExit
        if288Else <- block `named` "if.288.else"
        rVal2 <- add a (AST.ConstantOperand (C.Int 32 0))
        cond256 <- icmp P.EQ a (AST.ConstantOperand (C.Int 32 256))
        condBr cond256 if256Then if256Else
        if256Then <- block `named` "if.256.then"
        rVal3 <- add (AST.ConstantOperand (C.Int 32 0)) (AST.ConstantOperand (C.Int 32 0))
        br ifExit
        if256Else <- block `named` "if.256.else"
        br ifExit
        ifExit <- block `named` "if.exit"
        rVal <- phi [(rVal1, if288Then), (rVal2, if288Else), (rVal3, if256Then)]
        ret $ rVal

toLLVM :: AST.Module -> IO ()
toLLVM mod = withContext $ \ctx -> do
    llvm <- withModuleFromAST ctx mod moduleLLVMAssembly
    BS.putStrLn llvm

main :: IO ()
main = toLLVM ifMultMod
