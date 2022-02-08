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

adderMod :: AST.Module
adderMod = buildModule "adderModule" $ mdo
    function "f" [(T.i32, "a")] T.i32 $ \[a] -> mdo
        _entry <- block `named` "entry_0"
        rVal <- add a (AST.ConstantOperand (C.Int 32 1))
        ret $ rVal

toLLVM :: AST.Module -> IO ()
toLLVM mod = withContext $ \ctx -> do
    llvm <- withModuleFromAST ctx mod moduleLLVMAssembly
    BS.putStrLn llvm

main :: IO ()
main = toLLVM adderMod
