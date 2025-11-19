add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] ); #handle -outdir param by splitting path and file, ...
    pushd $path; # ... cd-ing into folder first, then running makeglossaries ...

    if ( $silent ) {
        system "makeglossaries -q '$base_name'"; #unix
        # system "makeglossaries", "-q", "$base_name"; #windows
    }
    else {
        system "makeglossaries '$base_name'"; #unix
        # system "makeglossaries", "$base_name"; #windows
    };

    popd; # ... and cd-ing back again
}

# Use XeLaTeX as the default PDF generator
$ENV{'OPENOUT_ANY'} = 'r';
$pdflatex = 'xelatex %O %S';
$pdf_mode = 1;         # produce PDF
$dvi_mode = 0;         # do not produce DVI
$postscript_mode = 0;  # do not produce PS

# Add biber dependency for biblatex
add_cus_dep('bib', 'bbl', 0, 'run_biber');

sub run_biber {
    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;
    if ($silent) {
        system "biber --quiet '$base_name'";
    } else {
        system "biber '$base_name'";
    }
    popd;
}
