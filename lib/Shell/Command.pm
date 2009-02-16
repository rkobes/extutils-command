package Shell::Command;

$VERSION = 0.04;

# This must come first before ExtUtils::Command is loaded to ensure it
# takes effect.
BEGIN {
    *CORE::GLOBAL::exit = sub {
	CORE::exit($_[0]) unless caller eq 'ExtUtils::Command';

	my $exit = $_[0] || 0;
	die "exit: $exit\n";
    };
}

use ExtUtils::Command ();
use Exporter;

@ISA = qw(Exporter);
@EXPORT 	= @ExtUtils::Command::EXPORT;
@EXPORT_OK 	= @ExtUtils::Command::EXPORT_OK;


use strict;

foreach my $func (@ExtUtils::Command::EXPORT, 
		  @ExtUtils::Command::EXPORT_OK) 
{
    no strict 'refs';
    *{$func} = sub {
	local @ARGV = @_;

	my $ret;
	eval {
	    $ret = &{'ExtUtils::Command::'.$func};
	};
	if( $@ =~ /^exit: (\d+)\n$/ ) {
	    $ret = !$1;
	}
	elsif( $@ ) {
	    die $@;
	}
	else {
	    $ret = 1 unless defined $ret and length $ret;
	}

	return $ret;
    };
}


1;


=head1 NAME

Shell::Command - Cross-platform functions emulating common shell commands

=head1 SYNOPSIS

  use Shell::Command;

  mv $old_file, $new_file;
  cp $old_file, $new_file;
  touch @files;

=head1 DESCRIPTION

Thin wrapper around ExtUtils::Command. See L<ExtUtils::Command>
for a description of available commands.

=head1 AUTHOR

Michael G Schwern C<schwern@pobox.com>.

Currently maintained by
Randy Kobes C<r.kobes@uwinnipeg.ca>.

=cut
