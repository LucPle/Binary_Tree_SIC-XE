# System Programming and Practice: Binary Tree Implementation

## Objective
Implement a binary tree data structure capable of holding 15 nodes and perform operations like `INPUT, LIST, DELETE, FIND`.
![캡처](https://github.com/LucPle/Binary_Tree_SIC-XE/assets/78635277/3e4ebaaf-08a6-4eb2-81ea-84d17c04659e)

## Binary Tree Definition
A binary tree named TREE was defined using the RESB directive, reserving 40 spaces, starting from index 1 to 15. The root was set at index 1 for easier traversal.

### INPUT Command
- The `INPUT` command takes a format like 'INPUT A' and adds the value A to the tree. It traverses the tree recursively from index 1 to 15 to find an empty node for insertion.
- If the array is full, it outputs 'FULL'.

### LIST Command
- The `LIST` command displays the nodes in the tree in postorder.
- It uses recursive postorder traversal starting from the root index stored in the RES array.

### DELETE Command
- The `DELETE` command sets node A and its child nodes to NULL.
- It traverses the tree to find the node and recursively sets the subtree rooted at the found node to NULL.
- If the node doesn't exist, it outputs 'NONE'.

### FIND Command
- The `FIND` command searches for element A in the tree using recursive inorder traversal.
- It maintains RES and STACK arrays for traversal and outputs the search process and the number of steps taken.
- If the element is found, it stops and displays the count. If not found, it outputs 'NONE'.

## How to use it
- Provide examples and explanations of commands and their corresponding outputs for better understanding.

### Runing the program
```shell
java -jar out/make/sictools.jar Binary_Tree.asm
```

### Sample Input/Output
- INPUT: INPUT A
- LIST: LIST (display postorder traversal output)
- DELETE: DELLETE A 
- FIND: FIND A (display inorder traversal output)

