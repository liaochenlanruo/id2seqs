#!/usr/bin/perl
use strict;
use warnings;
#http://www.dxy.cn/bbs/topic/18753920
use Bio::Seq;
use Bio::SeqIO;
use Bio::DB::Fasta;
#die "Usage: input the LOCI files!" if @ARGV<1;
open LOCI, "sigma_coord.txt" || die "can't to open the LOCI files!";
my $db = Bio::DB::Fasta -> new('Bt_all_prot.faa');
my $out = Bio::SeqIO -> new (-format => 'Fasta', -file => ">sigma_seqs_coord.fasta"); # 这里的'>'是IO输出方向
while (<LOCI>){
    chomp;
    my @loci = split;
    my $seq = $db -> subseq ($loci[0], $loci[1], $loci[2]);
    my $obj = Bio::Seq -> new ( -id => $loci[0], -seq => $seq);
    $out -> write_seq($obj);
}
close LOCI;
