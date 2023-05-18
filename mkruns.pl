#!/usr/bin/perl

@activations = (
    "relu"
    ,"leaky_relu"
    ,"para_relu"
    ,"sigmoid"
    ,"softmax"
    ,"softplus"
    ,"softsign"
    ,"tanh"
    ,"selu"
    ,"elu"
    ,"exponential"
    )


    ;

@losses = (
    "mse"
    ,"mae"
    ,"kl_divergence"
    );

$epochs = 1000;

## limited by cuda memory on js2 1/5th GPU

$procs = 1;

for $i ( @activations ) {
    for my $j ( @losses ) {
        $cmds{$count++ % $procs} .=
            qq~python tfrun.py summary_metadata.csv config_scan.json '{"activations":["$i"],"losses":["$j"],"epochs":$epochs}' 2>&1 > runs/${i}_${j}.out\n~;
    }
}

for $i ( keys %cmds ) {
    my $f = "mkrun_$i.sh";
    ">> $f\n";
    open my $fh, ">$f";
    print $fh $cmds{$i};
    close $fh;
    print "$f\n";
}



