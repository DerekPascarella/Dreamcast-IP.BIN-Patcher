#!/usr/bin/perl
#
# Dreamcast IP.BIN Patcher v1.0
# Written by Derek Pascarella (ateam)
#
# A utility to apply both region flag and region text patches to a Dreamcast IP.BIN file.

# Include necessary modules.
use strict;

# Define input variables.
my $mode = $ARGV[0];
my $file = $ARGV[1];

# Define/initialize variables.
my $error;

# Invalid region flag(s) specified.
if($mode !~ /\b(?!\w*(\w)\w*\1)[JUE]+\b/i)
{
	$error = "Invalid region specified. Supported flags are:\n-J\n-JU\n-JE\n-JUE\n-U\n-UE\n-E";
	&show_error($error);
}
# Target file is missing.
elsif(!defined $file || $file eq "")
{
	$error = "No IP.BIN file specified.";
	&show_error($error);
}
# Target file doesn't exist, isn't readable, or isn't writable.
elsif(!-e $file || !-R $file || !-W $file)
{
	$error = "Specified IP.BIN file does not exist, is not readable, or is not writable.";
	&show_error($error);
}

# Patch Japan/Taiwan/Philipines region flag and region text.
if($mode =~ /J/i)
{
	&patch_bytes($file, "4A", 48);
	&patch_bytes($file, "466F72204A4150414E2C54414957414E2C5048494C4950494E45532E", 14084);
}
# Remove Japan/Taiwan/Philipines region flag and region text.
else
{
	&patch_bytes($file, "20", 48);
	&patch_bytes($file, "20202020202020202020202020202020202020202020202020202020", 14084);
}

# Patch United States/Canada region flag and region text.
if($mode =~ /U/i)
{
	&patch_bytes($file, "55", 49);
	&patch_bytes($file, "466F722055534120616E642043414E4144412E202020202020202020", 14116);
}
# Remove United States/Canada region flag and region text.
else
{
	&patch_bytes($file, "20", 49);
	&patch_bytes($file, "20202020202020202020202020202020202020202020202020202020", 14116);
}

# Patch Europe region flag and region text. 
if($mode =~ /E/i)
{
	&patch_bytes($file, "45", 50);
	&patch_bytes($file, "466F72204555524F50452E2020202020202020202020202020202020", 14148);
}
# Remove Europe region flag and region text.
else
{
	&patch_bytes($file, "20", 50);
	&patch_bytes($file, "20202020202020202020202020202020202020202020202020202020", 14148);
}

print "Dreamcast IP.BIN Patcher v1.0\n";
print "Written by Derek Pascarella (ateam)\n\n";
print "File \"$file\" patched successfully!\n";

# Subroutine to read a specified number of bytes (starting at the beginning) of a specified file,
# returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read.
sub read_bytes
{
	my $file_to_read = $_[0];
	my $bytes_to_read = $_[1];

	open my $filehandle, '<:raw', "$file_to_read" or die $!;
	read $filehandle, my $bytes, $bytes_to_read;
	close $filehandle;
	
	return unpack 'H*', $bytes;
}

# Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of
# a specified file, returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read.
# 3rd parameter - Offset at which to read.
sub read_bytes_at_offset
{
	my $file_to_read = $_[0];
	my $bytes_to_read = $_[1];
	my $read_offset = $_[2];

	open my $filehandle, '<:raw', "$file_to_read" or die $!;
	seek $filehandle, $read_offset, 0;
	read $filehandle, my $bytes, $bytes_to_read;
	close $filehandle;
	
	return unpack 'H*', $bytes;
}

# Subroutine to write a sequence of hexadecimal values to a specified file.
#
# 1st parameter - Full path of file to write.
# 2nd parameter - Hexadecimal representation of data to be written to file.
sub write_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my @hex_data_array = split(//, $hex_data);

	open my $filehandle, '>', $output_file or die $!;
	binmode $filehandle;

	for(my $i = 0; $i < @hex_data_array; $i += 2)
	{
		my($high, $low) = @hex_data_array[$i, $i + 1];
		print $filehandle pack "H*", $high . $low;
	}

	close $filehandle;
}

# Subroutine to write a sequence of hexadecimal values at a specified offset (in decimal format) into a
# specified file, as to patch the existing data at that offset.
#
# 1st parameter - Full path of file in which to insert patch data.
# 2nd parameter - Hexadecimal representation of data to be inserted.
# 3rd parameter - Offset at which to patch.
sub patch_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my $insert_offset = $_[2];
	my $hex_data_length = length($hex_data) / 2;
	
	my $data_before = &read_bytes($output_file, $insert_offset);
	my $data_after = &read_bytes_at_offset($output_file, (stat $output_file)[7] - $insert_offset - $hex_data_length, $insert_offset + $hex_data_length);
	
	&write_bytes($output_file, $data_before . $hex_data . $data_after);
}

# Subroutine to throw a specified exception.
#
# 1st parameter - Error message with which to throw exception.
sub show_error
{
	my $error = $_[0];

	die "Dreamcast IP.BIN Patcher v1.0\nWritten by Derek Pascarella (ateam)\n\n$error\n\nUsage: ip_patch <REGION> <FILE>\n";
}
