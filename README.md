# Interlinear Extension For Quarto

This extensions provides users with a pandoc filter to include interlinear glosses in Quarto documents.

## Installing

```bash
quarto add stefanocoretta/interlinear
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

Add the following to your YAML header.

```yaml
filters:
  - interlinear
```

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

