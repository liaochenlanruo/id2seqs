#!/usr/bin/perl -w
use strict;
# Function: Given a id file, extracting records in another file,allow double ids in a file.
# Author  : liaochenlanruo
# Date    : 2015-02-12 17:40
#-----------------------[reads ids]--------------
open ID,"seqs_id.txt" or die "Can't open ID file";
while(<ID>) {
   my @lines = split(/\s+/);

#-------------[ searching ]-------------
   open IN, "Bacilli_all_prot.fasta" or die "Failed to open IN file\n";
   open OUT, ">>seqs_to_ids.txt" or die "Failed to open OUT file\n";

   local $/ = ">";       # 用local是处于安全考虑，怕影响到后续读文件。
                         # $/ 为输入记录分隔符，默认为换行符
   <IN>;                 # 略过第一个“>”
   while (<IN>) {
      s/\r?\n>//;
      my ($head, $seq) = split "\n", $_, 2;
	  $head =~/(^G25\S+)/;
	  my $head2 = $1;
      next unless $head =~/(^G25\S+)/;
	  for (my $i=0;$i<@lines;$i++) {
		 if ($lines[$i] eq $head2) {
			 $seq =~s/\s+//g;
		     print OUT ">$lines[$i]\n$seq"."\n";
		 }
	  }
   }    
$/ = "\n";
}
close ID;
close IN;
close OUT;