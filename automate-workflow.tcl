package require textutil::string

proc getJobinfo {question} {
    puts -nonewline "$question: "
    flush stdout
    gets stdin answer
    set cleanedanswer [string trim [::textutil::string::capEachWord $answer]]
    isSubmissionValid $cleanedanswer $question
    return $cleanedanswer
}

proc isSubmissionValid {parameter message} {
    if {$parameter eq ""} {
		throw {Value Empty} "$message cannot be empty!"
    }	
}

proc getLastestSubmissionFile {cover_letter_resume submission_parent} {
	set folder [lindex [lsort [glob -directory $submission_parent -type d *]] end]
    return [lindex [glob -directory $folder *[file extension $cover_letter_resume]] end]
}

proc createSubmissionFolder {source destination} {
    puts "Creating $destination folder."
    file mkdir $destination
    puts "Copying $source to $destination"
    file copy $source $destination
	return $destination
}

proc createApplicationFolder {cv submission_path} {
	
	set submission_parent [file dirname $submission_path]
	set submission_folder ""
	
	if {[file exists $submission_parent]} {
		set latest_submission_file [getLastestSubmissionFile $cv $submission_parent]
	    set submission_folder [createSubmissionFolder $latest_submission_file $submission_path]
	} else {
	    set submission_folder [createSubmissionFolder $cv $submission_path]
	} 
	return $submission_folder
}

proc writeFilePathtoCoverLetterResume {path_to_fresh_cover_letter_resume} {

	set file_name "job.txt"
	set fileid [open $file_name "w"]
	puts -nonewline $fileid $path_to_fresh_cover_letter_resume
	close $fileid
}

set systemTime [clock seconds]
set yearmonthday [clock format $systemTime -format %Y%m%d-%H%M%S]

# Path to our cover letter and resume.
set coverletterresume "cover_letter_resume.odt"

try {
	
	set company_name [getJobinfo "Company Name"]
  set position [getJobinfo "Position"]
	set submission_path [file join $company_name $position $yearmonthday]
	set fresh_cover_letter_resume [createApplicationFolder $coverletterresume $submission_path]
	writeFilePathtoCoverLetterResume [file join $fresh_cover_letter_resume $coverletterresume]
	
} trap {Value Empty} {errormessage} {
   puts "$errormessage"
} trap {TCL OPERATION GLOB NOMATCH} {errormessage} {
   puts "$errormessage"
} trap {POSIX ENOENT} {errormessage} {
   puts "$errormessage"
} finally {
   puts "$argv0 exiting."
}
