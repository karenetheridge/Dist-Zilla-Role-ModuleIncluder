package Dist::Zilla::Plugin::ModuleIncluder;
use version;
use Moose;

use version;
use MooseX::Types::Perl 'VersionObject';

with qw/Dist::Zilla::Role::ModuleIncluder Dist::Zilla::Role::FileGatherer/;

has add_module => (
	isa => 'ArrayRef[Str]',
	traits => ['Array'],
	handles => {
		modules_to_add => 'elements',
	},
	required => 1,
);

has blacklist => (
	isa => 'ArrayRef[Str]',
	traits => ['Array'],
	handles => {
		blacklisted_modules => 'elements',
	},
	default => sub { [] },
);

has background_perl => (
	is => 'ro',
	isa => VersionObject,
	default => sub { version->new('5.008001') },
	coerce => 1,
);

has only_deps => (
	is => 'ro',
	isa => 'Bool',
	default => 0,
);

sub gather_files {
	my ($self, $arg) = @_;
	$self->include_modules({ map { ($_ => $self->only_deps ) } $self->modules_to_add }, $self->background_perl, { blacklist => [ $self->blacklisted_modules ] });
	return;
}

sub mvp_multivalue_args {
	return qw/add_module blacklist/;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

#ABSTRACT: explicitly include modules into a distribution

=for Pod::Coverage
gather_files
mvp_multivalue_args
=end

=head1 SYNOPSIS

In dist.ini:

 [ModuleIncluder]
 add_module = Foo
 add_module = Bar
 background_perl = 5.008001 #default value
 only_deps = 0 #default

=head1 DESCRIPTION

This module allows you to explicitly include a module and its dependencies in C<inc/>. At least one module must be given.

=over 4

=item * add_module

Add a module to be included. This option can be given more than once.

=item * background_perl

Set the background perl version. If the (appropriate version of the) module was present in that release of perl, it will be omitted from C<inc>. It defaults to 5.8.1.

=item * only_deps

Do not include the specified modules, only their dependencies. Note that it still includes the module if its dependencies or any of the 

=back
