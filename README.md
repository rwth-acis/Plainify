# Plainify
Extracts plain bag of words from the body text of PDF paper. Markup like title, abstract, copyright notice, running heads, references, acknowledgements, and similar are discarded. This is handy e.g. for producing plain text input for topic modeling. 

Currently it supports papers in the following formats:
- ACM 2-column proceedings paper (ACM_Plainify class)
- Springer LNCS proceedings paper (LNCS_Plainify class)

Note: the [pdftotext](http://en.wikipedia.org/wiki/Pdftotext) executable is required.

# Example
This will extract the bag of words from all PDF files in the directory, expecting those are Springer LNCS formatted papers.

```
require_relative 'Plainify'
Dir.glob('*.pdf') do |pdffile|
  textfile = "#{pdffile[0..-5]}.txt"
  LNCS_Plainify.PDFtoText pdffile, textfile
  LNCS_Plainify.CleanUpTheFilthyMessIn textfile
end
```
