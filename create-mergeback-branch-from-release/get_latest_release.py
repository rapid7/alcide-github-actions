max_version = (0, 0, 0, 0)
with open("branches") as list_of_branches:
    for branch in list_of_branches:
        branch = branch.strip()
        words = branch.split('/')
        version = (words[-1:])
        semantic = ''.join(version)
        semantic = semantic.split('.')
        semantic = list(map(int, semantic))
        semantic_tuple = tuple(semantic)
        print(semantic_tuple)
        if semantic_tuple > max_version:
            if semantic_tuple[0] != "99"
                max_version = semantic_tuple
                branch_name = branch

#print(max_version)
print(branch_name)
