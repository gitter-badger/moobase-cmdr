module Model.Tree exposing (..)

type Tree a = TreeNode a (List (Tree a))

newTree : a -> Tree a
newTree elem = TreeNode elem []

extractElem : Tree a -> a
extractElem (TreeNode elem _) = elem

appendChild: Tree a -> a -> Tree a
appendChild parent child =
    let
        (TreeNode elem existingChildren) = parent
    in
        (TreeNode elem ((TreeNode child []):: existingChildren))


appendChildAt: Tree a -> a -> (a -> Bool) -> Tree a
appendChildAt parent child location =
    let
        (TreeNode elem existingChildren) = parent
    in
        if (location elem) then
            appendChild parent child
        else
            (TreeNode elem (List.map (\x -> appendChildAt x child location) existingChildren))

findAllElemsRecursive : Tree a -> List a
findAllElemsRecursive (TreeNode elem children) =
    elem :: List.concatMap  findAllElemsRecursive children

findAllImmediateChildren : Tree a -> List a
findAllImmediateChildren (TreeNode _ children) = List.map extractElem children

