#!/usr/bin/perl

#GLO June 2013
#This script is a modification of SNP_clean_rows.pl by Baute. It does very mild filtering and annotates loci to allow for manual filtering using awk. It takes a snp table, with missing data as NN or --. The first row should include the names of each sample. The first two columns are contig and pos. Note: The first column must be labelled contig. 
#The output is as follows: $1 = Contig, $2 = Position, $3 = %samples covered $4 = Heterozygosity, $5 = Minor allele frequency (total minor allele frequency for tri allelic sites), $6 = Whether it's tri-allelic, $7 onward = your samples.
#This script filters out loci with one allele (i.e. no variation) or four alleles.


use warnings;
use strict;



my %samples;
my @samples;
#my %calls;
while (<STDIN>){
	chomp;
	my $line = $_;
	my @a1 = split(/\t/, $line);
	if ($. == 1){
		print "CHROM\tPOS";
		print "\tCoverage";
		print "\tHeterozygosity";
		print "\tMajor";
		print "\tMinor1";
		print "\tMinor2";
		print "\tTriAllelic?";	
		foreach my $i (2..$#a1){

			$samples{$i}=$a1[$i];
			push(@samples,$a1[$i]);
			print "\t$a1[$i]";
		}
		print "\n";
	}else{	
		unless ((/^plastid/) || (/^\n/)){
			my $loc = "$a1[0]\t$a1[1]";
			$line =~ s/-/NN/g;
			my @a = split (/\t/,$line);
			my %calls;
			my $c;
			my $has_calls;
			my %base_count;
			my $Good = "No";
			my $tf;
			my $numberHet;	
			my $PercHet;	
			my $Coverage;
			my $Major = "0";
			my $Tri = "No";
			my $Minor1 = "0";
			my $Minor2 = "0";
#			my $Minor1count = "0";
			
			foreach my $i (2..$#a){
				$c++;			
				$calls{$samples{$i}}=$a[$i];
				$a[$i] =~ s/-/NN/;
				unless ($a[$i] eq "NN"){
					$has_calls++;
					my @bases = split('',$a[$i]);
					$base_count{$bases[0]}++;
					$base_count{$bases[1]}++;
					unless (($bases[0] eq "N")or($bases[1] eq "N")){
						if($bases[0] ne $bases[1]){
							$numberHet++;
						}
					}
				}
			}
			if($numberHet){		
				$PercHet = ($numberHet / $has_calls);
				}
			else {
				$PercHet = 0;
			}
			if($has_calls){
				$Coverage = ($has_calls/$c);
				}
			else {
				$Coverage = 0;
			}
			#if($numberHet){
			#	if(($numberHet/$has_calls)>0.5){
			#		$Good = "no";
			#	}
			#}

			# ignore this count from now on 
			delete $base_count{"N"};
			my @sort_bases = reverse sort { $base_count{$a} <=> $base_count{$b} } keys %base_count;
			my %base_order;		
			foreach my $i (0..$#sort_bases){
				$base_order{($i+1)} = $sort_bases[$i];	
			}
		
			unless ($base_order{4}){
				if ($base_order{3}){
					my $b3=$base_count{$base_order{3}};
					my $b2=$base_count{$base_order{2}};
					my $b1=$base_count{$base_order{1}};
					$Major=(1-(($b3+$b2)/($has_calls*2)));
					$Tri = "Yes";
					$Minor1 = ($b2/($has_calls*2));
					$Minor2 = ($b3/($has_calls*2));
					$Good = "Yes";
					if ( ( ($b3/($has_calls*2)) <= 0.05) and ( ($b2/($has_calls*2))>= 0.05) ) {
						$tf++;	# then its okay
					}
				}elsif ($base_order{2}){ 
					# there is 2
					my $b2=$base_count{$base_order{2}};
					my $b1=$base_count{$base_order{1}};
					$Major=(1-($b2/($has_calls*2)));
					$Minor1=($b2/($has_calls*2));
					$Tri = "No";
					$Good = "Yes";	
						if ( ($b2/($has_calls*2)) >= 0.05) { 
							#minor allele is > then 20
							$tf++;
						}else{
					}
				}elsif ($base_order{1}){
					$Good = "No";
				}
			}else {
				$Good = "No";
			}

			if ($Good eq "Yes") {
				#this one is okay to print OUT
				print "$loc";
                                print "\t".$Coverage;
                                print "\t".$PercHet;
				print "\t".$Major;
				print "\t".$Minor1;
				print "\t".$Minor2;
				print "\t".$Tri;
				foreach my $s (@samples) {
					my $x;
					my @b = split('',$calls{$s});                       
					if ($b[0] eq $b[1]){
					# is homo
						if ($b[0] eq "N"){
							$x="NN";
						}else{
							$x = "$b[0]$b[1]";
						}
					}else{
						if ( $b[0]eq "N") { # make it homo for the other
							$x = "$b[1]$b[1]";
						}elsif ( $b[1]eq "N") {
							$x = "$b[0]$b[0]"
						}else{
							$x = "$b[0]$b[1]"
						}
					}
					print "\t$x";	
				}
				print "\n";
			}
		}
	}
}




