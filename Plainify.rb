# Turns ACM 2-column paper into a plain text word bag
#
# Usage:
#   ACM_Plainify.PDFtoText 'paper.pdf', 'paper.txt'
#	ACM_Plainify.CleanUpTheFilthyMessIn 'paper.txt'
#
class ACM_Plainify	
	def self.PDFtoText(pdffile, txtfile)
		system "pdftotext -raw -eol dos -nopgbrk #{pdffile} #{txtfile}"	
	end
	
	def self.CleanUpTheFilthyMessIn(txtfile, overwrite = true)
		text = File.open(txtfile) { |f| f.read }
		
		# Join words separated through line endings hyphenated
		text.gsub!(/\b([a-zA-Z]+)-\n([a-zA-Z]+)\b/, '\1\2')
		
		# Remove ACM permission block
		text.gsub!(/\n(Copyright is held[^\n]+)?Permission to make.+?\d{4}\s*ACM\s*\d+.+?\n(http:\/\/dx\.doi\.org[^\n]+\n)?/m, "\n")
		
		# Remove everything up to the intro
		text.gsub!(/^(.|\n)+\n1\. \b([A-Z]{2,}\b.*)\n/, '\2'+"\n")
		
		# Remove everything after acknowledgments
		text.gsub!(/\n\d+\.\sACKNOWLE[A-Z]+\n(.|\n)+\z/, '')
		
		# Remove everything after References, if any left
		text.gsub!(/\n\d+\.\sREFERENCES\s+\[1\](.|\n)+\z/, '')
		
		# Keep words only	
		text = text.downcase.scan(/\b[a-z]\w{2,}\b/).join(' ')
		
		if overwrite 
			IO.write txtfile, text 
		end
		
		return text
	end
end
	
# Turns LNCS paper into a plain text word bag
#
# Usage:
#   LNCS_Plainify.PDFtoText 'paper.pdf', 'paper.txt'
#	LNCS_Plainify.CleanUpTheFilthyMessIn 'paper.txt'
#
class LNCS_Plainify	
	def self.PDFtoText(pdffile, txtfile)
		system "pdftotext #{pdffile} #{txtfile}"	
	end
	
	def self.CleanUpTheFilthyMessIn(txtfile, overwrite = true)
		text = File.open(txtfile) { |f| f.read }
		
		# Remove running head: Authors	
		text.gsub!(/\n\d+\n\n(.+)\n/) { "\n" }
		
		# Remove running head: Title
		text.gsub!(/\n.+?\n\n\d+\n/) { "\n" }
		
		# Remove abstract, if any
		text.gsub!(/^(.|\n)+\nAbstract\.(.|\n)+?\n\n\d+\n/, "\n")
		
		# Remove acknowledgements without heading 
		text.gsub!(/\bAcknowledg(e?)ment(s?)\b\..+$/, '')
		
		# Remove acknowledgements with own heading 
		text.gsub!(/\nAcknowledg(e?)ment(s?)\b\n.+$/, '')
		
		# Remove references, if any left
		text.gsub!(/\nReferences\n(.|\n)+$/, '')
		
		# Remove Springer copyright line
		text.gsub!(/\n.+LNCS.\d+.+\d\d\d\d\..*Springer.+\n/, "\n")
		
		# Keep words only	
		text = text.scan(/\b[a-z]\w{2,}\b/i).join(' ').downcase
		
		if overwrite 
			IO.write txtfile, text 
		end
		
		return text
	end
end