package Net::DHCPd::Config::Function;

=head1 NAME

Net::DHCPd::Config::Function - parse a function

=head1 DESCRIPTION

See L<Net::DHCPd::Config::Role> for methods and attributes without
documentation.

=head1 SYNOPSIS

See L<Net::DHCPd::Config> for synopsis.

=cut

use Moose;

with 'Net::DHCPd::Config::Role';

=head1 OBJECT ATTRIBUTES

=head2 name

 $string = $self->name

Name of the the function.

=cut

has name => (
    is => 'ro',
    isa => 'Str',
);

=head2 body

 $text = $self->body

The body text of the function.

=cut

has body => (
    is => 'rw',
    isa => 'Str',
);

=head2 children

=cut

has '+children' => (
    default => sub { [undef] },
);

=head2 regex

=cut

has '+regex' => (
    default => sub { qr{^\s* on \s (\w+)}x },
);

has _depth => (
    is => 'rw',
    isa => 'ScalarRef',
    default => sub { my $i = 1; \$i },
);

=head1 METHODS

=head2 slurp

=cut

sub slurp {
    my $self  = shift;
    my $line  = shift;
    my $depth = $self->_depth;

    $$depth++ if($line =~ /{/);
    $$depth-- if($line =~ /}/);

    if($$depth) {
        $self->{'body'} .= $line;
        return "next";
    }
    else {
        chomp $self->{'body'};
        return "last";
    }
}

=head2 captured_to_args

=cut

sub captured_to_args {
    return { name => $_[1] }
}

=head2 generate

=cut

sub generate {
    my $self = shift;

    return(
        sprintf('on %s {', $self->name),
        $self->body,
        '}',
    );
}

=head1 AUTHOR

See L<Net::DHCPd>.

=cut

1;