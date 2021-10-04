# Everything::Analysis

Run text analysis on your Everything pieces.

## Setup

```
bundle config set --local path '.bundle'
bundle install
```

Must define these environment variables:

- `EVERYTHING_PATH` - the full path to your everything repo.
  - Something like `"/Users/kyle/git/everything"`
- `PIECES_RELATIVE_PATH` - the relative path to a folder in the everything repo where exists pieces you'd like to analyze
  - Something like `"novels/thoughts-of-an-eaten-sun/v5/"`
- `PIECES_GLOBS` - a Ruby glob string of pieces you'd like to analyze, separated by colons
  - Something like `"ch?:ch??"`, which finds pieces named `ch1` and `ch10` but not `character-info`

You can create a `.env` file with these values, if you want. Dotenv will automatically load the `.env` file.

Follow steps at
https://github.com/louismullie/stanford-core-nlp#using-the-latest-version-of-the-stanford-corenlp
to install the additional Stanford Core NLP files into the stanford-core-nlp gem's folder.

## Usage

```
bin/ea analyze
```

Make it easier to use by putting this in your .zshrc:

```
# For everything-analysis
export PATH=$PATH:/Users/kyle/Dropbox/code/kyletolle/everything-analysis/bin
alias ea="BUNDLE_GEMFILE=/Users/kylet/Dropbox/code/kyletolle/everything-analysis/Gemfile bundle exec ea ${@:2}"
```

If you want to use a different env file, you can do so like:
```
bundle exec dotenv -f "test.env" bin/ea generate
```

## Analytics

The following list contains the analytics that are run on the input data.

- Character Frequency
  - Tally the total number of times certain characters are used
- Whitespace Percentage
  - The percentage of characters that are whitespace vs non-whitespace



## Viewing

The results of the analysis are written to stdout.

## Options

There are not currently any options to use while running the program.

## License

MIT
