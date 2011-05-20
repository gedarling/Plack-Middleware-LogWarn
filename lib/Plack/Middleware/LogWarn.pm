package Plack::Middleware::LogWarn;

# ABSTRACT: converts to warns to log messages

use strict;
use warnings;
use parent qw( Plack::Middleware );
use Plack::Util::Accessor qw( logger );

sub call {
   my($self, $env) = @_;

   local $SIG{__WARN__} = $self->logger || sub {
      $env->{'psgix.logger'}->({
         level => 'warn',
         message => join '', @_
      });
   };
   my $res = $self->app->($env);

   return $res;
}

1;

__END__

=head1 SYNOPSIS

builder {
   enable 'LogWarn';
   $app;
}

# use it with another logger middleware

builder {
   enable 'LogWarn';
   enable 'Log4perl', category => 'plack', conf => '/path/to/log4perl.conf';
   $app;
}

=head1 DESCRIPTION

LogWarn is a C<Plack::Middleware> component that will help you get warnings into
a logger. You probably want to use some sort of real logging system such as
L<Log::Log4perl> and another C<Plack::Middleware> such as L<Plack::Middleware::Log4perl>.

=head1 CONFIGURATION

=over 4

=item logger

optional, C<coderef> that will capture warnings. By default it uses
C<< $env->{'psgix.logger'} >> with a level of C<warn>.

=back

=head1 SEE ALSO

L<Plack::Middleware::Log4perl>

=head1 CREDITS

Thanks to Micro Technology Services, Inc. for funding the initial development
of this module and frew (Arthur Axel "fREW" Schmidt <frioux@gmail.com>) for his
extensive patience and assistance.


=cut