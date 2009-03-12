package Devel::Command::NewF;
use warnings;
use strict;

use base qw(Devel::Command);

our $VERSION = '0.01';

use Carp;

sub command {
  my ($arg) = (shift =~ /.*?\s+(.*)/);
  if (!$arg) {
    # Take the debugger's default.
    return 0;
  }

  (my $module = $arg) =~ s|::|/|g;

  if (!_lookit($module)) {
    eval "use $arg";        ## no critic
    if ($@) {
      (my $err = $@) =~ s/at \(eval.*$//sm;
      print DB::OUT "Failed to load $arg: $err\n";
    }
    elsif(!_lookit($module)) {
      return 0;
    }
    else {
      print DB::OUT "Loaded $arg\n";
    }
  }
  return 1;
}

sub _lookit {
  my ($file) = shift;
  my $real_file = $INC{$file};
  if ($real_file) {
    push @DB::typeahead, "f $real_file";
    return 1;
  }
  return 0;
}

sub signature { return ('f' => \&command) }


1; # Magic true value required at end of module
__END__

=head1 NAME

Devel::Command::NewF - extend debugger's 'f' command

=head1 SYNOPSIS

    # In .perldb (or perldb.ini on Windows)
    use Devel::Command;

    # Devel::Command::NewF loaded automatically

=head1 DESCRIPTION

This module extends the debugger's 'f' command so that you can simply enter
the standard module name to switch the debugger to it:

  DB<1> f My::Module

This would look for My::Module in %INC; if it was not found, we would attempt
to 'use' the module. If this also fails, we give up, with an error message. 

=head1 INTERFACE 

=head2 command()

The standard subroutine name used by Devel::Command to denote a command
implementation. YO do not need to call this routine; the debugger will do
it for you at the appropriate time.

=head2 signature

Returns 'f' and a reference to the command implementation. This is a standard
part of C<Devel::Command>'s implementation, and serves to tell the debugger
to try this version of the 'f' command first before falling back to its own.

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Failed to load %s: %s >>

We tried to load the module you requested via 'use', but it failed. The 
error we received is shown.

=item C<< Loaded %s >>

We successfully loaded the file and will witch to it.

=back


=head1 CONFIGURATION AND ENVIRONMENT

C<Devel::Command::NewF> requires that the .perldb (or perldb.ini, on Windows)
file contain a 'use' for C<Devel::Command>.

=head1 DEPENDENCIES

C<Devel::Command>.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-devel-command-newf@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Joe McMahon  C<< <mcmahon@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Joe McMahon C<< <mcmahon@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
