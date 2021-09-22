# Everything::Analysis

Run text analysis on your Everything pieces.

## Setup

```
bundle config set --local path '.bundle'
bundle install
```

Must define these environment variables:

- `EVERYTHING_PATH` - the full path to your everything repo.
- `PIECE_RELATIVE_PATH_TO_ANALYZE` - the relative path a specific everything piece that will, where the path is relative to the EVERYTHING_PATH

You can create a `.env` file with these values, if you want. Dotenv will automatically load the `.env` file.

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
