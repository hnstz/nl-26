use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my %freq;

if (@ARGV == 0) {
    die "Использование: perl word_count.pl <файл>\n";
}

my $file = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $file) or die "Не удалось открыть $file: $!\n";

while (my $line = <$fh>) {
    # Явно указываем переменную $line для регулярного выражения
    while ($line =~ /(\p{L}+)/g) {
        my $word = lc($1);
        $freq{$word}++;
    }
}
close($fh);

if (%freq) {
    my @sorted = sort { $freq{$b} <=> $freq{$a} || $a cmp $b } keys %freq;
    
    print "10 самых частых слов:\n";
    for my $i (0..9) {
        last unless defined $sorted[$i];
        printf "%-15s %d\n", $sorted[$i], $freq{$sorted[$i]};
    }
} else {
    print "Слов не найдено. Проверьте файл.\n";
}