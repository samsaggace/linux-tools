#!/usr/bin/perl
#
# colormake.pl 0.3.1
#
# Copyright: (C) 1999, Bjarni R. Einarsson <bre@netverjar.is>
#                      http://bre.klaki.net/
# 
# Copyright: (C) 2011-2013, Cédric Le Dillau (CLD) <ld.c@free.fr>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#
# As of 0.3.1 by CLD:
#  1- add red & yellow
#  2- add debug
#  3- Suppress Make copy{right|left} banner
#  4- Add some line handlers (like Shell !)
#  ...
#  5- TODO: use %colors instead.
#

my $debug = 0;
# Some useful color codes, see end of file for more.
#
$col_ltgray =       "\033[37m";
$col_purple =       "\033[35m";
$col_yellow =       "\033[33m";
$col_red =          "\033[34m";
$col_green =        "\033[32m";
$col_cyan =         "\033[36m";
$col_brown =        "\033[33m";
$col_norm =         "\033[00m";
$col_background =   "\033[07m";
$col_brighten =     "\033[01m";
$col_underline =    "\033[04m";
$col_blink =        "\033[05m";

# Customize colors here...
#
$col_default =      $col_ltgray;
$col_gcc =          $col_purple . $col_brighten;
$col_make =         $col_cyan;
$col_filename =     $col_brown;
$col_linenum =      $col_cyan;
$col_trace =        $col_cyan;
$col_warning =      $col_green;
$col_error =        $tag_error . $col_brown . $col_brighten;
$error_highlight =  $col_brighten;
$col_shell =        $col_yellow;
$col_dependency =   $col_red;

$tag_error =        "Error: ";

# @make_3_81_copyright=(
# 'GNU Make 3.81',
# 'Copyright (C) 2006  Free Software Foundation, Inc.',
# 'This is free software; see the source for copying conditions.',
# 'There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A',
# 'PARTICULAR PURPOSE.',
# 'This program built for x86_64-redhat-linux-gnu');
#
# @remake_copyright=(
# 'GNU Make 3.82+dbg-0.7.dev',
# 'Built for x86_64-unknown-linux-gnu',
# 'Copyright (C) 2010  Free Software Foundation, Inc.',
# 'License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>',
# 'This is free software: you are free to change and redistribute it.',
# 'There is NO WARRANTY, to the extent permitted by law.');

@make_copyright=(
'GNU Make .*',
'Built for .*',
'Copyright \(C\) 2.*',
'This is free software; see the source for copying conditions.',
'There is NO warranty.*',
'There is NO WARRANTY.*',
'License GPLv3.*',
'PARTICULAR PURPOSE.*',
'This is free software: you are free to change and redistribute it.',
);

# Get size of terminal
#
$lines = shift @ARGV || 0;
$cols  = shift @ARGV || 0;
$cols -= 19;

$in = 'unknown';
while (<>)
{
    $thisline = $_;
    chomp($thisline) ;
    $orgline = $thisline;

    for $pat (@make_copyright) {
        $thisline =~ s/^$pat$//g;
    }

    $thisline =~ s/^.*Nothing to be done for.*$//g;

#    if ($thisline =~ s/^.*warning: overriding recipe for target.*$//);
#    chomp($thisline) if ($thisline =~ s/^.*warning: ignoring old recipe for target.*$//);
    # Truncate lines.
    # I suppose this is bad, but it's better than what less does!
    if ($cols >= 0)
    {
    #    $thisline =~ s/^(.{$cols}).....*(.{15})$/$1 .. $2/;
    }

    # make[1]: Entering directory `/blah/blah/blah'
    if ($thisline =~ s/^((p|g)?make\[)/$col_make$1/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/(\s*)(Prerequisite|Successfully remade target|is newer than) `(.*)'/$1$col_dependency$2 '$3'/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/(\s*)(Successfully remade target file `(.*)')/$1$col_trace$2 ($3)/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/(\s*)(Must remake target `(.*)')/$1$col_warning$2 ($3)/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/^Invoking recipe from (.*) to update target `(.*)'./$col_trace $2 (from $1)/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/(\s*)(File `(.*)' does not exist.)/$1$col_trace$2 ($3)/)
    {
        $in = 'make';
    }
    elsif ($thisline =~ s/^((g?cc|(g|c)\+\+).*)$/$col_gcc$1$col_norm/)
    {
        $in = 'gcc';
    }
    elsif ($thisline =~ s/^([pg]?make .*)$/$col_gcc$1$col_norm/)
    {
        $in = 'gcc';
    }
    elsif ($thisline =~ /^(\(|\[|a(r|wk)|c(p|d|h(mod|own))|do(ne)?|e(cho|lse)|f(ind|or)|i(f|nstall)|mv|perl|r(anlib|m(dir)?)|s(e(d|t)|trip)|tar)\s+/)
    {
        $in = $1;
    }
    elsif ($thisline =~ s/^((\+ ).*)/$col_shell$1$col_norm/ ||
           $thisline =~ s/^(\/.*)/$col_shell$1$col_norm/ ||
           $thisline =~ s/^(\.\.\/.*)/$col_shell$1$col_norm/ ||
           $thisline =~ s/##>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>/$col_shell/
            )
    {
#        chomp($thisline);
        $in = 'shell';
    }
    elsif ($thisline =~ s/##<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<</$col_norm/)
    {
#        chomp($thisline);
        $in = 'unknown';
    }

    if ($in eq 'gcc')
    {
        # Do interesting things if make is compiling something.

        if (($thisline !~ /[,:]$/) && ($thisline !~ /warning/))
        {
            # error?
            if ($cols >= 0)
            {
                # Retruncate line, because we are about to insert "Error:".
                my $c = $cols - length($tag_error);
                $thisline = $orgline;
                $thisline =~ s/^(.{$c}).....*(.{15})$/$1 .. $2/;
            }
            $thisline =~ s/(\d+:\s+)/$1$col_default$col_error/;
            $thisline = $error_highlight . $thisline . $col_norm;
        }
        else
        {
            # warning
            $thisline =~ s|(warning:\s+)(.*)$|$1$col_warning$2|;
        }

        # In file included from main.cpp:38:
        # main.cpp: In function int main(...)':
        $thisline =~ s/(In f(unction|ile))/$col_trace$1/;

        # /blah/blah/blah.cpp:123:
        $thisline =~ s|^([^:]+)|$col_filename$1$col_default|;
        $thisline =~ s|:(\d+)([:,])|:$col_linenum$1$col_default$2|;
    }
    if ( $thisline !~ m/^\s*$/ ) {
        print length($thisline), "{" if ($debug);
        if ($in ne 'shell')
        {
            print $col_norm, $col_default;
        }
        print $thisline;
        if ( length($thisline) != 5 || $thisline !~ /^\033\[..m$/ ) {
            print "\n";
        }
    }
}

print $col_norm;

# UNUSED, yet:
#
#%colors = (
#    'black'     => "\033[30m",
#    'red'       => "\033[31m",
#    'green'     => "\033[32m",
#    'yellow'    => "\033[33m",
#    'blue'      => "\033[34m",
#    'magenta'   => "\033[35m",
#    'purple'    => "\033[35m",
#    'cyan'      => "\033[36m",
#    'white'     => "\033[37m",
#    'darkgray'  => "\033[30m");

