#!/usr/bin/perl

use POSIX;

my @scene_names = ("rgb", "rgby", "rand10k", "rand100k", "biglittle", "littlebig", "pattern", "bouncingballs", "hypnosis", "fireworks", "snow", "snowsingle");
my @score_scene_names = ("rgb", "rand10k", "rand100k", "pattern", "snowsingle", "biglittle");

my %fast_times;

my $perf_points = 10;
my $correctness_points = 2;

my %correct;

my %your_times;

`mkdir -p logs`;
`rm -rf logs/*`;

print "\n";
print ("--------------\n");
my $hostname = `hostname`;
print ("Running tests on $hostname\n");
print ("--------------\n");

my $render_ref = "render_ref";
if (index(lc($hostname),"ghc") == -1) {
    $render_ref = "render_ref_latedays";
}

foreach my $scene (@scene_names) {
    print ("\nScene : $scene\n");
    my @sys_stdout = system ("./render -c $scene -s 1024 > ./logs/correctness_${scene}.log");
    my $return_value  = $?;
    if ($return_value == 0) {
        print ("Correctness passed!\n");
        $correct{$scene} = 1;
    }
    else {
        print ("Correctness failed ... Check ./logs/correctness_${scene}.log\n");
        $correct{$scene} = 0;
    }

    if (${scene} ~~ @score_scene_names) {
        my $your_time = `./render -r cuda -b 0:4 $scene -s 1024 | tee ./logs/time_${scene}.log | grep Total:`;
        chomp($your_time);
        $your_time =~ s/^[^0-9]*//;
        $your_time =~ s/ ms.*//;

        print ("Your time : $your_time\n");
        $your_times{$scene} = $your_time;

        my $fast_time = `./$render_ref -r cuda -b 0:4 $scene -s 1024 | tee ./logs/time_${scene}.log | grep Total:`;
        chomp($fast_time);
        $fast_time =~ s/^[^0-9]*//;
        $fast_time =~ s/ ms.*//;

        print ("Reference Time: $fast_time\n");
        $fast_times{$scene} = $fast_time;
    }
}

print "\n";
print ("------------\n");
print ("Score table:\n");
print ("------------\n");

my $header = sprintf ("| %-15s | %-15s | %-15s | %-15s |\n", "Scene Name", "Fast Time (Tf)", "Your Time (T)", "Score");
my $dashes = $header;
$dashes =~ s/./-/g;
print $dashes;
print $header;
print $dashes;

my $total_score = 0;

foreach my $scene (@score_scene_names){
    my $score;
    my $your_time = $your_times{$scene};
    my $fast_time = $fast_times{$scene};

    if ($correct{$scene}) {
        if ($your_time <= 1.20 * $fast_time) {
            $score = $perf_points + $correctness_points;
        }
        elsif ($your_time > 10 * $fast_time) {
            $score = $correctness_points;
        }
        else {
            $score = $correctness_points + ceil ($perf_points * ($fast_time /$your_time));
        }
    }
    else {
        $your_time .= " (F)";
        $score = 0;
    }

    printf ("| %-15s | %-15s | %-15s | %-15s |\n", "$scene", "$fast_time", "$your_time", "$score");
    $total_score += $score;
}
print $dashes;
printf ("| %-15s   %-15s | %-15s | %-15s |\n", "", "", "Total score:",
    $total_score . "/" . ($perf_points+$correctness_points) * ($#score_scene_names + 1));
print $dashes;
