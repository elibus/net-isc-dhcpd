package Net::ISC::DHCPd::OMAPI::Meta::Class;

=head1 NAME

Net::ISC::DHCPd::OMAPI::Meta::Class

=head1 SYNOPSIS

 use Net::ISC::DHCPd::OMAPI::Meta::Class; # not use Moose

 omapi_attr foo => (
    isa => State,
 );

 # ...

 1;

=cut

use Moose;
use Net::ISC::DHCPd::Types ':all';
use Moose::Exporter;

my @types = Net::ISC::DHCPd::Types->get_type_list;

=head1 FUNCTIONS

=head2 omapi_attr

 omapi_attr $name => %attr;

C<%attr> is by default:

 (
   is => "rw",
   predicate => "has_$name",
   traits => [qw/Net::ISC::DHCPd::OMAPI::Meta::Attribute/],
 )

It will also set "coerce => 1", when "isa" is one of L<MOOSE TYPES>.

=cut

sub omapi_attr {
    my $class = shift;
    my $name  = shift;
    my %opts  = @_;

    for my $isa (@types) {
        if($opts{'isa'} eq $isa) {
            $opts{'coerce'} = 1;
            last;
        }
    }

    $class->meta->add_attribute($name => (
        is => 'rw',
        predicate => "has_$name",
        traits => [qw/Net::ISC::DHCPd::OMAPI::Meta::Attribute/],
        %opts,
    ));
}

Moose::Exporter->setup_import_methods(
    with_caller => [qw/omapi_attr/],
    as_is => \@types,
    also => 'Moose',
);

=head1 AUTHOR

See L<Net::ISC::DHCPd>

=cut

1;