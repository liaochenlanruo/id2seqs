#!/usr/bin/perl
use strict;
# Function: Given a id file, extracting records in another file.
# Author  : liaochenlanruo
# Date    : 2014-08-02 21:08
# 显示搜索进度的变量，当目标文件非常大的时候很有用
   my $count = 0; # 当前处理的序列数
   my $hits  = 0; # 匹配到的序列数
   local $|  = 1; # 输出通道在每次打印或写之后都强制刷新，提高显示进度速度
my %ids_hash;
#-----------------------[reads ids]--------------
my @blastp = glob("*.blastp");
 foreach (@blastp){
   my $name = substr($_, 0, (length($_) - 7));
   my $id = $name . ".id";
   system("mkdir $name");
   open ID,"$_" or die "Can't open ID file";
   #open OUTPUT, ">$id" or die "Can't open output file";
   while(<ID>) {
      my @lines = split(/\s+/);
      my $key=shift @lines;
       next if (exists $ids_hash{$key});
       $ids_hash{$key} = 1;
       #print OUTPUT "$key\n";

               }
      
close ID;
#close OUTPUT;
# ---------show number of ids---------
my @ids = keys %ids_hash;#根据一个文件中的ID提取另一个文件中的序列sh;
my $num = @ids;
print "\nRead $num ids.\n\n";
      my $faa = $name . ".faa";
      my $sigma = $name . ".sigma";

#-------------[ searching ]-------------

open IN, "<", $faa or die "Failed to open file $faa.\n";
open OUT, ">", $sigma or die "Failed to open file $sigma.\n";

local $/ = ">";       # 用local是处于安全考虑，怕影响到后续读文件。
                      # $/ 为输入记录分隔符，默认为换行符
<IN>;                 # 略过第一个“>”
my ( $head, $seq );
while (<IN>) {
    $count++;
    s/\r?\n>//;
    ( $head, $seq ) = split "\n", $_, 2;
    $seq =~ s/\s+//g;
    
    # 根据具体情况提取id !!!!!!!!!!!!!!!!!!!!!
    # 取出记录中的id
    # next unless $head =~ /gi\|(\d+)\|/;  # gi|12313|的情况
    # next unless $head =~ /(.+?)_/;       # 我测试的例子，勿套用
    #next unless $head =~ /(.+)/;           # 整个一行作为id的情况
    next unless $head =~/(.+)/;
    # 在%ids_hash中查询记录
    if (exists $ids_hash{$1}){
        print OUT ">$head\n$seq\n";
        }
        # 如果确信目标文件中只有唯一与ID匹配的记录，则从字典中删除，提高查询速度
        # delete $ids_hash{$1};
        # record hit number of a id
        $ids_hash{$1}++;
        $hits++;
         }                        
   print "\rProcessing ${count} th record. hits: $hits";

# 显示没有匹配到任何记录的id
my @ids = grep {$ids_hash{$_} == 0} keys %ids_hash;
my $num = @ids;
print "\n\n$num ids did not match any record in $faa:\n";
print "@ids\n";
$/ = "\n";
system("mv $name.blastp $name/");
system("mv $name.sigma $name/");
}
close IN;
close OUT;
