# Audit and review checklist

## Measure
```bash
# lint stats with the template rules (copy the template into pyproject first, or pass --select)
uvx ruff check --select E,W,F,I,B,UP,RUF,D,ANN --statistics src scripts

# line length per file
for f in $(git ls-files '*.py'); do
  awk -v f="$f" 'length>m{m=length} length>88{c++} END{printf "%-40s max %3d  >88: %d\n", f, m, c}' "$f"
done

# magic numbers: repeated shape literals in logic (adapt the numbers to the domain)
grep -nE "(^|[^0-9.e_a-zA-Z])(15|40|41|7|12)([^0-9.]|$)" src -r | grep -v '"""\|#'

# silent fallbacks: if/elif chains on a mode string without a final raise
grep -nE 'if .*mode ==|elif .*== "' -r src

# in-place updates on arguments
grep -nE '\] (\+|-|\*|/)= ' -r src

# tests present?
ls tests 2>/dev/null || echo "no tests"
```

## Review questions
- Does every mode/flag have an explicit `raise` for unknown values?
- Are shapes stated in docstrings and checked at entry points?
- Does any function mutate an argument without saying so?
- Are there literals that encode domain sizes? Do two equal literals mean different
  things?
- Are research numbers or dates in code comments instead of notes?
- Is every public function typed and documented (summary line ≤ 88 columns)?
- Can each output file be traced to config + commit?
- Is there a test for each transform the results depend on?

## AST equivalence (docstrings stripped)
Copy `src/` and `scripts/` to a scratch folder before the change, then:
```python
import ast, pathlib

def strip(src: str) -> str:
    tree = ast.parse(src)
    for node in ast.walk(tree):
        body = getattr(node, "body", None)
        if (isinstance(node, (ast.Module, ast.ClassDef, ast.FunctionDef, ast.AsyncFunctionDef))
                and body and isinstance(body[0], ast.Expr)
                and isinstance(getattr(body[0], "value", None), ast.Constant)
                and isinstance(body[0].value.value, str)):
            node.body = body[1:] or [ast.Pass()]
    return ast.dump(tree)

before = pathlib.Path("/path/to/scratch/before")
for p in pathlib.Path("src").rglob("*.py"):
    old = (before / p).read_text()
    if strip(old) != strip(p.read_text()):
        print("code changed:", p)
```
Expected differences (import order, intentional fixes) must be listed in the commit
message; anything else is a regression until explained.
