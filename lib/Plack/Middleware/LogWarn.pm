package Plack::Middleware::LogWarn;
use strict;
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